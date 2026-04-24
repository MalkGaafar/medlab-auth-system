namespace MedLab.Api.Models.Enums;

/// <summary>Canonical role names. Must match the seed in schema.sql.</summary>
public static class RoleName
{
    public const string Admin      = "Admin";
    public const string Doctor     = "Doctor";
    public const string Specialist = "Specialist";
    public const string Patient    = "Patient";

    public static readonly string[] All = { Admin, Doctor, Specialist, Patient };

    /// <summary>Roles that need admin approval after registration.</summary>
    public static readonly string[] RequiresApproval = { Doctor, Specialist };
}
