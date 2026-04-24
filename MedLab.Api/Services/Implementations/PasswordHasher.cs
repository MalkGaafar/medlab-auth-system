using System.Security.Cryptography;
using MedLab.Api.Services.Interfaces;

namespace MedLab.Api.Services.Implementations;

/// <summary>PBKDF2-HMAC-SHA256, 128-bit salt, 100k iterations, timing-safe verify.</summary>
public class PasswordHasher : IPasswordHasher
{
    private const int SaltSize   = 16;
    private const int HashSize   = 32;
    private const int Iterations = 100_000;
    private static readonly HashAlgorithmName Algo = HashAlgorithmName.SHA256;

    public (string Hash, string Salt) HashPassword(string password)
    {
        if (string.IsNullOrEmpty(password))
            throw new ArgumentException("Password cannot be empty", nameof(password));

        var salt = RandomNumberGenerator.GetBytes(SaltSize);
        var hash = Rfc2898DeriveBytes.Pbkdf2(password, salt, Iterations, Algo, HashSize);
        return (Convert.ToBase64String(hash), Convert.ToBase64String(salt));
    }

    public bool Verify(string password, string hash, string salt)
    {
        if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(hash) || string.IsNullOrEmpty(salt))
            return false;

        try
        {
            var saltBytes     = Convert.FromBase64String(salt);
            var expectedBytes = Convert.FromBase64String(hash);
            var computed      = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, Iterations, Algo, expectedBytes.Length);
            return CryptographicOperations.FixedTimeEquals(computed, expectedBytes);
        }
        catch (FormatException)
        {
            return false;
        }
    }
}


