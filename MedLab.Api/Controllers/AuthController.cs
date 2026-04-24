using MedLab.Api.Helpers;
using MedLab.Api.Models.DTOs.Auth;
using MedLab.Api.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedLab.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _auth;
    public AuthController(IAuthService auth) => _auth = auth;

    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<ActionResult<AuthResponse>> Register([FromBody] RegisterRequest req)
        => Ok(await _auth.RegisterAsync(req));

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<ActionResult<AuthResponse>> Login([FromBody] LoginRequest req)
    {
        try { return Ok(await _auth.LoginAsync(req)); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { message = ex.Message }); }
    }

    /// <summary>
    /// Exchange a valid refresh token for a brand-new access + refresh token pair.
    /// The old refresh token is rotated and cannot be reused.
    /// </summary>
    [HttpPost("refresh")]
    [AllowAnonymous]
    public async Task<ActionResult<AuthResponse>> Refresh([FromBody] RefreshRequest req)
    {
        try { return Ok(await _auth.RefreshAsync(req.RefreshToken)); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { message = ex.Message }); }
    }

    [HttpPost("logout")]
    [Authorize]
    public async Task<IActionResult> Logout()
    {
        var jti = User.GetTokenId();
        if (!string.IsNullOrEmpty(jti)) await _auth.LogoutAsync(jti);
        return Ok(new { message = "Logged out." });
    }

    [HttpGet("me")]
    [Authorize]
    public async Task<ActionResult<UserDto>> Me()
    {
        var id = User.GetUserId();
        if (id == Guid.Empty) return Unauthorized();
        return Ok(await _auth.GetMeAsync(id));
    }
}
