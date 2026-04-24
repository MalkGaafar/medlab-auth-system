namespace MedLab.Api.Models.DTOs;

public class ApiError
{
    public string Message { get; set; } = string.Empty;
    public Dictionary<string, string[]>? Errors { get; set; }

    public ApiError() { }
    public ApiError(string message) { Message = message; }
}
