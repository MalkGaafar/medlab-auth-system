namespace MedLab.Api.Models.Entities;

public class UserRole
{
    public Guid UserId { get; set; }
    public int RoleId { get; set; }
    public DateTime AssignedAt { get; set; }
}
