using MedLab.Api.Filters;
using MedLab.Api.Helpers;
using MedLab.Api.Models.DTOs.LabTests;
using MedLab.Api.Models.Enums;
using MedLab.Api.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedLab.Api.Controllers;

[ApiController]
[Route("api/labtests")]
[Authorize]
public class LabTestsController : ControllerBase
{
    private readonly ILabTestService _service;
    public LabTestsController(ILabTestService service) => _service = service;

    [HttpGet]
    [RequirePermission(Permission.LabTestsRead)]
    public async Task<ActionResult<IEnumerable<LabTestDto>>> GetAll()
        => Ok(await _service.GetAllAsync());

    /// <summary>Specialist creates a new lab test definition + normal range.</summary>
    [HttpPost]
    [RequirePermission(Permission.LabTestsManage)]
    public async Task<ActionResult<LabTestDto>> Create([FromBody] CreateLabTestRequest req)
    {
        var dto = await _service.CreateAsync(User.GetUserId(), req);
        return CreatedAtAction(nameof(GetAll), new { id = dto.Id }, dto);
    }

    [HttpDelete("{id:int}")]
    [RequirePermission(Permission.LabTestsManage)]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.DeleteAsync(id);
        return NoContent();
    }
}

