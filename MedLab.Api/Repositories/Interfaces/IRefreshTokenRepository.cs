using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface IRefreshTokenRepository
{
    Task CreateAsync(RefreshToken token);
    Task<RefreshToken?> GetByHashAsync(string tokenHash);
    Task MarkRotatedAsync(string oldHash, string newHash);
    Task RevokeAsync(string tokenHash);
    Task RevokeAllForUserAsync(Guid userId);
}
