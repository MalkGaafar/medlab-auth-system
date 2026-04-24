using MedLab.Api.Models.DTOs.LabTests;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

public class LabTestService : ILabTestService
{
    private readonly ILabTestRepository _tests;
    private readonly IUserRepository _users;

    public LabTestService(ILabTestRepository tests, IUserRepository users)
    {
        _tests = tests; _users = users;
    }

    public async Task<IEnumerable<LabTestDto>> GetAllAsync()
    {
        var tests = (await _tests.GetAllAsync()).ToList();
        var creatorIds = tests.Where(t => t.CreatedByUserId.HasValue).Select(t => t.CreatedByUserId!.Value);
        var names = await _users.GetUserNamesAsync(creatorIds);

        return tests.Select(t => new LabTestDto
        {
            Id              = t.Id,
            TestName        = t.TestName,
            Description     = t.Description,
            NormalRange     = t.NormalRange,
            CreatedByUserId = t.CreatedByUserId,
            CreatedByName   = t.CreatedByUserId.HasValue ? names.GetValueOrDefault(t.CreatedByUserId.Value) : null,
            CreatedAt       = t.CreatedAt
        });
    }

    public async Task<LabTestDto> CreateAsync(Guid currentUserId, CreateLabTestRequest req)
    {
        var test = new LabTest
        {
            TestName        = req.TestName.Trim(),
            Description     = req.Description?.Trim(),
            NormalRange     = req.NormalRange.Trim(),
            CreatedByUserId = currentUserId,
            CreatedAt       = DateTime.UtcNow
        };
        test.Id = await _tests.CreateAsync(test);
        var created = await _users.GetByIdAsync(currentUserId);
        return new LabTestDto
        {
            Id              = test.Id,
            TestName        = test.TestName,
            Description     = test.Description,
            NormalRange     = test.NormalRange,
            CreatedByUserId = test.CreatedByUserId,
            CreatedByName   = created?.UserName,
            CreatedAt       = test.CreatedAt
        };
    }

    public Task DeleteAsync(int id) => _tests.DeleteAsync(id);
}