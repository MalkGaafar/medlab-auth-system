namespace MedLab.Api.Services.Interfaces;

public interface IRateLimitService
{
    Task EnsureNotLockedOutAsync(string email);
    Task RecordFailureAsync(string email);
    Task RecordSuccessAsync(string email);
}