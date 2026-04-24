-- ============================================
-- MedicaLab Database Schema
-- Run this in SQL Server Management Studio ONCE before starting the API.
-- ============================================

IF DB_ID('medicalab') IS NULL
BEGIN
    CREATE DATABASE medicalab;
END
GO

USE medicalab;
GO

-- ============================================
-- Reference tables (from your original schema)
-- ============================================
IF OBJECT_ID('dbo.TestCategories', 'U') IS NULL
BEGIN
    CREATE TABLE TestCategories (
        Id INT PRIMARY KEY IDENTITY(1,1),
        CategoryName NVARCHAR(100) NOT NULL
    );
END
GO

IF OBJECT_ID('dbo.LabTests', 'U') IS NULL
BEGIN
    CREATE TABLE LabTests (
        Id INT PRIMARY KEY IDENTITY(1,1),
        TestName NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

IF OBJECT_ID('dbo.Specialists', 'U') IS NULL
BEGIN
    CREATE TABLE Specialists (
        Id INT PRIMARY KEY IDENTITY(1,1),
        FullName NVARCHAR(200) NOT NULL,
        Specialization NVARCHAR(100) NULL,
        Bio NVARCHAR(MAX) NULL,
        ProfilePictureURL NVARCHAR(MAX) NULL
    );
END
GO

-- ============================================
-- Users (extended with security fields)
-- ============================================
IF OBJECT_ID('dbo.Users', 'U') IS NULL
BEGIN
    CREATE TABLE Users (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        UserName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(MAX) NOT NULL,
        PasswordSalt NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        IsActive BIT NOT NULL DEFAULT 1,
        IsApproved BIT NOT NULL DEFAULT 0
    );
END
GO

-- ============================================
-- RBAC: Roles + UserRoles (many-to-many)
-- ============================================
IF OBJECT_ID('dbo.Roles', 'U') IS NULL
BEGIN
    CREATE TABLE Roles (
        Id INT PRIMARY KEY IDENTITY(1,1),
        RoleName NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(200) NULL
    );
END
GO

IF OBJECT_ID('dbo.UserRoles', 'U') IS NULL
BEGIN
    CREATE TABLE UserRoles (
        UserId UNIQUEIDENTIFIER NOT NULL,
        RoleId INT NOT NULL,
        AssignedAt DATETIME NOT NULL DEFAULT GETDATE(),
        PRIMARY KEY (UserId, RoleId),
        FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
        FOREIGN KEY (RoleId) REFERENCES Roles(Id) ON DELETE CASCADE
    );
END
GO

-- ============================================
-- Clinical Reports (owned by a patient = UserId)
-- ============================================
IF OBJECT_ID('dbo.ClinicalReports', 'U') IS NULL
BEGIN
    CREATE TABLE ClinicalReports (
        Id INT PRIMARY KEY IDENTITY(1,1),
        LabTestId INT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL,          -- patient owner
        CreatedByUserId UNIQUEIDENTIFIER NULL,     -- doctor who created it
        UrgencyLevel INT NULL,
        Findings NVARCHAR(MAX) NULL,
        ReportDate DATETIME NOT NULL DEFAULT GETDATE(),
        FOREIGN KEY (LabTestId) REFERENCES LabTests(Id),
        FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
        FOREIGN KEY (CreatedByUserId) REFERENCES Users(Id)
    );
END
GO

-- ============================================
-- Session management (for JWT revocation on logout)
-- ============================================
IF OBJECT_ID('dbo.Sessions', 'U') IS NULL
BEGIN
    CREATE TABLE Sessions (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        UserId UNIQUEIDENTIFIER NOT NULL,
        TokenId NVARCHAR(100) NOT NULL UNIQUE,     -- JWT jti claim
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        ExpiresAt DATETIME NOT NULL,
        IsRevoked BIT NOT NULL DEFAULT 0,
        FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
    );
    CREATE INDEX IX_Sessions_TokenId ON Sessions(TokenId);
END
GO

-- ============================================
-- Rate limiting: track failed login attempts
-- ============================================
IF OBJECT_ID('dbo.LoginAttempts', 'U') IS NULL
BEGIN
    CREATE TABLE LoginAttempts (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Email NVARCHAR(100) NOT NULL,
        AttemptedAt DATETIME NOT NULL DEFAULT GETDATE(),
        Success BIT NOT NULL DEFAULT 0
    );
    CREATE INDEX IX_LoginAttempts_Email_Time ON LoginAttempts(Email, AttemptedAt);
END
GO

-- ============================================
-- Seed roles (REQUIRED — the app depends on these 3 rows)
-- ============================================
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Admin')
    INSERT INTO Roles (RoleName, Description) VALUES ('Admin', 'Full system access');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Doctor')
    INSERT INTO Roles (RoleName, Description) VALUES ('Doctor', 'Can create and view lab reports');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Patient')
    INSERT INTO Roles (RoleName, Description) VALUES ('Patient', 'Can only view their own reports');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Specialist')
    INSERT INTO Roles (RoleName, Description) VALUES ('Specialist', 'Can create reports and manage lab tests');
GO

-- ============================================
-- Sample lab tests (OPTIONAL — safe to skip)
-- ============================================
IF NOT EXISTS (SELECT 1 FROM LabTests)
BEGIN
    INSERT INTO LabTests (TestName, Description) VALUES
    ('Complete Blood Count (CBC)', 'Screens for anemia, infection, and many other diseases.'),
    ('HbA1c', 'Measures average blood sugar levels over the past 3 months.');
END
GO

IF NOT EXISTS (SELECT 1 FROM Specialists)
BEGIN
    INSERT INTO Specialists (FullName, Specialization, Bio) VALUES
    ('Dr. Elena Rose', 'Hematology', 'Specialist in blood disorders and pathology.'),
    ('Dr. Marcus Thorne', 'Endocrinology', 'Focused on diabetic care and metabolic health.');
END
GO

PRINT 'Schema ready.';
