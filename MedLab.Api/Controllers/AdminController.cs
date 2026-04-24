using MedLab.Api.Filters;
using MedLab.Api.Helpers;
using MedLab.Api.Models.DTOs.Admin;
using MedLab.Api.Models.Enums;
using MedLab.Api.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedLab.Api.Controllers;

[ApiController]
[Route("api/admin")]
[Authorize]
public class AdminController : ControllerBase
{
    private readonly IAdminService _admin;
    private readonly IRbacService _rbac;

    public AdminController(IAdminService admin, IRbacService rbac)
    { _admin = admin; _rbac = rbac; }

    [HttpGet("users")]
    [RequirePermission(Permission.UsersRead)]
    public async Task<ActionResult<IEnumerable<AdminUserDto>>> GetUsers()
        => Ok(await _admin.GetAllUsersAsync());

    [HttpGet("users/pending")]
    [RequirePermission(Permission.UsersApprove)]
    public async Task<ActionResult<IEnumerable<AdminUserDto>>> GetPending()
        => Ok(await _admin.GetPendingUsersAsync());

    [HttpPost("users/{id:guid}/approval")]
    [RequirePermission(Permission.UsersApprove)]
    public async Task<IActionResult> SetApproval(Guid id, [FromBody] ApprovalRequest req)
    {
        await _admin.SetApprovalAsync(User.GetUserId(), id, req.Approve);
        return Ok(new { message = req.Approve ? "User approved." : "User approval revoked." });
    }

    [HttpPut("users/{id:guid}/roles")]
    [RequirePermission(Permission.UsersManageRoles)]
    public async Task<IActionResult> UpdateRole(Guid id, [FromBody] UpdateRoleRequest req)
    {
        await _admin.UpdateUserRoleAsync(User.GetUserId(), id, req);
        return Ok(new { message = "Role updated." });
    }

    [HttpDelete("users/{id:guid}")]
    [RequirePermission(Permission.UsersDelete)]
    public async Task<IActionResult> DeleteUser(Guid id)
    {
        await _admin.DeleteUserAsync(User.GetUserId(), id);
        return NoContent();
    }

    [HttpGet("rbac-matrix")]
    [RequirePermission(Permission.UsersRead)]
    public ActionResult<object> GetMatrix() => Ok(_rbac.GetMatrix());
}

