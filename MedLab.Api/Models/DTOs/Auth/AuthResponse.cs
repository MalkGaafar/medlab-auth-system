namespace MedLab.Api.Models.DTOs.Auth;

public class AuthResponse
{
    public string? Token { get; set; }
    public DateTime? ExpiresAt { get; set; }

    /// <summary>Long-lived refresh token. Null when registration is pending approval.</summary>
    public string? RefreshToken { get; set; }
    public DateTime? RefreshTokenExpiresAt { get; set; }

    public UserDto? User { get; set; }
    public bool PendingApproval { get; set; }
    public string Message { get; set; } = string.Empty;
}

public class UserDto
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public List<string> Roles { get; set; } = new();
    public List<string> Permissions { get; set; } = new();
    public bool IsApproved { get; set; }
}
