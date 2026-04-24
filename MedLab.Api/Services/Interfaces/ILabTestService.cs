using MedLab.Api.Models.DTOs.LabTests;

namespace MedLab.Api.Services.Interfaces;

public interface ILabTestService
{
    Task<IEnumerable<LabTestDto>> GetAllAsync();
    Task<LabTestDto> CreateAsync(Guid currentUserId, CreateLabTestRequest req);
    Task DeleteAsync(int id);
}