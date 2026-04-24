using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class LoginAttemptRepository : ILoginAttemptRepository
{
    private readonly IDbConnectionFactory _factory;
    public LoginAttemptRepository(IDbConnectionFactory factory) => _factory = factory;

    public async Task RecordAsync(string email, bool success)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(
            "INSERT INTO LoginAttempts (Email, AttemptedAt, Success) VALUES (@Email, @At, @Success)",
            new { Email = email, At = DateTime.UtcNow, Success = success });
    }

    public async Task<int> CountRecentFailuresAsync(string email, TimeSpan window)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT COUNT(1) FROM LoginAttempts
            WHERE Email = @Email AND Success = 0 AND AttemptedAt >= @Since";
        return await db.ExecuteScalarAsync<int>(sql, new
        {
            Email = email,
            Since = DateTime.UtcNow - window
        });
    }

    public async Task ClearForEmailAsync(string email)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync("DELETE FROM LoginAttempts WHERE Email = @Email", new { Email = email });
    }
}


