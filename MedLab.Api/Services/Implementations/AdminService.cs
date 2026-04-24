using MedLab.Api.Models.DTOs.Admin;
using MedLab.Api.Models.Enums;
using MedLab.Api.Repositories.Interfaces;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

public class AdminService : IAdminService
{
    private readonly IUserRepository _users;
    private readonly IRoleRepository _roles;
    private readonly ISessionRepository _sessions;
    private readonly IRefreshTokenRepository _refreshTokens;
    private readonly IRbacService _rbac;

    public AdminService(
        IUserRepository users, IRoleRepository roles,
        ISessionRepository sessions, IRefreshTokenRepository refreshTokens,
        IRbacService rbac)
    {
        _users = users; _roles = roles;
        _sessions = sessions; _refreshTokens = refreshTokens;
        _rbac = rbac;
    }

    public async Task<IEnumerable<AdminUserDto>> GetAllUsersAsync()
    {
        var users = (await _users.GetAllAsync()).ToList();
        var result = new List<AdminUserDto>(users.Count);
        foreach (var u in users)
        {
            var roles = (await _roles.GetUserRoleNamesAsync(u.Id)).ToList();
            result.Add(new AdminUserDto
            {
                Id          = u.Id,
                UserName    = u.UserName,
                Email       = u.Email,
                CreatedAt   = u.CreatedAt,
                IsActive    = u.IsActive,
                IsApproved  = u.IsApproved,
                Roles       = roles,
                Permissions = _rbac.GetPermissionsForRoles(roles).ToList()
            });
        }
        return result;
    }

    public async Task<IEnumerable<AdminUserDto>> GetPendingUsersAsync()
        => (await GetAllUsersAsync()).Where(u => !u.IsApproved).ToList();

    public async Task SetApprovalAsync(Guid currentUserId, Guid targetUserId, bool approve)
    {
        var user = await _users.GetByIdAsync(targetUserId)
            ?? throw new InvalidOperationException("User not found.");

        if (currentUserId == targetUserId)
            throw new InvalidOperationException("You cannot change your own approval status.");

        await _users.SetApprovedAsync(targetUserId, approve);

        // Always revoke sessions + refresh tokens on approval change.
        await _sessions.RevokeAllForUserAsync(targetUserId);
        await _refreshTokens.RevokeAllForUserAsync(targetUserId);
    }

    public async Task UpdateUserRoleAsync(Guid currentUserId, Guid targetUserId, UpdateRoleRequest req)
    {
        if (!RoleName.All.Contains(req.Role))
            throw new InvalidOperationException($"Invalid role '{req.Role}'.");
        if (req.Action != "add" && req.Action != "remove")
            throw new InvalidOperationException("Action must be 'add' or 'remove'.");

        if (targetUserId == currentUserId && req.Role == RoleName.Admin && req.Action == "remove")
            throw new InvalidOperationException("You cannot remove your own Admin role.");

        var role = await _roles.GetByNameAsync(req.Role)
            ?? throw new InvalidOperationException($"Role '{req.Role}' does not exist.");

        if (req.Action == "add")
            await _roles.AssignRoleAsync(targetUserId, role.Id);
        else
            await _roles.RemoveRoleAsync(targetUserId, role.Id);

        // Force re-login so claims are refreshed.
        await _sessions.RevokeAllForUserAsync(targetUserId);
        await _refreshTokens.RevokeAllForUserAsync(targetUserId);
    }

    /// <summary>
    /// SOFT delete: marks the user as deleted but preserves their reports
    /// and lab tests. Historical references will render as "[Deleted] {name}".
    /// </summary>
    public async Task DeleteUserAsync(Guid currentUserId, Guid targetUserId)
    {
        if (currentUserId == targetUserId)
            throw new InvalidOperationException("You cannot delete your own account.");

        var user = await _users.GetByIdAsync(targetUserId)
            ?? throw new InvalidOperationException("User not found.");

        // Kill any active access tokens + refresh tokens immediately.
        await _sessions.RevokeAllForUserAsync(targetUserId);
        await _refreshTokens.RevokeAllForUserAsync(targetUserId);

        // Soft-delete (UPDATE Users SET IsDeleted=1, ...). No FK conflicts.
        await _users.DeleteAsync(targetUserId);
    }
}
