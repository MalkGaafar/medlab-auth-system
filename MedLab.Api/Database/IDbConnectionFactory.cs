using System.Data;

namespace MedLab.Api.Database;

public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();
}
