using System.ComponentModel.DataAnnotations;
using MedLab.Api.Validation;

namespace MedLab.Api.Models.DTOs.Auth;

public class RegisterRequest
{
    [Required]
    [StringLength(50, MinimumLength = 3)]
    public string UserName { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    [StringLength(100)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StrongPassword]
    public string Password { get; set; } = string.Empty;

    /// <summary>
    /// Patient | Doctor | Specialist. Admins are created by other admins, never via self-register.
    /// </summary>
    [Required]
    [RegularExpression("^(Patient|Doctor|Specialist)$",
        ErrorMessage = "Role must be 'Patient', 'Doctor', or 'Specialist'.")]
    public string Role { get; set; } = "Patient";
}