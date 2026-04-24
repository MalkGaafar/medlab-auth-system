using System.Data;
using Microsoft.Data.SqlClient;

namespace MedLab.Api.Database;

public class SqlConnectionFactory : IDbConnectionFactory
{
    private readonly string _connectionString;

    public SqlConnectionFactory(IConfiguration config)
    {
        _connectionString = config.GetConnectionString("Default")
            ?? throw new InvalidOperationException("ConnectionString 'Default' is missing in appsettings.json.");
    }

    public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
}


