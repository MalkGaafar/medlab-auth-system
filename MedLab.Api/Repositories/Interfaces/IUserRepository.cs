using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<User?> GetByEmailAsync(string email);
    Task<IEnumerable<User>> GetAllAsync();
    Task<IEnumerable<User>> GetByRoleAsync(string roleName);
    Task<Guid> CreateAsync(User user);
    Task DeleteAsync(Guid id);
    Task<bool> EmailExistsAsync(string email);
    Task SetApprovedAsync(Guid id, bool approved);
    Task<Dictionary<Guid, string>> GetUserNamesAsync(IEnumerable<Guid> ids);
}
