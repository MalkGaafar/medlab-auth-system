using MedLab.Api.Models.Entities;

namespace MedLab.Api.Services.Interfaces;

public interface IJwtService
{
    (string Token, string TokenId, DateTime ExpiresAt) GenerateToken(User user, IEnumerable<string> roles);
}
