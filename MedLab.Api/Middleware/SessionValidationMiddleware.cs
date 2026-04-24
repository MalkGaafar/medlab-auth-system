using System.IdentityModel.Tokens.Jwt;
using MedLab.Api.Repositories.Interfaces;

namespace MedLab.Api.Middleware;

/// <summary>
/// After JWT validation, ensure the session row (jti) exists and is not revoked.
/// This makes logout actually invalidate the bearer token.
/// </summary>
public class SessionValidationMiddleware
{
    private readonly RequestDelegate _next;
    public SessionValidationMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext ctx, ISessionRepository sessions)
    {
        if (ctx.User?.Identity?.IsAuthenticated == true)
        {
            var jti = ctx.User.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;
            if (string.IsNullOrEmpty(jti) || !await sessions.IsValidAsync(jti))
            {
                ctx.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await ctx.Response.WriteAsJsonAsync(new { message = "Session is invalid or has been revoked." });
                return;
            }
        }
        await _next(ctx);
    }
}
