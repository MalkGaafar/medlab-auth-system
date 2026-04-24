MedLab — Setup & Run Guide
A medical lab-reports system. Backend: ASP.NET Core 8 + Dapper + SQL Server. Frontend: the React/TanStack project you already have.

Security features (implemented in the backend, not advertised in the UI):

PBKDF2-HMAC-SHA256 password hashing with per-user 128-bit random salt
JWT (HMAC-SHA256) authentication with server-side session revocation
RBAC (Admin / Doctor / Patient) with a permission matrix + [RequirePermission] filter
Rate-limited login (5 failures → 15-minute lockout)
Strong-password validator (length + upper + lower + digit + special)
Patients can see ONLY their own reports (enforced in ReportService)


1. Prerequisites
Install on your machine:

.NET 8 SDK → https://dotnet.microsoft.com/download/dotnet/8.0
SQL Server (SQL Server Express is fine — you already have LAPTOP-Q1DM7D4L\SQLEXPRESS)
SQL Server Management Studio (SSMS) — to run schema.sql
Node.js 20+ (for the React frontend)

2. Create the database
Open SSMS and connect to [Your Connection]\SQLEXPRESS.
Open the file MedLab.Api/Database/schema.sql.
Press Execute (F5).

3. Set the JWT secret (one-time)
The JWT signing key is NOT in appsettings.json (that would indeed be silly — committing secrets to source control is the problem you already flagged). The API reads it from an environment variable at startup.
run this in terminal
setx JWT_SECRET_KEY "..."

4. Run the backend
cd MedLab.Api
dotnet restore
dotnet run

5. Run the frontend
In the React project root:

npm install
npm run dev
