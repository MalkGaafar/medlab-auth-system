using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace MedLab.Api.Helpers;

public static class ClaimsHelper
{
    public static Guid GetUserId(this ClaimsPrincipal user)
    {
        var sub = user.FindFirst(JwtRegisteredClaimNames.Sub)?.Value
                  ?? user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return Guid.TryParse(sub, out var id) ? id : Guid.Empty;
    }

    public static string? GetTokenId(this ClaimsPrincipal user)
        => user.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;

    public static IEnumerable<string> GetRoles(this ClaimsPrincipal user)
        => user.FindAll(ClaimTypes.Role).Select(c => c.Value);
}
