using System.ComponentModel.DataAnnotations;

namespace MedLab.Api.Models.DTOs.Reports;

/// <summary>Specialist creates a clinical report (a lab result for a patient).</summary>
public class CreateReportRequest
{
    [Required]
    public Guid PatientId { get; set; }

    [Required]
    public int LabTestId { get; set; }

    [Range(1, 5)]
    public int? UrgencyLevel { get; set; }

    [Required, StringLength(500, MinimumLength = 1)]
    public string Result { get; set; } = string.Empty;

    [StringLength(4000)]
    public string? Findings { get; set; }

    [StringLength(4000)]
    public string? Notes { get; set; }
}