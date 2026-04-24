using System.Security.Cryptography;
using System.Text;
using MedLab.Api.Models.DTOs.Auth;
using MedLab.Api.Models.Entities;
using MedLab.Api.Models.Enums;
using MedLab.Api.Repositories.Interfaces;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

public class AuthService : IAuthService
{
    private readonly IUserRepository _users;
    private readonly IRoleRepository _roles;
    private readonly ISessionRepository _sessions;
    private readonly IRefreshTokenRepository _refreshTokens;
    private readonly IPasswordHasher _hasher;
    private readonly IJwtService _jwt;
    private readonly IRbacService _rbac;
    private readonly IRateLimitService _rateLimit;
    private readonly IConfiguration _config;

    private static readonly TimeSpan DefaultRefreshLifetime = TimeSpan.FromDays(14);

    public AuthService(
        IUserRepository users, IRoleRepository roles, ISessionRepository sessions,
        IRefreshTokenRepository refreshTokens,
        IPasswordHasher hasher, IJwtService jwt, IRbacService rbac, IRateLimitService rateLimit,
        IConfiguration config)
    {
        _users = users; _roles = roles; _sessions = sessions;
        _refreshTokens = refreshTokens;
        _hasher = hasher; _jwt = jwt; _rbac = rbac; _rateLimit = rateLimit;
        _config = config;
    }

    // ───────────────────────── Register ─────────────────────────
    public async Task<AuthResponse> RegisterAsync(RegisterRequest req)
    {
        if (await _users.EmailExistsAsync(req.Email))
            throw new InvalidOperationException("Email is already registered.");

        var roleName = req.Role?.Trim();
        if (string.IsNullOrWhiteSpace(roleName)) roleName = "Patient";

        if (string.Equals(roleName, RoleName.Admin, StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Admin accounts cannot self-register.");

        var role = await _roles.GetByNameAsync(roleName)
            ?? throw new InvalidOperationException($"Role '{roleName}' does not exist. Did you run schema.sql?");

        var (hash, salt) = _hasher.HashPassword(req.Password);

        bool requiresApproval = RoleName.RequiresApproval.Contains(role.RoleName);

        var user = new User
        {
            Id           = Guid.NewGuid(),
            UserName     = req.UserName,
            Email        = req.Email,
            PasswordHash = hash,
            PasswordSalt = salt,
            CreatedAt    = DateTime.UtcNow,
            IsActive     = true,
            IsApproved   = !requiresApproval
        };
        await _users.CreateAsync(user);
        await _roles.AssignRoleAsync(user.Id, role.Id);

        if (requiresApproval)
        {
            return new AuthResponse
            {
                PendingApproval = true,
                Message = $"Registration successful. Your {role.RoleName} account is pending admin approval."
            };
        }

        return await BuildAuthResponseAsync(user, "Registration successful.");
    }

    // ───────────────────────── Login ─────────────────────────
    public async Task<AuthResponse> LoginAsync(LoginRequest req)
    {
        await _rateLimit.EnsureNotLockedOutAsync(req.Email);

        var user = await _users.GetByEmailAsync(req.Email);

        if (user is null || !user.IsActive || !_hasher.Verify(req.Password, user.PasswordHash, user.PasswordSalt))
        {
            await _rateLimit.RecordFailureAsync(req.Email);
            throw new UnauthorizedAccessException("Invalid email or password.");
        }

        if (!user.IsApproved)
        {
            await _rateLimit.RecordFailureAsync(req.Email);
            return new AuthResponse
            {
                PendingApproval = true,
                Message = "Your account is pending admin approval."
            };
        }

        await _rateLimit.RecordSuccessAsync(req.Email);
        return await BuildAuthResponseAsync(user, "Login successful.");
    }

    // ───────────────────────── Logout ─────────────────────────
    public Task LogoutAsync(string tokenId) => _sessions.RevokeAsync(tokenId);

    // ───────────────────────── Me ─────────────────────────
    public async Task<UserDto> GetMeAsync(Guid userId)
    {
        var user = await _users.GetByIdAsync(userId)
            ?? throw new InvalidOperationException("User not found.");
        var roles = (await _roles.GetUserRoleNamesAsync(userId)).ToList();
        return new UserDto
        {
            Id          = user.Id,
            UserName    = user.UserName,
            Email       = user.Email,
            Roles       = roles,
            Permissions = _rbac.GetPermissionsForRoles(roles).ToList(),
            IsApproved  = user.IsApproved
        };
    }

    // ───────────────────────── Refresh ─────────────────────────
    public async Task<AuthResponse> RefreshAsync(string refreshToken)
    {
        if (string.IsNullOrWhiteSpace(refreshToken))
            throw new UnauthorizedAccessException("Refresh token is required.");

        var hash    = HashToken(refreshToken);
        var stored  = await _refreshTokens.GetByHashAsync(hash);

        if (stored is null)
            throw new UnauthorizedAccessException("Invalid refresh token.");

        if (stored.IsRevoked)
        {
            // Token reuse detected → revoke the entire family for safety.
            await _refreshTokens.RevokeAllForUserAsync(stored.UserId);
            await _sessions.RevokeAllForUserAsync(stored.UserId);
            throw new UnauthorizedAccessException("Refresh token has been revoked.");
        }

        if (stored.ExpiresAt <= DateTime.UtcNow)
            throw new UnauthorizedAccessException("Refresh token has expired.");

        var user = await _users.GetByIdAsync(stored.UserId);
        if (user is null || !user.IsActive || !user.IsApproved)
            throw new UnauthorizedAccessException("User is no longer allowed to sign in.");

        // Revoke the old refresh token's access session too (best-effort).
        if (!string.IsNullOrEmpty(stored.AccessJti))
            await _sessions.RevokeAsync(stored.AccessJti);

        var response = await BuildAuthResponseAsync(user, "Token refreshed.");

        // Rotate: mark old refresh token as replaced by the new one.
        await _refreshTokens.MarkRotatedAsync(hash, HashToken(response.RefreshToken!));

        return response;
    }

    // ──────────────────────────────────────────────────────────
    //  Helpers
    // ──────────────────────────────────────────────────────────
    private async Task<AuthResponse> BuildAuthResponseAsync(User user, string message)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(user.Id)).ToList();
        var (token, tokenId, expiresAt) = _jwt.GenerateToken(user, roles);

        await _sessions.CreateAsync(new Session
        {
            UserId    = user.Id,
            TokenId   = tokenId,
            ExpiresAt = expiresAt
        });

        // Issue a fresh refresh token alongside the access token.
        var refreshRaw       = GenerateRefreshTokenRaw();
        var refreshHash      = HashToken(refreshRaw);
        var refreshExpiresAt = DateTime.UtcNow + GetRefreshLifetime();

        await _refreshTokens.CreateAsync(new RefreshToken
        {
            UserId    = user.Id,
            TokenHash = refreshHash,
            AccessJti = tokenId,
            ExpiresAt = refreshExpiresAt,
            IsRevoked = false
        });

        return new AuthResponse
        {
            Token                 = token,
            ExpiresAt             = expiresAt,
            RefreshToken          = refreshRaw,
            RefreshTokenExpiresAt = refreshExpiresAt,
            Message               = message,
            PendingApproval       = false,
            User = new UserDto
            {
                Id          = user.Id,
                UserName    = user.UserName,
                Email       = user.Email,
                Roles       = roles,
                Permissions = _rbac.GetPermissionsForRoles(roles).ToList(),
                IsApproved  = user.IsApproved
            }
        };
    }

    private TimeSpan GetRefreshLifetime()
    {
        var days = _config["Jwt:RefreshTokenDays"];
        if (int.TryParse(days, out var d) && d > 0) return TimeSpan.FromDays(d);
        return DefaultRefreshLifetime;
    }

    /// <summary>Generates a 256-bit cryptographically random URL-safe token.</summary>
    private static string GenerateRefreshTokenRaw()
    {
        var bytes = RandomNumberGenerator.GetBytes(32);
        return Convert.ToBase64String(bytes)
            .Replace('+', '-').Replace('/', '_').TrimEnd('=');
    }

    private static string HashToken(string raw)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(raw));
        return Convert.ToHexString(bytes); // 64 chars
    }
}
