namespace MedLab.Api.Models.DTOs.Reports;

public class ReportDto
{
    public int Id { get; set; }
    public Guid PatientId { get; set; }
    public string PatientName { get; set; } = string.Empty;

    public Guid? CreatedByUserId { get; set; }
    public string? CreatedByName { get; set; }

    public Guid? AssignedDoctorId { get; set; }
    public string? AssignedDoctorName { get; set; }

    public int? LabTestId { get; set; }
    public string? LabTestName { get; set; }

    public int? UrgencyLevel { get; set; }
    public string? Findings { get; set; }
    public string? Result { get; set; }
    public string? NormalRange { get; set; }
    public string? Notes { get; set; }
    public string? FinalVerdict { get; set; }

    public DateTime ReportDate { get; set; }
    public DateTime? VerdictGivenAt { get; set; }

    public bool HasFinalVerdict => !string.IsNullOrWhiteSpace(FinalVerdict);
    public bool IsAssigned => AssignedDoctorId.HasValue;
}
