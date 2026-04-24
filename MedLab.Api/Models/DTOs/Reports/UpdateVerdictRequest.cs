using System.ComponentModel.DataAnnotations;

namespace MedLab.Api.Models.DTOs.Reports;

public class UpdateVerdictRequest
{
    [Required, StringLength(4000, MinimumLength = 1)]
    public string FinalVerdict { get; set; } = string.Empty;
}
