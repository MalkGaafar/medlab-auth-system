using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface IRoleRepository
{
    Task<IEnumerable<Role>> GetAllAsync();
    Task<Role?> GetByNameAsync(string name);
    Task<IEnumerable<string>> GetUserRoleNamesAsync(Guid userId);
    Task AssignRoleAsync(Guid userId, int roleId);
    Task RemoveRoleAsync(Guid userId, int roleId);
    Task<bool> UserHasRoleAsync(Guid userId, string roleName);
}
