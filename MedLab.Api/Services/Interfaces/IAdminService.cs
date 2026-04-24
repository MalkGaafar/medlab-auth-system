using MedLab.Api.Models.DTOs.Admin;

namespace MedLab.Api.Services.Interfaces;

public interface IAdminService
{
    Task<IEnumerable<AdminUserDto>> GetAllUsersAsync();
    Task<IEnumerable<AdminUserDto>> GetPendingUsersAsync();
    Task SetApprovalAsync(Guid currentUserId, Guid targetUserId, bool approve);
    Task UpdateUserRoleAsync(Guid currentUserId, Guid targetUserId, UpdateRoleRequest req);
    Task DeleteUserAsync(Guid currentUserId, Guid targetUserId);
}
