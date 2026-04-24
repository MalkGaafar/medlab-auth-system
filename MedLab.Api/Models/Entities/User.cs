namespace MedLab.Api.Models.Entities;

public class User
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string PasswordSalt { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public bool IsActive { get; set; } = true;

    public bool IsDeleted { get; set; } 
    public DateTime? DeletedAt { get; set; }
    public bool IsApproved { get; set; } = false;
}
