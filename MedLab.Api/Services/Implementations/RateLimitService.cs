using MedLab.Api.Repositories.Interfaces;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

public class RateLimitService : IRateLimitService
{
    private readonly ILoginAttemptRepository _repo;
    private readonly int _maxAttempts;
    private readonly TimeSpan _window;

    public RateLimitService(ILoginAttemptRepository repo, IConfiguration cfg)
    {
        _repo        = repo;
        _maxAttempts = int.TryParse(cfg["RateLimit:MaxLoginAttempts"], out var m) ? m : 5;
        var mins     = int.TryParse(cfg["RateLimit:LockoutMinutes"],   out var w) ? w : 15;
        _window      = TimeSpan.FromMinutes(mins);
    }

    public async Task EnsureNotLockedOutAsync(string email)
    {
        var failures = await _repo.CountRecentFailuresAsync(email, _window);
        if (failures >= _maxAttempts)
            throw new InvalidOperationException(
                $"Too many failed login attempts. Try again in {_window.TotalMinutes:F0} minutes.");
    }

    public Task RecordFailureAsync(string email) => _repo.RecordAsync(email, false);

    public async Task RecordSuccessAsync(string email)
    {
        await _repo.RecordAsync(email, true);
        await _repo.ClearForEmailAsync(email);
    }
}

