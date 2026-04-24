namespace MedLab.Api.Models.Enums;

/// <summary>All permissions in the system. Mapped to roles in RbacService.</summary>
public static class Permission
{
    // Users / approval
    public const string UsersRead         = "users:read";
    public const string UsersDelete       = "users:delete";
    public const string UsersManageRoles  = "users:manage_roles";
    public const string UsersApprove      = "users:approve";

    // Reports
    public const string ReportsReadOwn       = "reports:read_own";
    public const string ReportsReadAll       = "reports:read_all";
    public const string ReportsCreate        = "reports:create";        // Specialist creates the lab result
    public const string ReportsDelete        = "reports:delete";
    public const string ReportsAssignSelf    = "reports:assign_self";   // Doctor claims a report
    public const string ReportsUpdateVerdict = "reports:update_verdict";// Doctor adds verdict

    // Patients
    public const string PatientsReadAll = "patients:read_all";

    // Lab tests
    public const string LabTestsRead   = "labtests:read";
    public const string LabTestsManage = "labtests:manage"; // Specialist creates / edits
}
