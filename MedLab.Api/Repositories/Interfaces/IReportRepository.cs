using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface IReportRepository
{
    Task<IEnumerable<ClinicalReport>> GetAllAsync();
    Task<IEnumerable<ClinicalReport>> GetByPatientAsync(Guid patientId);
    Task<ClinicalReport?> GetByIdAsync(int id);
    Task<int> CreateAsync(ClinicalReport report);
    Task DeleteAsync(int id);

    /// <summary>
    /// Atomically claim a report for a doctor. Returns true if THIS doctor became the assignee.
    /// Returns false if the report was already claimed by someone else.
    /// </summary>
    Task<bool> TryAssignDoctorAsync(int reportId, Guid doctorId);

    /// <summary>Update verdict + verdict timestamp. Caller must already be the assigned doctor.</summary>
    Task UpdateVerdictAsync(int reportId, string verdict);
}