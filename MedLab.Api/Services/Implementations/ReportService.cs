using MedLab.Api.Models.DTOs.Reports;
using MedLab.Api.Models.Entities;
using MedLab.Api.Models.Enums;
using MedLab.Api.Repositories.Interfaces;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

public class ReportService : IReportService
{
    private readonly IReportRepository _reports;
    private readonly IUserRepository _users;
    private readonly IRoleRepository _roles;
    private readonly ILabTestRepository _tests;
    private readonly IRbacService _rbac;

    public ReportService(
        IReportRepository reports, IUserRepository users, IRoleRepository roles,
        ILabTestRepository tests, IRbacService rbac)
    {
        _reports = reports; _users = users; _roles = roles; _tests = tests; _rbac = rbac;
    }

    public async Task<IEnumerable<ReportDto>> GetVisibleReportsAsync(Guid currentUserId)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(currentUserId)).ToList();

        IEnumerable<ClinicalReport> raw;
        if (_rbac.HasPermission(roles, Permission.ReportsReadAll))
            raw = await _reports.GetAllAsync();
        else if (_rbac.HasPermission(roles, Permission.ReportsReadOwn))
            raw = await _reports.GetByPatientAsync(currentUserId);
        else
            throw new UnauthorizedAccessException("You do not have permission to view reports.");

        return await EnrichAsync(raw);
    }

    public async Task<ReportDto> CreateAsync(Guid currentUserId, CreateReportRequest req)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(currentUserId)).ToList();
        if (!_rbac.HasPermission(roles, Permission.ReportsCreate))
            throw new UnauthorizedAccessException("Only Specialists can create lab reports.");

        var patient = await _users.GetByIdAsync(req.PatientId)
            ?? throw new InvalidOperationException("Patient not found.");
        if (!await _roles.UserHasRoleAsync(patient.Id, RoleName.Patient))
            throw new InvalidOperationException("Target user is not a patient.");

        var test = await _tests.GetByIdAsync(req.LabTestId)
            ?? throw new InvalidOperationException("Lab test not found.");

        var entity = new ClinicalReport
        {
            UserId          = req.PatientId,
            CreatedByUserId = currentUserId,
            LabTestId       = test.Id,
            LabTestName     = test.TestName,
            NormalRange     = test.NormalRange,           // copied from the test definition
            UrgencyLevel    = req.UrgencyLevel,
            Findings        = req.Findings,
            Result          = req.Result,
            Notes           = req.Notes,
            FinalVerdict    = null,
            ReportDate      = DateTime.UtcNow
        };
        entity.Id = await _reports.CreateAsync(entity);

        return (await EnrichAsync(new[] { entity })).First();
    }

    public async Task<ReportDto> AssignToSelfAsync(Guid currentUserId, int reportId)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(currentUserId)).ToList();
        if (!_rbac.HasPermission(roles, Permission.ReportsAssignSelf))
            throw new UnauthorizedAccessException("Only Doctors can claim a report.");

        var report = await _reports.GetByIdAsync(reportId)
            ?? throw new InvalidOperationException("Report not found.");

        if (report.AssignedDoctorId == currentUserId)
            return (await EnrichAsync(new[] { report })).First();   // already mine, no-op

        if (report.AssignedDoctorId.HasValue)
            throw new InvalidOperationException("This report is already assigned to another doctor.");

        var ok = await _reports.TryAssignDoctorAsync(reportId, currentUserId);
        if (!ok) throw new InvalidOperationException("This report was just claimed by another doctor.");

        var refreshed = await _reports.GetByIdAsync(reportId)
            ?? throw new InvalidOperationException("Report disappeared.");
        return (await EnrichAsync(new[] { refreshed })).First();
    }

    public async Task<ReportDto> UpdateVerdictAsync(Guid currentUserId, int reportId, string verdict)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(currentUserId)).ToList();
        if (!_rbac.HasPermission(roles, Permission.ReportsUpdateVerdict))
            throw new UnauthorizedAccessException("Only Doctors can give a verdict.");

        var report = await _reports.GetByIdAsync(reportId)
            ?? throw new InvalidOperationException("Report not found.");

        // Auto-claim if unassigned, otherwise must be the assigned doctor.
        if (!report.AssignedDoctorId.HasValue)
        {
            var ok = await _reports.TryAssignDoctorAsync(reportId, currentUserId);
            if (!ok) throw new InvalidOperationException("This report was just claimed by another doctor.");
        }
        else if (report.AssignedDoctorId.Value != currentUserId)
        {
            throw new InvalidOperationException("This report is assigned to another doctor; you cannot give a verdict.");
        }

        await _reports.UpdateVerdictAsync(reportId, verdict);

        var refreshed = await _reports.GetByIdAsync(reportId)
            ?? throw new InvalidOperationException("Report disappeared.");
        return (await EnrichAsync(new[] { refreshed })).First();
    }

    public async Task DeleteAsync(Guid currentUserId, int reportId)
    {
        var roles = (await _roles.GetUserRoleNamesAsync(currentUserId)).ToList();
        if (!_rbac.HasPermission(roles, Permission.ReportsDelete))
            throw new UnauthorizedAccessException("You cannot delete reports.");
        await _reports.DeleteAsync(reportId);
    }

    // ──────────────────────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────────────────────
    private async Task<IEnumerable<ReportDto>> EnrichAsync(IEnumerable<ClinicalReport> reports)
    {
        var list = reports.ToList();
        if (list.Count == 0) return Array.Empty<ReportDto>();

        var ids = list.Select(r => r.UserId)
            .Concat(list.Where(r => r.CreatedByUserId.HasValue).Select(r => r.CreatedByUserId!.Value))
            .Concat(list.Where(r => r.AssignedDoctorId.HasValue).Select(r => r.AssignedDoctorId!.Value))
            .ToList();

        var names = await _users.GetUserNamesAsync(ids);

        return list.Select(r => new ReportDto
        {
            Id                 = r.Id,
            PatientId          = r.UserId,
            PatientName        = names.GetValueOrDefault(r.UserId, "Unknown"),
            CreatedByUserId    = r.CreatedByUserId,
            CreatedByName      = r.CreatedByUserId.HasValue ? names.GetValueOrDefault(r.CreatedByUserId.Value) : null,
            AssignedDoctorId   = r.AssignedDoctorId,
            AssignedDoctorName = r.AssignedDoctorId.HasValue ? names.GetValueOrDefault(r.AssignedDoctorId.Value) : null,
            LabTestId          = r.LabTestId,
            LabTestName        = r.LabTestName,
            UrgencyLevel       = r.UrgencyLevel,
            Findings           = r.Findings,
            Result             = r.Result,
            NormalRange        = r.NormalRange,
            Notes              = r.Notes,
            FinalVerdict       = r.FinalVerdict,
            ReportDate         = r.ReportDate,
            VerdictGivenAt     = r.VerdictGivenAt
        });
    }
}


