namespace MedLab.Api.Models.Entities;

public class ClinicalReport
{
    public int Id { get; set; }
    public int? LabTestId { get; set; }
    public Guid UserId { get; set; }                  // patient owner
    public Guid? CreatedByUserId { get; set; }        // specialist who created the lab result
    public Guid? AssignedDoctorId { get; set; }       // doctor who claimed the report
    public int? UrgencyLevel { get; set; }
    public string? LabTestName { get; set; }
    public string? Findings { get; set; }
    public string? Result { get; set; }
    public string? NormalRange { get; set; }
    public string? Notes { get; set; }
    public string? FinalVerdict { get; set; }
    public DateTime ReportDate { get; set; }
    public DateTime? VerdictGivenAt { get; set; }
}
