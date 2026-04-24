using MedLab.Api.Models.Enums;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

/// <summary>
/// Central RBAC matrix. Single source of truth: each role -> list of permissions.
/// Doctor / Specialist / Admin / Patient.
/// </summary>
public class RbacService : IRbacService
{
    private static readonly Dictionary<string, List<string>> _matrix = new()
    {
        [RoleName.Admin] = new()
        {
            Permission.UsersRead,
            Permission.UsersDelete,
            Permission.UsersManageRoles,
            Permission.UsersApprove,
            Permission.ReportsReadAll,
            Permission.ReportsDelete,
            Permission.PatientsReadAll,
            Permission.LabTestsRead,
        },
        [RoleName.Doctor] = new()
        {
            Permission.ReportsReadAll,
            Permission.ReportsAssignSelf,
            Permission.ReportsUpdateVerdict,
            Permission.PatientsReadAll,
            Permission.LabTestsRead,
        },
        [RoleName.Specialist] = new()
        {
            Permission.ReportsCreate,
            Permission.ReportsReadAll,
            Permission.PatientsReadAll,
            Permission.LabTestsRead,
            Permission.LabTestsManage,
        },
        [RoleName.Patient] = new()
        {
            Permission.ReportsReadOwn,
            Permission.LabTestsRead,
        },
    };

    public IReadOnlyDictionary<string, IReadOnlyList<string>> GetMatrix()
        => _matrix.ToDictionary(k => k.Key, v => (IReadOnlyList<string>)v.Value);

    public IReadOnlyList<string> GetPermissionsForRoles(IEnumerable<string> roles)
        => roles.SelectMany(r => _matrix.TryGetValue(r, out var p) ? p : new List<string>())
                .Distinct()
                .ToList();

    public bool HasPermission(IEnumerable<string> roles, string permission)
        => GetPermissionsForRoles(roles).Contains(permission);
}
