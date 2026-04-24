using System.ComponentModel.DataAnnotations;

namespace MedLab.Api.Validation;

/// <summary>
/// Enforces: min 8 chars, at least 1 upper, 1 lower, 1 digit, 1 special.
/// </summary>
[AttributeUsage(AttributeTargets.Property)]
public class StrongPasswordAttribute : ValidationAttribute
{
    public int MinLength { get; set; } = 8;
    public int MaxLength { get; set; } = 64;

    protected override ValidationResult? IsValid(object? value, ValidationContext context)
    {
        if (value is not string pwd || string.IsNullOrWhiteSpace(pwd))
            return new ValidationResult("Password is required.");

        if (pwd.Length < MinLength)
            return new ValidationResult($"Password must be at least {MinLength} characters.");
        if (pwd.Length > MaxLength)
            return new ValidationResult($"Password must be at most {MaxLength} characters.");
        if (!pwd.Any(char.IsUpper))
            return new ValidationResult("Password must contain at least one uppercase letter.");
        if (!pwd.Any(char.IsLower))
            return new ValidationResult("Password must contain at least one lowercase letter.");
        if (!pwd.Any(char.IsDigit))
            return new ValidationResult("Password must contain at least one digit.");
        if (!pwd.Any(c => !char.IsLetterOrDigit(c)))
            return new ValidationResult("Password must contain at least one special character (e.g. !@#$%).");

        return ValidationResult.Success;
    }
}


