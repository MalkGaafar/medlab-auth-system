namespace MedLab.Api.Models.Entities;

public class RefreshToken
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    /// <summary>SHA-256 hex of the raw refresh token. We never store the raw value.</summary>
    public string TokenHash { get; set; } = string.Empty;
    /// <summary>The jti of the access token issued together with this refresh token.</summary>
    public string? AccessJti { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime ExpiresAt { get; set; }
    public bool IsRevoked { get; set; }
    /// <summary>Hash of the refresh token that replaced this one (rotation).</summary>
    public string? ReplacedBy { get; set; }
}
