using MedLab.Api.Filters;
using MedLab.Api.Models.Enums;
using MedLab.Api.Repositories.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedLab.Api.Controllers;

[ApiController]
[Route("api/patients")]
[Authorize]
public class PatientsController : ControllerBase
{
    private readonly IUserRepository _users;
    public PatientsController(IUserRepository users) => _users = users;

    /// <summary>Used by Specialists/Doctors/Admins to pick a patient.</summary>
    [HttpGet]
    [RequirePermission(Permission.PatientsReadAll)]
    public async Task<IActionResult> GetAll()
    {
        var patients = (await _users.GetByRoleAsync(RoleName.Patient))
            .Select(p => new { id = p.Id, userName = p.UserName, email = p.Email });
        return Ok(patients);
    }
}
