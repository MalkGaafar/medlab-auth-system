using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class UserRepository : IUserRepository
{
    private readonly IDbConnectionFactory _factory;
    public UserRepository(IDbConnectionFactory factory) => _factory = factory;

    private const string Cols =
        "Id, UserName, Email, PasswordHash, PasswordSalt, CreatedAt, IsActive, IsDeleted, IsApproved, DeletedAt";

    // ────────────────────────────────────────────────────────────
    //  Reads — exclude soft-deleted users from "active" queries
    // ────────────────────────────────────────────────────────────
    public async Task<User?> GetByIdAsync(Guid id)
    {
        using var db = _factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<User>(
            $"SELECT {Cols} FROM Users WHERE Id = @Id AND IsDeleted = 0",
            new { Id = id });
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        using var db = _factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<User>(
            $"SELECT {Cols} FROM Users WHERE Email = @Email AND IsDeleted = 0",
            new { Email = email });
    }

    public async Task<IEnumerable<User>> GetAllAsync()
    {
        using var db = _factory.CreateConnection();
        return await db.QueryAsync<User>(
            $"SELECT {Cols} FROM Users WHERE IsDeleted = 0 ORDER BY CreatedAt DESC");
    }

    public async Task<IEnumerable<User>> GetByRoleAsync(string roleName)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT u.Id, u.UserName, u.Email, u.PasswordHash, u.PasswordSalt,
                   u.CreatedAt, u.IsActive, u.IsDeleted, u.IsApproved, u.DeletedAt
            FROM Users u
            INNER JOIN UserRoles ur ON ur.UserId = u.Id
            INNER JOIN Roles r      ON r.Id      = ur.RoleId
            WHERE r.RoleName = @RoleName AND u.IsDeleted = 0";
        return await db.QueryAsync<User>(sql, new { RoleName = roleName });
    }

    // ────────────────────────────────────────────────────────────
    //  Writes
    // ────────────────────────────────────────────────────────────
    public async Task<Guid> CreateAsync(User user)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            INSERT INTO Users (Id, UserName, Email, PasswordHash, PasswordSalt, CreatedAt, IsActive, IsDeleted, IsApproved)
            VALUES (@Id, @UserName, @Email, @PasswordHash, @PasswordSalt, @CreatedAt, @IsActive, @IsDeleted, @IsApproved)";
        if (user.Id == Guid.Empty) user.Id = Guid.NewGuid();
        if (user.CreatedAt == default) user.CreatedAt = DateTime.UtcNow;
        await db.ExecuteAsync(sql, user);
        return user.Id;
    }

    /// <summary>
    /// SOFT-delete only.
    /// Reports, lab tests, and other historic data that reference this user
    /// are intentionally preserved — they will simply render as
    /// "[Deleted] {original name}" via <see cref="GetUserNamesAsync"/>.
    /// </summary>
    public async Task DeleteAsync(Guid id)
    {
        using var db = _factory.CreateConnection();

        await db.ExecuteAsync(@"
            UPDATE Users
               SET IsActive  = 0,
                   IsDeleted = 1,
                   DeletedAt = @Now
             WHERE Id = @Id",
            new { Id = id, Now = DateTime.UtcNow });
    }

    public async Task<bool> EmailExistsAsync(string email)
    {
        using var db = _factory.CreateConnection();
        var count = await db.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM Users WHERE Email = @Email AND IsDeleted = 0",
            new { Email = email });
        return count > 0;
    }

    public async Task SetApprovedAsync(Guid id, bool approved)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(
            "UPDATE Users SET IsApproved = @A WHERE Id = @Id AND IsDeleted = 0",
            new { Id = id, A = approved });
    }

    /// <summary>
    /// Returns a Guid → display-name map.
    /// IMPORTANT: this query DOES include soft-deleted users so historical
    /// records (reports, lab tests, audit rows) keep showing meaningful names.
    /// Deleted users are prefixed with "[Deleted] " so the UI is unambiguous.
    /// </summary>
    public async Task<Dictionary<Guid, string>> GetUserNamesAsync(IEnumerable<Guid> ids)
    {
        var arr = ids.Distinct().Where(g => g != Guid.Empty).ToArray();
        if (arr.Length == 0) return new Dictionary<Guid, string>();

        using var db = _factory.CreateConnection();

        var rows = await db.QueryAsync<(Guid Id, string UserName, bool IsDeleted)>(
            "SELECT Id, UserName, IsDeleted FROM Users WHERE Id IN @Ids",
            new { Ids = arr });

        var byId = rows.ToDictionary(r => r.Id, r => r);

        return arr.ToDictionary(
            id => id,
            id =>
            {
                if (!byId.TryGetValue(id, out var u))
                    return "Deleted user";
                return u.IsDeleted ? $"[Deleted] {u.UserName}" : u.UserName;
            });
    }
}
