using MedLab.Api.Models.DTOs.Auth;

namespace MedLab.Api.Services.Interfaces;

public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterRequest req);
    Task<AuthResponse> LoginAsync(LoginRequest req);
    Task LogoutAsync(string tokenId);
    Task<UserDto> GetMeAsync(Guid userId);

    /// <summary>
    /// Validate a refresh token, rotate it (issue a new one), and return a new
    /// access token + refresh token pair. Throws UnauthorizedAccessException on failure.
    /// </summary>
    Task<AuthResponse> RefreshAsync(string refreshToken);
}
