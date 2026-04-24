using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class SessionRepository : ISessionRepository
{
    private readonly IDbConnectionFactory _factory;
    public SessionRepository(IDbConnectionFactory factory) => _factory = factory;

    public async Task CreateAsync(Session s)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            INSERT INTO Sessions (Id, UserId, TokenId, CreatedAt, ExpiresAt, IsRevoked)
            VALUES (@Id, @UserId, @TokenId, @CreatedAt, @ExpiresAt, @IsRevoked)";
        if (s.Id == Guid.Empty) s.Id = Guid.NewGuid();
        if (s.CreatedAt == default) s.CreatedAt = DateTime.UtcNow;
        await db.ExecuteAsync(sql, s);
    }

    public async Task<Session?> GetByTokenIdAsync(string tokenId)
    {
        using var db = _factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<Session>(
            "SELECT Id, UserId, TokenId, CreatedAt, ExpiresAt, IsRevoked FROM Sessions WHERE TokenId = @TokenId",
            new { TokenId = tokenId });
    }

    public async Task RevokeAsync(string tokenId)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync("UPDATE Sessions SET IsRevoked = 1 WHERE TokenId = @TokenId",
            new { TokenId = tokenId });
    }

    public async Task RevokeAllForUserAsync(Guid userId)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync("UPDATE Sessions SET IsRevoked = 1 WHERE UserId = @UserId",
            new { UserId = userId });
    }

    public async Task<bool> IsValidAsync(string tokenId)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT COUNT(1) FROM Sessions
            WHERE TokenId = @TokenId AND IsRevoked = 0 AND ExpiresAt > @Now";
        var c = await db.ExecuteScalarAsync<int>(sql, new { TokenId = tokenId, Now = DateTime.UtcNow });
        return c > 0;
    }
}

