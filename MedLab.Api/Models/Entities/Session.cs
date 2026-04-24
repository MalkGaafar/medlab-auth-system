namespace MedLab.Api.Models.Entities;

public class Session
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string TokenId { get; set; } = string.Empty; // JWT jti
    public DateTime CreatedAt { get; set; }
    public DateTime ExpiresAt { get; set; }
    public bool IsRevoked { get; set; }
}
