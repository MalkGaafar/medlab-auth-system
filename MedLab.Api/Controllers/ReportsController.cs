using MedLab.Api.Filters;
using MedLab.Api.Helpers;
using MedLab.Api.Models.DTOs.Reports;
using MedLab.Api.Models.Enums;
using MedLab.Api.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedLab.Api.Controllers;

[ApiController]
[Route("api/reports")]
[Authorize]
public class ReportsController : ControllerBase
{
    private readonly IReportService _reports;
    public ReportsController(IReportService reports) => _reports = reports;

    /// <summary>Visible reports for the caller (all for staff, own for patient).</summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ReportDto>>> GetVisible()
        => Ok(await _reports.GetVisibleReportsAsync(User.GetUserId()));

    /// <summary>Specialist creates a clinical report (a lab result for a patient).</summary>
    [HttpPost]
    [RequirePermission(Permission.ReportsCreate)]
    public async Task<ActionResult<ReportDto>> Create([FromBody] CreateReportRequest req)
    {
        var dto = await _reports.CreateAsync(User.GetUserId(), req);
        return CreatedAtAction(nameof(GetVisible), new { id = dto.Id }, dto);
    }

    /// <summary>Doctor claims an unassigned report.</summary>
    [HttpPost("{id:int}/assign")]
    [RequirePermission(Permission.ReportsAssignSelf)]
    public async Task<ActionResult<ReportDto>> AssignSelf(int id)
        => Ok(await _reports.AssignToSelfAsync(User.GetUserId(), id));

    /// <summary>Assigned doctor adds the final verdict.</summary>
    [HttpPatch("{id:int}/verdict")]
    [RequirePermission(Permission.ReportsUpdateVerdict)]
    public async Task<ActionResult<ReportDto>> UpdateVerdict(int id, [FromBody] UpdateVerdictRequest req)
        => Ok(await _reports.UpdateVerdictAsync(User.GetUserId(), id, req.FinalVerdict));

    [HttpDelete("{id:int}")]
    [RequirePermission(Permission.ReportsDelete)]
    public async Task<IActionResult> Delete(int id)
    {
        await _reports.DeleteAsync(User.GetUserId(), id);
        return NoContent();
    }
}

