using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly IDbConnectionFactory _factory;
    public RefreshTokenRepository(IDbConnectionFactory factory) => _factory = factory;

    public async Task CreateAsync(RefreshToken token)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            INSERT INTO RefreshTokens (Id, UserId, TokenHash, AccessJti, CreatedAt, ExpiresAt, IsRevoked, ReplacedBy)
            VALUES (@Id, @UserId, @TokenHash, @AccessJti, @CreatedAt, @ExpiresAt, @IsRevoked, @ReplacedBy)";
        if (token.Id == Guid.Empty) token.Id = Guid.NewGuid();
        if (token.CreatedAt == default) token.CreatedAt = DateTime.UtcNow;
        await db.ExecuteAsync(sql, token);
    }

    public async Task<RefreshToken?> GetByHashAsync(string tokenHash)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT Id, UserId, TokenHash, AccessJti, CreatedAt, ExpiresAt, IsRevoked, ReplacedBy
              FROM RefreshTokens
             WHERE TokenHash = @TokenHash";
        return await db.QuerySingleOrDefaultAsync<RefreshToken>(sql, new { TokenHash = tokenHash });
    }

    public async Task MarkRotatedAsync(string oldHash, string newHash)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(@"
            UPDATE RefreshTokens
               SET IsRevoked  = 1,
                   ReplacedBy = @NewHash
             WHERE TokenHash  = @OldHash",
            new { OldHash = oldHash, NewHash = newHash });
    }

    public async Task RevokeAsync(string tokenHash)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(
            "UPDATE RefreshTokens SET IsRevoked = 1 WHERE TokenHash = @TokenHash",
            new { TokenHash = tokenHash });
    }

    public async Task RevokeAllForUserAsync(Guid userId)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(
            "UPDATE RefreshTokens SET IsRevoked = 1 WHERE UserId = @UserId",
            new { UserId = userId });
    }
}
