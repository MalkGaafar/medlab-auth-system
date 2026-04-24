namespace MedLab.Api.Models.Entities;

public class LabTest
{
    public int Id { get; set; }
    public string TestName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? NormalRange { get; set; }
    public Guid? CreatedByUserId { get; set; }
    public DateTime CreatedAt { get; set; }
}
