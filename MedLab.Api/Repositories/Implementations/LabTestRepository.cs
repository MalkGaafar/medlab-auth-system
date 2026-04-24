using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class LabTestRepository : ILabTestRepository
{
    private readonly IDbConnectionFactory _factory;
    public LabTestRepository(IDbConnectionFactory factory) => _factory = factory;

    private const string Cols = "Id, TestName, Description, NormalRange, CreatedByUserId, CreatedAt";

    public async Task<IEnumerable<LabTest>> GetAllAsync()
    {
        using var db = _factory.CreateConnection();
        return await db.QueryAsync<LabTest>($"SELECT {Cols} FROM LabTests ORDER BY TestName");
    }

    public async Task<LabTest?> GetByIdAsync(int id)
    {
        using var db = _factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<LabTest>(
            $"SELECT {Cols} FROM LabTests WHERE Id = @Id", new { Id = id });
    }

    public async Task<int> CreateAsync(LabTest test)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            INSERT INTO LabTests (TestName, Description, NormalRange, CreatedByUserId, CreatedAt)
            OUTPUT INSERTED.Id
            VALUES (@TestName, @Description, @NormalRange, @CreatedByUserId, @CreatedAt)";
        if (test.CreatedAt == default) test.CreatedAt = DateTime.UtcNow;
        return await db.ExecuteScalarAsync<int>(sql, test);
    }

    public async Task DeleteAsync(int id)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync("DELETE FROM LabTests WHERE Id = @Id", new { Id = id });
    }
}

