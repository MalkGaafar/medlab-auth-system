using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using MedLab.Api.Models.Entities;
using MedLab.Api.Services.Interfaces;
using Microsoft.IdentityModel.Tokens;

namespace MedLab.Api.Services.Implementations;

public class JwtService : IJwtService
{
    private readonly string _secret;
    private readonly string _issuer;
    private readonly string _audience;
    private readonly int _expirationHours;

    public JwtService(IConfiguration config)
    {
        _secret = Environment.GetEnvironmentVariable("JWT_SECRET_KEY")
            ?? throw new InvalidOperationException(
                "JWT_SECRET_KEY environment variable is not set. Set it to a long random string (>= 32 chars).");

        if (_secret.Length < 32)
            throw new InvalidOperationException("JWT_SECRET_KEY must be at least 32 characters long.");

        _issuer          = config["Jwt:Issuer"]   ?? "MedLab.Api";
        _audience        = config["Jwt:Audience"] ?? "MedLab.Client";
        // Defaulting to 1 hour for better security in a medical context
        _expirationHours = int.TryParse(config["Jwt:ExpirationHours"], out var h) ? h : 1;
    }

    public (string Token, string TokenId, DateTime ExpiresAt) GenerateToken(User user, IEnumerable<string> roles)
    {
        var tokenId   = Guid.NewGuid().ToString("N");
        var expiresAt = DateTime.UtcNow.AddHours(_expirationHours);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub,   user.Id.ToString()),
            new(JwtRegisteredClaimNames.Email, user.Email),
            new(JwtRegisteredClaimNames.Jti,   tokenId),
            new("username",                    user.UserName),
        };
        foreach (var r in roles)
            claims.Add(new Claim(ClaimTypes.Role, r));

        var key   = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secret));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer:             _issuer,
            audience:           _audience,
            claims:             claims,
            notBefore:          DateTime.UtcNow,
            expires:            expiresAt,
            signingCredentials: creds);

        var jwt = new JwtSecurityTokenHandler().WriteToken(token);
        return (jwt, tokenId, expiresAt);
    }
}
