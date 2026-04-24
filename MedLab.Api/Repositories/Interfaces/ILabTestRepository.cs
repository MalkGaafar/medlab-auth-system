using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface ILabTestRepository
{
    Task<IEnumerable<LabTest>> GetAllAsync();
    Task<LabTest?> GetByIdAsync(int id);
    Task<int> CreateAsync(LabTest test);
    Task DeleteAsync(int id);
}