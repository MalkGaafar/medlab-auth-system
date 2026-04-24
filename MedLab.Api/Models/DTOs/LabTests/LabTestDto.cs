using System.ComponentModel.DataAnnotations;

namespace MedLab.Api.Models.DTOs.LabTests;

public class LabTestDto
{
    public int Id { get; set; }
    public string TestName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? NormalRange { get; set; }
    public Guid? CreatedByUserId { get; set; }
    public string? CreatedByName { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>Specialist creates a new lab test definition + the normal range.</summary>
public class CreateLabTestRequest
{
    [Required, StringLength(200, MinimumLength = 2)]
    public string TestName { get; set; } = string.Empty;

    [StringLength(2000)]
    public string? Description { get; set; }

    [Required, StringLength(500, MinimumLength = 1)]
    public string NormalRange { get; set; } = string.Empty;
}

