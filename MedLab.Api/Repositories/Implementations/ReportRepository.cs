using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class ReportRepository : IReportRepository
{
    private readonly IDbConnectionFactory _factory;
    public ReportRepository(IDbConnectionFactory factory) => _factory = factory;

    private const string Cols = @"
        Id, LabTestId, UserId, CreatedByUserId, AssignedDoctorId,
        UrgencyLevel, Findings, Result, NormalRange, Notes, FinalVerdict,
        LabTestName, ReportDate, VerdictGivenAt";

    public async Task<IEnumerable<ClinicalReport>> GetAllAsync()
    {
        using var db = _factory.CreateConnection();
        return await db.QueryAsync<ClinicalReport>(
            $"SELECT {Cols} FROM ClinicalReports ORDER BY ReportDate DESC");
    }

    public async Task<IEnumerable<ClinicalReport>> GetByPatientAsync(Guid patientId)
    {
        using var db = _factory.CreateConnection();
        return await db.QueryAsync<ClinicalReport>(
            $"SELECT {Cols} FROM ClinicalReports WHERE UserId = @UserId ORDER BY ReportDate DESC",
            new { UserId = patientId });
    }

    public async Task<ClinicalReport?> GetByIdAsync(int id)
    {
        using var db = _factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<ClinicalReport>(
            $"SELECT {Cols} FROM ClinicalReports WHERE Id = @Id", new { Id = id });
    }

    public async Task<int> CreateAsync(ClinicalReport report)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            INSERT INTO ClinicalReports
                (LabTestId, UserId, CreatedByUserId, AssignedDoctorId, UrgencyLevel, Findings,
                 Result, NormalRange, Notes, FinalVerdict, LabTestName, ReportDate, VerdictGivenAt)
            OUTPUT INSERTED.Id
            VALUES
                (@LabTestId, @UserId, @CreatedByUserId, @AssignedDoctorId, @UrgencyLevel, @Findings,
                 @Result, @NormalRange, @Notes, @FinalVerdict, @LabTestName, @ReportDate, @VerdictGivenAt)";
        if (report.ReportDate == default) report.ReportDate = DateTime.UtcNow;
        return await db.ExecuteScalarAsync<int>(sql, report);
    }

    public async Task DeleteAsync(int id)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync("DELETE FROM ClinicalReports WHERE Id = @Id", new { Id = id });
    }

    public async Task<bool> TryAssignDoctorAsync(int reportId, Guid doctorId)
    {
        // Atomic claim: only set AssignedDoctorId if it is currently NULL.
        using var db = _factory.CreateConnection();
        const string sql = @"
            UPDATE ClinicalReports
               SET AssignedDoctorId = @DoctorId
             WHERE Id = @Id
               AND AssignedDoctorId IS NULL";
        var affected = await db.ExecuteAsync(sql, new { Id = reportId, DoctorId = doctorId });
        return affected == 1;
    }

    public async Task UpdateVerdictAsync(int reportId, string verdict)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            UPDATE ClinicalReports
               SET FinalVerdict   = @Verdict,
                   VerdictGivenAt = @Now
             WHERE Id = @Id";
        await db.ExecuteAsync(sql, new { Id = reportId, Verdict = verdict, Now = DateTime.UtcNow });
    }
}
