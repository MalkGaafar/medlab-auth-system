using MedLab.Api.Models.DTOs.Reports;

namespace MedLab.Api.Services.Interfaces;

public interface IReportService
{
    /// <summary>Returns reports the caller is allowed to see (all for doctor/admin/specialist, own for patient).</summary>
    Task<IEnumerable<ReportDto>> GetVisibleReportsAsync(Guid currentUserId);

    Task<ReportDto> CreateAsync(Guid currentUserId, CreateReportRequest req);

    /// <summary>Doctor claims a report. Throws if already assigned to another doctor.</summary>
    Task<ReportDto> AssignToSelfAsync(Guid currentUserId, int reportId);

    /// <summary>Doctor adds the final verdict. Auto-claims if unassigned, rejects if claimed by someone else.</summary>
    Task<ReportDto> UpdateVerdictAsync(Guid currentUserId, int reportId, string verdict);

    Task DeleteAsync(Guid currentUserId, int reportId);
}
