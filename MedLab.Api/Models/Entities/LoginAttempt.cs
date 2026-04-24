namespace MedLab.Api.Models.Entities;

public class LoginAttempt
{
    public int Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public DateTime AttemptedAt { get; set; }
    public bool Success { get; set; }
}
