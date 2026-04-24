using System.Security.Claims;
using MedLab.Api.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace MedLab.Api.Filters;

/// <summary>
/// Enforces a specific permission via the RBAC service. Use with [Authorize].
/// </summary>
[AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = true)]
public class RequirePermissionAttribute : Attribute, IAsyncAuthorizationFilter
{
    private readonly string _permission;
    public RequirePermissionAttribute(string permission) => _permission = permission;

    public Task OnAuthorizationAsync(AuthorizationFilterContext ctx)
    {
        var user = ctx.HttpContext.User;
        if (user?.Identity?.IsAuthenticated != true)
        {
            ctx.Result = new UnauthorizedResult();
            return Task.CompletedTask;
        }

        var roles = user.FindAll(ClaimTypes.Role).Select(c => c.Value).ToList();
        var rbac = ctx.HttpContext.RequestServices.GetRequiredService<IRbacService>();

        if (!rbac.HasPermission(roles, _permission))
        {
            ctx.Result = new ObjectResult(new { message = $"Forbidden: missing permission '{_permission}'." })
            {
                StatusCode = StatusCodes.Status403Forbidden
            };
        }

        return Task.CompletedTask;
    }
}




