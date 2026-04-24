namespace MedLab.Api.Models.DTOs.Admin;

public class AdminUserDto
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public bool IsActive { get; set; }
    public bool IsApproved { get; set; }
    public List<string> Roles { get; set; } = new();
    public List<string> Permissions { get; set; } = new();
}

public class UpdateRoleRequest
{
    public string Role { get; set; } = string.Empty;
    public string Action { get; set; } = "add"; // "add" | "remove"
}

public class ApprovalRequest
{
    public bool Approve { get; set; } = true;
}
