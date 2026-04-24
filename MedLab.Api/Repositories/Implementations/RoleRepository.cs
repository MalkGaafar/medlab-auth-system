using Dapper;
using MedLab.Api.Database;
using MedLab.Api.Models.Entities;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Repositories.Implementations;

public class RoleRepository : IRoleRepository
{
    private readonly IDbConnectionFactory _factory;
    public RoleRepository(IDbConnectionFactory factory) => _factory = factory;

    public async Task<IEnumerable<Role>> GetAllAsync()
    {
        using var db = _factory.CreateConnection();
        return await db.QueryAsync<Role>("SELECT Id, RoleName, Description FROM Roles ORDER BY RoleName");
    }

   public async Task<Role?> GetByNameAsync(string name)
{
    using var db = _factory.CreateConnection();

    const string sql = @"
        SELECT Id, RoleName, Description 
        FROM Roles 
        WHERE LOWER(RoleName) = LOWER(@Name)";

    return await db.QuerySingleOrDefaultAsync<Role>(
        sql,
        new { Name = name });
}

    public async Task<IEnumerable<string>> GetUserRoleNamesAsync(Guid userId)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT r.RoleName FROM Roles r
            INNER JOIN UserRoles ur ON ur.RoleId = r.Id
            WHERE ur.UserId = @UserId";
        return await db.QueryAsync<string>(sql, new { UserId = userId });
    }

    public async Task AssignRoleAsync(Guid userId, int roleId)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            IF NOT EXISTS (SELECT 1 FROM UserRoles WHERE UserId = @UserId AND RoleId = @RoleId)
            INSERT INTO UserRoles (UserId, RoleId, AssignedAt) VALUES (@UserId, @RoleId, @AssignedAt)";
        await db.ExecuteAsync(sql, new { UserId = userId, RoleId = roleId, AssignedAt = DateTime.UtcNow });
    }

    public async Task RemoveRoleAsync(Guid userId, int roleId)
    {
        using var db = _factory.CreateConnection();
        await db.ExecuteAsync(
            "DELETE FROM UserRoles WHERE UserId = @UserId AND RoleId = @RoleId",
            new { UserId = userId, RoleId = roleId });
    }

    public async Task<bool> UserHasRoleAsync(Guid userId, string roleName)
    {
        using var db = _factory.CreateConnection();
        const string sql = @"
            SELECT COUNT(1) FROM UserRoles ur
            INNER JOIN Roles r ON r.Id = ur.RoleId
            WHERE ur.UserId = @UserId AND r.RoleName = @RoleName";
        var c = await db.ExecuteScalarAsync<int>(sql, new { UserId = userId, RoleName = roleName });
        return c > 0;
    }
}

