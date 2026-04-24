using MedLab.Api.Models.Entities;

namespace MedLab.Api.Repositories.Interfaces;

public interface ISessionRepository
{
    Task CreateAsync(Session session);
    Task<Session?> GetByTokenIdAsync(string tokenId);
    Task RevokeAsync(string tokenId);
    Task RevokeAllForUserAsync(Guid userId);
    Task<bool> IsValidAsync(string tokenId);
}

