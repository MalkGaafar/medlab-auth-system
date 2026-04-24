namespace MedLab.Api.Services.Interfaces;

public interface IRbacService
{
    IReadOnlyDictionary<string, IReadOnlyList<string>> GetMatrix();
    IReadOnlyList<string> GetPermissionsForRoles(IEnumerable<string> roles);
    bool HasPermission(IEnumerable<string> roles, string permission);
}
