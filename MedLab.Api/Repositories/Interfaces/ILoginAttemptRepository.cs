namespace MedLab.Api.Repositories.Interfaces;

public interface ILoginAttemptRepository
{
    Task RecordAsync(string email, bool success);
    Task<int> CountRecentFailuresAsync(string email, TimeSpan window);
    Task ClearForEmailAsync(string email);
}
