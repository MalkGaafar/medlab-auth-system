USE [master]
GO
/****** Object:  Database [medicalab]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE DATABASE [medicalab]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'medicalab', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\medicalab.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'medicalab_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\medicalab_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [medicalab] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [medicalab].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [medicalab] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [medicalab] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [medicalab] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [medicalab] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [medicalab] SET ARITHABORT OFF 
GO
ALTER DATABASE [medicalab] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [medicalab] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [medicalab] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [medicalab] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [medicalab] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [medicalab] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [medicalab] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [medicalab] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [medicalab] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [medicalab] SET  ENABLE_BROKER 
GO
ALTER DATABASE [medicalab] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [medicalab] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [medicalab] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [medicalab] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [medicalab] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [medicalab] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [medicalab] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [medicalab] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [medicalab] SET  MULTI_USER 
GO
ALTER DATABASE [medicalab] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [medicalab] SET DB_CHAINING OFF 
GO
ALTER DATABASE [medicalab] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [medicalab] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [medicalab] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [medicalab] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [medicalab] SET QUERY_STORE = ON
GO
ALTER DATABASE [medicalab] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [medicalab]
GO
/****** Object:  Table [dbo].[ClinicalReports]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClinicalReports](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LabTestId] [int] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[AssignedDoctorId] [uniqueidentifier] NULL,
	[UrgencyLevel] [int] NULL,
	[Findings] [nvarchar](max) NULL,
	[Result] [nvarchar](500) NULL,
	[NormalRange] [nvarchar](500) NULL,
	[Notes] [nvarchar](max) NULL,
	[FinalVerdict] [nvarchar](max) NULL,
	[LabTestName] [nvarchar](200) NULL,
	[ReportDate] [datetime] NOT NULL,
	[VerdictGivenAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LabTests]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabTests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TestName] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[NormalRange] [nvarchar](500) NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoginAttempts]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginAttempts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[AttemptedAt] [datetime] NOT NULL,
	[Success] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RefreshTokens]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RefreshTokens](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TokenHash] [nvarchar](128) NOT NULL,
	[AccessJti] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpiresAt] [datetime] NOT NULL,
	[IsRevoked] [bit] NOT NULL,
	[ReplacedBy] [nvarchar](128) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportResults]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportResults](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[LabTestId] [int] NOT NULL,
	[ResultValue] [nvarchar](500) NULL,
	[RecordedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sessions]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sessions](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TokenId] [nvarchar](100) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpiresAt] [datetime] NOT NULL,
	[IsRevoked] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Specialists]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Specialists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](200) NOT NULL,
	[Specialization] [nvarchar](100) NULL,
	[Bio] [nvarchar](max) NULL,
	[ProfilePictureURL] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestCategories]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [int] NOT NULL,
	[AssignedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 4/25/2026 1:13:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[PasswordSalt] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ClinicalReports] ON 

INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (1, 1, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Routine Complete Blood Count: Hemoglobin (Hb) measurement. Sample collected and processed by lab specialist.', N'14.2 g/dL', N'13.5 - 17.5 (M) / 12.0 - 15.5 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hemoglobin (Hb)', CAST(N'2026-03-14T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (2, 2, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Routine Complete Blood Count: Hematocrit (Hct) measurement. Sample collected and processed by lab specialist.', N'42 %', N'41 - 53 (M) / 36 - 46 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hematocrit (Hct)', CAST(N'2026-03-14T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (3, 3, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, N'Routine Complete Blood Count: White Blood Cells (WBC) measurement. Sample collected and processed by lab specialist.', N'6.8 x10^3/uL', N'4.0 - 11.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'White Blood Cells (WBC)', CAST(N'2026-03-14T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (4, 4, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 3, N'Routine Complete Blood Count: Platelets measurement. Sample collected and processed by lab specialist.', N'275 x10^3/uL', N'150 - 450', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Platelets', CAST(N'2026-03-14T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (5, 5, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Routine Complete Blood Count: Red Blood Cells (RBC) measurement. Sample collected and processed by lab specialist.', N'5.0 x10^6/uL', N'4.5 - 5.9 (M) / 4.1 - 5.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Red Blood Cells (RBC)', CAST(N'2026-03-14T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (6, 6, N'db53b821-0140-496a-98ed-83a5ce364520', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Diabetes Screening Panel: Fasting Blood Glucose measurement. Sample collected and processed by lab specialist.', N'142 mg/dL', N'70 - 99', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Fasting Blood Glucose', CAST(N'2026-04-06T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (7, 7, N'db53b821-0140-496a-98ed-83a5ce364520', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Diabetes Screening Panel: HbA1c measurement. Sample collected and processed by lab specialist.', N'7.8 %', N'4.0 - 5.6', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HbA1c', CAST(N'2026-04-06T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (8, 8, N'db53b821-0140-496a-98ed-83a5ce364520', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Diabetes Screening Panel: Sodium (Na) measurement. Sample collected and processed by lab specialist.', N'139 mmol/L', N'135 - 145', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Sodium (Na)', CAST(N'2026-04-06T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (9, 9, N'db53b821-0140-496a-98ed-83a5ce364520', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Diabetes Screening Panel: Potassium (K) measurement. Sample collected and processed by lab specialist.', N'4.2 mmol/L', N'3.5 - 5.1', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Potassium (K)', CAST(N'2026-04-06T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (10, 10, N'db53b821-0140-496a-98ed-83a5ce364520', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Diabetes Screening Panel: Calcium (Ca) measurement. Sample collected and processed by lab specialist.', N'9.5 mg/dL', N'8.6 - 10.3', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Calcium (Ca)', CAST(N'2026-04-06T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (11, 11, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 1, N'Lipid Profile Workup: Total Cholesterol measurement. Sample collected and processed by lab specialist.', N'248 mg/dL', N'< 200', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Cholesterol', CAST(N'2026-03-07T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (12, 12, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 2, N'Lipid Profile Workup: LDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'165 mg/dL', N'< 100', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'LDL Cholesterol', CAST(N'2026-03-07T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (13, 13, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 1, N'Lipid Profile Workup: HDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'38 mg/dL', N'> 40 (M) / > 50 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HDL Cholesterol', CAST(N'2026-03-07T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (14, 14, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 1, N'Lipid Profile Workup: Triglycerides measurement. Sample collected and processed by lab specialist.', N'210 mg/dL', N'< 150', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Triglycerides', CAST(N'2026-03-07T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (15, 15, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'91ae786a-3188-46e2-bba3-ef919971988e', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Liver Function Test: ALT (SGPT) measurement. Sample collected and processed by lab specialist.', N'22 U/L', N'7 - 56', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'ALT (SGPT)', CAST(N'2026-02-24T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (16, 16, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'91ae786a-3188-46e2-bba3-ef919971988e', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, N'Liver Function Test: AST (SGOT) measurement. Sample collected and processed by lab specialist.', N'26 U/L', N'10 - 40', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'AST (SGOT)', CAST(N'2026-02-24T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (17, 17, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'91ae786a-3188-46e2-bba3-ef919971988e', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, N'Liver Function Test: Total Bilirubin measurement. Sample collected and processed by lab specialist.', N'0.8 mg/dL', N'0.1 - 1.2', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Bilirubin', CAST(N'2026-02-24T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (18, 18, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'91ae786a-3188-46e2-bba3-ef919971988e', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Liver Function Test: Albumin measurement. Sample collected and processed by lab specialist.', N'4.4 g/dL', N'3.5 - 5.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Albumin', CAST(N'2026-02-24T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (19, 15, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e58e38fe-07de-417b-b939-55c8198a252a', 1, N'Liver Function Follow-up: ALT (SGPT) measurement. Sample collected and processed by lab specialist.', N'98 U/L', N'7 - 56', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'ALT (SGPT)', CAST(N'2026-03-27T11:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (20, 16, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e58e38fe-07de-417b-b939-55c8198a252a', 1, N'Liver Function Follow-up: AST (SGOT) measurement. Sample collected and processed by lab specialist.', N'85 U/L', N'10 - 40', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'AST (SGOT)', CAST(N'2026-03-27T11:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (21, 17, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e58e38fe-07de-417b-b939-55c8198a252a', 2, N'Liver Function Follow-up: Total Bilirubin measurement. Sample collected and processed by lab specialist.', N'2.1 mg/dL', N'0.1 - 1.2', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Bilirubin', CAST(N'2026-03-27T11:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (22, 18, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e58e38fe-07de-417b-b939-55c8198a252a', 2, N'Liver Function Follow-up: Albumin measurement. Sample collected and processed by lab specialist.', N'3.2 g/dL', N'3.5 - 5.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Albumin', CAST(N'2026-03-27T11:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (23, 19, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Kidney Function Panel: Creatinine measurement. Sample collected and processed by lab specialist.', N'1.0 mg/dL', N'0.7 - 1.3 (M) / 0.6 - 1.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Creatinine', CAST(N'2026-04-10T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (24, 20, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, N'Kidney Function Panel: Blood Urea Nitrogen (BUN) measurement. Sample collected and processed by lab specialist.', N'14 mg/dL', N'7 - 20', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Blood Urea Nitrogen (BUN)', CAST(N'2026-04-10T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (25, 21, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Kidney Function Panel: Uric Acid measurement. Sample collected and processed by lab specialist.', N'5.2 mg/dL', N'3.4 - 7.0 (M) / 2.4 - 6.0 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Uric Acid', CAST(N'2026-04-10T05:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (26, 19, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'91ae786a-3188-46e2-bba3-ef919971988e', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Kidney Function – Suspected CKD: Creatinine measurement. Sample collected and processed by lab specialist.', N'2.4 mg/dL', N'0.7 - 1.3 (M) / 0.6 - 1.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Creatinine', CAST(N'2026-04-21T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (27, 20, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'91ae786a-3188-46e2-bba3-ef919971988e', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 3, N'Kidney Function – Suspected CKD: Blood Urea Nitrogen (BUN) measurement. Sample collected and processed by lab specialist.', N'38 mg/dL', N'7 - 20', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Blood Urea Nitrogen (BUN)', CAST(N'2026-04-21T19:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (28, 21, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'91ae786a-3188-46e2-bba3-ef919971988e', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 3, N'Kidney Function – Suspected CKD: Uric Acid measurement. Sample collected and processed by lab specialist.', N'8.1 mg/dL', N'3.4 - 7.0 (M) / 2.4 - 6.0 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', N'Clear', N'Uric Acid', CAST(N'2026-04-21T19:00:00.000' AS DateTime), CAST(N'2026-04-24T21:42:36.277' AS DateTime))
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (29, 22, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 2, N'Thyroid Panel: TSH measurement. Sample collected and processed by lab specialist.', N'6.8 mIU/L', N'0.4 - 4.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'TSH', CAST(N'2026-03-12T14:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (30, 23, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 1, N'Thyroid Panel: Free T4 measurement. Sample collected and processed by lab specialist.', N'0.6 ng/dL', N'0.8 - 1.8', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Free T4', CAST(N'2026-03-12T14:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (31, 24, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 2, N'Thyroid Panel: Vitamin D (25-OH) measurement. Sample collected and processed by lab specialist.', N'18 ng/mL', N'30 - 100', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Vitamin D (25-OH)', CAST(N'2026-03-12T14:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (32, 1, N'941cb579-57d3-447a-af1a-62a19fe9c371', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, N'Anemia Workup: Hemoglobin (Hb) measurement. Sample collected and processed by lab specialist.', N'9.8 g/dL', N'13.5 - 17.5 (M) / 12.0 - 15.5 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hemoglobin (Hb)', CAST(N'2026-04-08T22:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (33, 2, N'941cb579-57d3-447a-af1a-62a19fe9c371', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, N'Anemia Workup: Hematocrit (Hct) measurement. Sample collected and processed by lab specialist.', N'31 %', N'41 - 53 (M) / 36 - 46 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hematocrit (Hct)', CAST(N'2026-04-08T22:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (34, 3, N'941cb579-57d3-447a-af1a-62a19fe9c371', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Anemia Workup: White Blood Cells (WBC) measurement. Sample collected and processed by lab specialist.', N'5.2 x10^3/uL', N'4.0 - 11.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'White Blood Cells (WBC)', CAST(N'2026-04-08T22:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (35, 4, N'941cb579-57d3-447a-af1a-62a19fe9c371', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Anemia Workup: Platelets measurement. Sample collected and processed by lab specialist.', N'190 x10^3/uL', N'150 - 450', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Platelets', CAST(N'2026-04-08T22:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (36, 5, N'941cb579-57d3-447a-af1a-62a19fe9c371', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Anemia Workup: Red Blood Cells (RBC) measurement. Sample collected and processed by lab specialist.', N'3.8 x10^6/uL', N'4.5 - 5.9 (M) / 4.1 - 5.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Red Blood Cells (RBC)', CAST(N'2026-04-08T22:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (37, 27, N'c5f84d62-1951-4689-82a8-944b93063d2f', N'91ae786a-3188-46e2-bba3-ef919971988e', NULL, 2, N'Inflammation Markers: C-Reactive Protein (CRP) measurement. Sample collected and processed by lab specialist.', N'28 mg/L', N'< 5', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'C-Reactive Protein (CRP)', CAST(N'2026-03-03T12:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (38, 28, N'c5f84d62-1951-4689-82a8-944b93063d2f', N'91ae786a-3188-46e2-bba3-ef919971988e', NULL, 1, N'Inflammation Markers: ESR measurement. Sample collected and processed by lab specialist.', N'45 mm/hr', N'0 - 22 (M) / 0 - 29 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'ESR', CAST(N'2026-03-03T12:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (39, 25, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Routine Urinalysis: Urine Protein measurement. Sample collected and processed by lab specialist.', N'75 mg/dL', N'Negative', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Urine Protein', CAST(N'2026-04-12T14:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (40, 26, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, N'Routine Urinalysis: Urine Glucose measurement. Sample collected and processed by lab specialist.', N'120 mg/dL', N'Negative', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Urine Glucose', CAST(N'2026-04-12T14:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (41, 6, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Annual Health Checkup: Fasting Blood Glucose measurement. Sample collected and processed by lab specialist.', N'88 mg/dL', N'70 - 99', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Fasting Blood Glucose', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (42, 7, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Annual Health Checkup: HbA1c measurement. Sample collected and processed by lab specialist.', N'5.2 %', N'4.0 - 5.6', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HbA1c', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (43, 11, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Annual Health Checkup: Total Cholesterol measurement. Sample collected and processed by lab specialist.', N'180 mg/dL', N'< 200', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Cholesterol', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (44, 12, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Annual Health Checkup: LDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'92 mg/dL', N'< 100', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'LDL Cholesterol', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (45, 13, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Annual Health Checkup: HDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'55 mg/dL', N'> 40 (M) / > 50 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HDL Cholesterol', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (46, 14, N'db53b821-0140-496a-98ed-83a5ce364520', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Annual Health Checkup: Triglycerides measurement. Sample collected and processed by lab specialist.', N'120 mg/dL', N'< 150', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Triglycerides', CAST(N'2026-04-06T08:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (47, 1, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'91ae786a-3188-46e2-bba3-ef919971988e', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 3, N'Routine Complete Blood Count: Hemoglobin (Hb) measurement. Sample collected and processed by lab specialist.', N'14.2 g/dL', N'13.5 - 17.5 (M) / 12.0 - 15.5 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hemoglobin (Hb)', CAST(N'2026-03-06T02:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (48, 2, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'91ae786a-3188-46e2-bba3-ef919971988e', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 1, N'Routine Complete Blood Count: Hematocrit (Hct) measurement. Sample collected and processed by lab specialist.', N'42 %', N'41 - 53 (M) / 36 - 46 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Hematocrit (Hct)', CAST(N'2026-03-06T02:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (49, 3, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'91ae786a-3188-46e2-bba3-ef919971988e', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 1, N'Routine Complete Blood Count: White Blood Cells (WBC) measurement. Sample collected and processed by lab specialist.', N'6.8 x10^3/uL', N'4.0 - 11.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'White Blood Cells (WBC)', CAST(N'2026-03-06T02:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (50, 4, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'91ae786a-3188-46e2-bba3-ef919971988e', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 2, N'Routine Complete Blood Count: Platelets measurement. Sample collected and processed by lab specialist.', N'275 x10^3/uL', N'150 - 450', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Platelets', CAST(N'2026-03-06T02:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (51, 5, N'316f6921-d80e-4256-a274-6dcaa72682c0', N'91ae786a-3188-46e2-bba3-ef919971988e', N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 2, N'Routine Complete Blood Count: Red Blood Cells (RBC) measurement. Sample collected and processed by lab specialist.', N'5.0 x10^6/uL', N'4.5 - 5.9 (M) / 4.1 - 5.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Red Blood Cells (RBC)', CAST(N'2026-03-06T02:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (52, 6, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 3, N'Diabetes Screening Panel: Fasting Blood Glucose measurement. Sample collected and processed by lab specialist.', N'142 mg/dL', N'70 - 99', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Fasting Blood Glucose', CAST(N'2026-03-30T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (53, 7, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Diabetes Screening Panel: HbA1c measurement. Sample collected and processed by lab specialist.', N'7.8 %', N'4.0 - 5.6', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HbA1c', CAST(N'2026-03-30T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (54, 8, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Diabetes Screening Panel: Sodium (Na) measurement. Sample collected and processed by lab specialist.', N'139 mmol/L', N'135 - 145', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Sodium (Na)', CAST(N'2026-03-30T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (55, 9, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 1, N'Diabetes Screening Panel: Potassium (K) measurement. Sample collected and processed by lab specialist.', N'4.2 mmol/L', N'3.5 - 5.1', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Potassium (K)', CAST(N'2026-03-30T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (56, 10, N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, N'Diabetes Screening Panel: Calcium (Ca) measurement. Sample collected and processed by lab specialist.', N'9.5 mg/dL', N'8.6 - 10.3', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Calcium (Ca)', CAST(N'2026-03-30T09:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (57, 11, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e58e38fe-07de-417b-b939-55c8198a252a', 3, N'Lipid Profile Workup: Total Cholesterol measurement. Sample collected and processed by lab specialist.', N'248 mg/dL', N'< 200', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Cholesterol', CAST(N'2026-03-31T17:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (58, 12, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e58e38fe-07de-417b-b939-55c8198a252a', 1, N'Lipid Profile Workup: LDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'165 mg/dL', N'< 100', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'LDL Cholesterol', CAST(N'2026-03-31T17:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (59, 13, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e58e38fe-07de-417b-b939-55c8198a252a', 2, N'Lipid Profile Workup: HDL Cholesterol measurement. Sample collected and processed by lab specialist.', N'38 mg/dL', N'> 40 (M) / > 50 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'HDL Cholesterol', CAST(N'2026-03-31T17:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (60, 14, N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'e58e38fe-07de-417b-b939-55c8198a252a', 1, N'Lipid Profile Workup: Triglycerides measurement. Sample collected and processed by lab specialist.', N'210 mg/dL', N'< 150', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Triglycerides', CAST(N'2026-03-31T17:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (61, 15, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, N'Liver Function Test: ALT (SGPT) measurement. Sample collected and processed by lab specialist.', N'22 U/L', N'7 - 56', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'ALT (SGPT)', CAST(N'2026-04-20T13:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (62, 16, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 1, N'Liver Function Test: AST (SGOT) measurement. Sample collected and processed by lab specialist.', N'26 U/L', N'10 - 40', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'AST (SGOT)', CAST(N'2026-04-20T13:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (63, 17, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, N'Liver Function Test: Total Bilirubin measurement. Sample collected and processed by lab specialist.', N'0.8 mg/dL', N'0.1 - 1.2', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Bilirubin', CAST(N'2026-04-20T13:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (64, 18, N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'91ae786a-3188-46e2-bba3-ef919971988e', N'477ac875-73b9-4042-b45a-208afd0c7e62', 3, N'Liver Function Test: Albumin measurement. Sample collected and processed by lab specialist.', N'4.4 g/dL', N'3.5 - 5.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Albumin', CAST(N'2026-04-20T13:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (65, 15, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Liver Function Follow-up: ALT (SGPT) measurement. Sample collected and processed by lab specialist.', N'98 U/L', N'7 - 56', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'ALT (SGPT)', CAST(N'2026-04-16T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (66, 16, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Liver Function Follow-up: AST (SGOT) measurement. Sample collected and processed by lab specialist.', N'85 U/L', N'10 - 40', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'AST (SGOT)', CAST(N'2026-04-16T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (67, 17, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 1, N'Liver Function Follow-up: Total Bilirubin measurement. Sample collected and processed by lab specialist.', N'2.1 mg/dL', N'0.1 - 1.2', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Total Bilirubin', CAST(N'2026-04-16T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (68, 18, N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'Liver Function Follow-up: Albumin measurement. Sample collected and processed by lab specialist.', N'3.2 g/dL', N'3.5 - 5.0', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Albumin', CAST(N'2026-04-16T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (69, 19, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 2, N'Kidney Function Panel: Creatinine measurement. Sample collected and processed by lab specialist.', N'1.0 mg/dL', N'0.7 - 1.3 (M) / 0.6 - 1.1 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Creatinine', CAST(N'2026-04-04T16:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (70, 20, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 2, N'Kidney Function Panel: Blood Urea Nitrogen (BUN) measurement. Sample collected and processed by lab specialist.', N'14 mg/dL', N'7 - 20', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Blood Urea Nitrogen (BUN)', CAST(N'2026-04-04T16:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (71, 21, N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'a0365dea-479b-4abb-bf1c-6f184181d54d', NULL, 1, N'Kidney Function Panel: Uric Acid measurement. Sample collected and processed by lab specialist.', N'5.2 mg/dL', N'3.4 - 7.0 (M) / 2.4 - 6.0 (F)', N'Sample collected and processed by lab technician. Awaiting doctor''s review.', NULL, N'Uric Acid', CAST(N'2026-04-04T16:00:00.000' AS DateTime), NULL)
INSERT [dbo].[ClinicalReports] ([Id], [LabTestId], [UserId], [CreatedByUserId], [AssignedDoctorId], [UrgencyLevel], [Findings], [Result], [NormalRange], [Notes], [FinalVerdict], [LabTestName], [ReportDate], [VerdictGivenAt]) VALUES (72, 29, N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'91ae786a-3188-46e2-bba3-ef919971988e', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, N'ttt', N'tt', N'dd', NULL, NULL, N'Test', CAST(N'2026-04-24T21:44:00.553' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[ClinicalReports] OFF
GO
SET IDENTITY_INSERT [dbo].[LabTests] ON 

INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (1, N'Hemoglobin (Hb)', N'Oxygen-carrying protein in red blood cells. Range: 12.0-17.5 g/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (2, N'Hematocrit (Hct)', N'Volume percentage of red blood cells. Range: 36-53%', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (3, N'White Blood Cells (WBC)', N'Total white blood cell count. Range: 4.0-11.0 x10^3/uL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (4, N'Platelets', N'Platelet count for clotting. Range: 150-450 x10^3/uL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (5, N'Red Blood Cells (RBC)', N'Total red blood cell count. Range: 4.1-5.9 x10^6/uL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (6, N'Fasting Blood Glucose', N'Blood sugar after 8h fasting. Range: 70-99 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (7, N'HbA1c', N'Average blood sugar over 3 months. Range: 4.0-5.6%', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (8, N'Sodium (Na)', N'Serum sodium concentration. Range: 135-145 mmol/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (9, N'Potassium (K)', N'Serum potassium concentration. Range: 3.5-5.1 mmol/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (10, N'Calcium (Ca)', N'Total serum calcium. Range: 8.6-10.3 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (11, N'Total Cholesterol', N'Total blood cholesterol. Range: < 200 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (12, N'LDL Cholesterol', N'Low-density lipoprotein. Range: < 100 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (13, N'HDL Cholesterol', N'High-density lipoprotein. Range: > 40 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (14, N'Triglycerides', N'Blood triglyceride level. Range: < 150 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (15, N'ALT (SGPT)', N'Alanine aminotransferase. Range: 7-56 U/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (16, N'AST (SGOT)', N'Aspartate aminotransferase. Range: 10-40 U/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (17, N'Total Bilirubin', N'Total bilirubin in blood. Range: 0.1-1.2 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (18, N'Albumin', N'Serum albumin protein. Range: 3.5-5.0 g/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (19, N'Creatinine', N'Marker of kidney function. Range: 0.6-1.3 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (20, N'Blood Urea Nitrogen (BUN)', N'Nitrogen waste product. Range: 7-20 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (21, N'Uric Acid', N'Purine metabolism byproduct. Range: 2.4-7.0 mg/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (22, N'TSH', N'Thyroid stimulating hormone. Range: 0.4-4.0 mIU/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (23, N'Free T4', N'Free thyroxine. Range: 0.8-1.8 ng/dL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (24, N'Vitamin D (25-OH)', N'Vitamin D blood level. Range: 30-100 ng/mL', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (25, N'Urine Protein', N'Protein presence in urine. Range: Negative', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (26, N'Urine Glucose', N'Glucose presence in urine. Range: Negative', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (27, N'C-Reactive Protein (CRP)', N'Acute inflammation marker. Range: < 5 mg/L', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (28, N'ESR', N'Erythrocyte sedimentation rate. Range: 0-29 mm/hr', NULL, NULL, CAST(N'2026-04-25T00:24:28.987' AS DateTime))
INSERT [dbo].[LabTests] ([Id], [TestName], [Description], [NormalRange], [CreatedByUserId], [CreatedAt]) VALUES (29, N'Test', N'20', N'dd', N'91ae786a-3188-46e2-bba3-ef919971988e', CAST(N'2026-04-24T21:43:33.453' AS DateTime))
SET IDENTITY_INSERT [dbo].[LabTests] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginAttempts] ON 

INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (2, N'admin@metlab.com', CAST(N'2026-04-23T22:31:24.230' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (3, N'admin@metlab.com', CAST(N'2026-04-23T22:31:33.130' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (4, N'admin@metlab.com', CAST(N'2026-04-23T22:31:44.493' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (43, N'eCtoue@LDwblsCJnJLiRFImXtPOkoeBtevrFpmzO.ilq', CAST(N'2026-04-24T19:08:08.743' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (44, N'eCtoue@LDwblsCJnJLiRFImXtPOkoeBtevrFpmzO.ilq', CAST(N'2026-04-24T19:08:28.860' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (45, N'admin@example.com', CAST(N'2026-04-24T19:10:32.920' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (46, N'admin@example.com', CAST(N'2026-04-24T19:10:40.813' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (51, N'admin@medlab.com', CAST(N'2026-04-24T21:13:02.443' AS DateTime), 0)
INSERT [dbo].[LoginAttempts] ([Id], [Email], [AttemptedAt], [Success]) VALUES (53, N'admin@medlab.com', CAST(N'2026-04-24T21:15:37.290' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[LoginAttempts] OFF
GO
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'19589374-4250-4112-9601-19f35f2d6586', N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'BB95CCDD84FD00F48AABA315DD748A595007DD1B92C9E0B0CE3CE1515D35CE18', N'e4e28104b68f4896b1cd8bf6c3f4cc9a', CAST(N'2026-04-24T21:44:48.177' AS DateTime), CAST(N'2026-05-08T21:44:48.177' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'ebfe6bba-0d26-40e9-ae0e-68ef690dc858', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'DD022457B93318325D0FC4EA5C8398BF81F2230F87A52521607C7B80A9E7648F', N'a9ebb15b385f4e4e9be1d664e9ad4375', CAST(N'2026-04-24T21:15:02.850' AS DateTime), CAST(N'2026-05-08T21:15:02.847' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'cd643db7-c9b1-4b43-8aff-7d43a2afe5a2', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', N'6DA33363D3F3173C7B4913DB35125052AF2C11BB8958BEDAB038CC84AB33A96A', N'eb27ff50034243888fe2307d0a17af09', CAST(N'2026-04-24T21:46:44.583' AS DateTime), CAST(N'2026-05-08T21:46:44.583' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'f03f0098-a3fc-4571-a9e9-832456e3fb6a', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'F580F74D25BE3DC5C1AAF403478236A19ADEE3713E626601179ECE3392AB4F39', N'cb707a7e2d1f4418b13399dd1fd702b0', CAST(N'2026-04-24T21:40:41.743' AS DateTime), CAST(N'2026-05-08T21:40:41.743' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'157971b5-96ff-4cb2-850e-ac55470d1075', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', N'E0621938B5ADC028B79586B9F67DC3AF103697622C441E138EA815995C38E1C0', N'1bb6dbce8d58495099b696d1641bb842', CAST(N'2026-04-24T21:42:15.847' AS DateTime), CAST(N'2026-05-08T21:42:15.847' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'a331e437-e180-44fe-9e89-befcbb7701cd', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'6990CDB8E37FE8F20E7BBAC4D3BA6139045B3311FF503D6104FDC34AE8B20C5A', N'a19aa1e3682d4192b0e548f0281486c9', CAST(N'2026-04-24T21:21:03.107' AS DateTime), CAST(N'2026-05-08T21:21:03.107' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'c6cb589f-0534-43d8-84b6-c53bc48e70d6', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'5347B9B0F25A17B05FD8F65EC0FBCC0E374BE1BDC113393F9671FD0E4650CB4B', N'e0281ac6301441bc9d3839871265edeb', CAST(N'2026-04-24T21:15:41.713' AS DateTime), CAST(N'2026-05-08T21:15:41.713' AS DateTime), 0, NULL)
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [AccessJti], [CreatedAt], [ExpiresAt], [IsRevoked], [ReplacedBy]) VALUES (N'334455bc-4360-495b-ac60-cdd6cdcfe6dc', N'91ae786a-3188-46e2-bba3-ef919971988e', N'4EDFF14D8E7AE2C2511B2D670503128FA5FE2A7D0FB29E863446B163F66E1C2F', N'ecc3ffe1f0214cbbaf33917fc1f7ed87', CAST(N'2026-04-24T21:43:19.437' AS DateTime), CAST(N'2026-05-08T21:43:19.437' AS DateTime), 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [RoleName], [Description]) VALUES (1, N'Admin', N'Full system access, approves doctors and specialists')
INSERT [dbo].[Roles] ([Id], [RoleName], [Description]) VALUES (2, N'Doctor', N'Reviews lab reports and gives the final medical verdict')
INSERT [dbo].[Roles] ([Id], [RoleName], [Description]) VALUES (3, N'Specialist', N'Defines lab tests and enters lab results')
INSERT [dbo].[Roles] ([Id], [RoleName], [Description]) VALUES (4, N'Patient', N'Views their own reports only')
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'0e3f1868-01dd-4b2d-8ee8-0228e34f3576', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'a19aa1e3682d4192b0e548f0281486c9', CAST(N'2026-04-24T21:21:03.107' AS DateTime), CAST(N'2026-04-25T21:21:03.103' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'f1774c23-5c19-46d8-862c-49afe52ea5a6', N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'e4e28104b68f4896b1cd8bf6c3f4cc9a', CAST(N'2026-04-24T21:44:48.177' AS DateTime), CAST(N'2026-04-25T21:44:48.177' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'0e76c154-85de-4044-88eb-6bd19d661a9a', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'a9ebb15b385f4e4e9be1d664e9ad4375', CAST(N'2026-04-24T21:15:02.837' AS DateTime), CAST(N'2026-04-25T21:15:02.827' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'aff908ba-c944-4c4e-b7d4-73be90a6b475', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', N'1bb6dbce8d58495099b696d1641bb842', CAST(N'2026-04-24T21:42:15.843' AS DateTime), CAST(N'2026-04-25T21:42:15.843' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'd2af5b30-f264-48fa-b24f-7e4bed758e20', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'cb707a7e2d1f4418b13399dd1fd702b0', CAST(N'2026-04-24T21:40:41.740' AS DateTime), CAST(N'2026-04-25T21:40:41.740' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'de6d12e9-54d0-4d9b-b959-8af7d9c17d64', N'91ae786a-3188-46e2-bba3-ef919971988e', N'ecc3ffe1f0214cbbaf33917fc1f7ed87', CAST(N'2026-04-24T21:43:19.433' AS DateTime), CAST(N'2026-04-25T21:43:19.433' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'62286c4c-7d03-49cd-84a9-92f5ad00ebd0', N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'e0281ac6301441bc9d3839871265edeb', CAST(N'2026-04-24T21:15:41.713' AS DateTime), CAST(N'2026-04-25T21:15:41.710' AS DateTime), 1)
INSERT [dbo].[Sessions] ([Id], [UserId], [TokenId], [CreatedAt], [ExpiresAt], [IsRevoked]) VALUES (N'ef36ff87-ce47-4924-a05c-e391e1be3144', N'375177a2-3f32-4e09-a837-0b82b42d8f2a', N'eb27ff50034243888fe2307d0a17af09', CAST(N'2026-04-24T21:46:44.580' AS DateTime), CAST(N'2026-04-25T21:46:44.580' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[TestCategories] ON 

INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (1, N'Hematology', N'Blood cell counts and related studies')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (2, N'Biochemistry', N'Blood chemistry, enzymes, electrolytes')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (3, N'Lipid Profile', N'Cholesterol and triglycerides')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (4, N'Liver Function', N'Liver enzymes and proteins')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (5, N'Kidney Function', N'Renal markers and electrolytes')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (6, N'Endocrinology', N'Hormones and diabetes markers')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (7, N'Urinalysis', N'Urine physical and chemical analysis')
INSERT [dbo].[TestCategories] ([Id], [CategoryName], [Description]) VALUES (8, N'Microbiology', N'Cultures and infection markers')
SET IDENTITY_INSERT [dbo].[TestCategories] OFF
GO
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'11fb0b9a-d359-4527-994b-0abb3136fdcf', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'375177a2-3f32-4e09-a837-0b82b42d8f2a', 2, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'e08827c6-36bc-4db2-9114-0be3b0396de8', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'b2bbd736-5eba-4837-9544-18f8a6f756e9', 2, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', 3, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'477ac875-73b9-4042-b45a-208afd0c7e62', 2, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'b451dedd-05b9-43f7-89c0-4fe392dd008a', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'e58e38fe-07de-417b-b939-55c8198a252a', 2, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'941cb579-57d3-447a-af1a-62a19fe9c371', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'20e86953-239c-4b5a-9461-6bd9d399e58d', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'316f6921-d80e-4256-a274-6dcaa72682c0', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'a0365dea-479b-4abb-bf1c-6f184181d54d', 3, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'db53b821-0140-496a-98ed-83a5ce364520', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'c5f84d62-1951-4689-82a8-944b93063d2f', 4, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', 1, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'91ae786a-3188-46e2-bba3-ef919971988e', 3, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt]) VALUES (N'e3406ba9-c5af-4a61-bb3f-f916e74560be', 2, CAST(N'2026-01-24T10:00:00.000' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'11fb0b9a-d359-4527-994b-0abb3136fdcf', N'John Carter', N'john.carter@example.com', N'D/z9Cp/AF38qDnve+VdALLSSJwoOp8ePiW9mb2oF6Gk=', N'p7E6QLxQrcr+4vXwmdTv5Q==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'375177a2-3f32-4e09-a837-0b82b42d8f2a', N'Dr. Ahmed Hassan', N'a.hassan@medlab.local', N'5Y4Lej/PmEZGlWDUGcserBCgkJDfrPH3kiDXNIZcPNk=', N'g1KXZqPyweTIvHa1DFzMVQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'e08827c6-36bc-4db2-9114-0be3b0396de8', N'Michael Brown', N'michael.brown@example.com', N'ZdX6pat3knFZ6gBZiveuK6bt74MoFgQ68tDpGvkWNkA=', N'47cq6fiQqnMUZtpsu6ZNWw==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'b2bbd736-5eba-4837-9544-18f8a6f756e9', N'Dr. Emily Thompson', N'e.thompson@medlab.local', N'fe/xiRjo+f9MG3oaaekWFEjVZpa2WTAri6zV9zVQeRA=', N'aRblPeqlvQpaxdS7IfKc9A==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'dc9989c6-a17e-42f2-88c0-1a5ffc705019', N'Dr. Nadia Roberts (Biochemistry)', N'n.roberts@medlab.local', N'gX7Kz8N+5gJzGbvjtGj6YFAv6qIdm5VoWrJqEByNzG8=', N'0cbIWfWqVAXc5elHvBcteA==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'477ac875-73b9-4042-b45a-208afd0c7e62', N'Dr. Sarah Mitchell', N's.mitchell@medlab.local', N'WXqgQFMNokne7d6VAs4vHdWQei/u0BLQfSFzBlmajkw=', N'CIY7Opl/5JCq9slOVspxAg==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'7b929431-99d9-47a2-ad1e-4065e41ccd6c', N'Sophia Martinez', N'sophia.martinez@example.com', N'5k6lZUwPccdWPkBlPMEoM6lJhfg4wYsqeguBnya6PLI=', N'J/RWPFQkN686lQOpAJ0nqQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'b451dedd-05b9-43f7-89c0-4fe392dd008a', N'Hala Mostafa', N'hala.mostafa@example.com', N'RC0ZoJJYsAZ6q1WTQoXX/nnBRC4sagMOzW1maYj9mHM=', N'2clkpJwY69maGWYHjniVmQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'e58e38fe-07de-417b-b939-55c8198a252a', N'Dr. Laura Bennett', N'l.bennett@medlab.local', N'Jjj2Zw0kvbk8N93OKA+yHtSUVCpaD6BRklsl1/SGqps=', N'Uu+U7goOGPY/GE2XSxwwBA==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'941cb579-57d3-447a-af1a-62a19fe9c371', N'Olivia Davis', N'olivia.davis@example.com', N'vX5MRmlTCF8yT8xod6FFx+owCmDiqDg+AYD7/ZHkoFE=', N'ulGxottetRCwmk1LH9WcDQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'20e86953-239c-4b5a-9461-6bd9d399e58d', N'Fatma Ibrahim', N'fatma.ibrahim@example.com', N'ONSI0ldWq5rlosypHFVMsHJP1NvuKpiVgEmkDoA6U60=', N'pPpMBlYOXRWNDsw0WzkM/w==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'316f6921-d80e-4256-a274-6dcaa72682c0', N'David Wilson', N'david.wilson@example.com', N'cR+v26gIlruw4xIM3KtPmCawSwPBzpWRul8rrVDa7co=', N'NhnbJc9jtbUO6MXkb+g6gA==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'a0365dea-479b-4abb-bf1c-6f184181d54d', N'Dr. Karim Selim (Microbiology)', N'k.selim@medlab.local', N'Gwb86llOBbIX4mBYK6Y3qNvTQU9k2e7PyRogSNC0yqE=', N'3QFK9J/IW0t13NX4NkUMzA==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'db53b821-0140-496a-98ed-83a5ce364520', N'Mariam Saleh', N'mariam.saleh@example.com', N'ML2Nhiw7odD139VUkrdoNwBNlgV9tlczFUFqdnZPu9w=', N'Xl45P0MiEepaN0AszWmvqg==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'9ff1ab07-1ecf-4754-886f-8f2b44f3c221', N'Yusuf Abdelrahman', N'yusuf.a@example.com', N'mtw0GeRxrDBRcqLlJ5iy15U05qcgOfNdIvHZ5qcK3to=', N'PwfIpus/AlFVWPahm9fPBA==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'c5f84d62-1951-4689-82a8-944b93063d2f', N'Khaled Nour', N'khaled.nour@example.com', N'gOtx0um/sp3jLuzzfhNH64RsSueR7CLuiu2I/LBYajw=', N'Me/9vMOfi5CAy7lKqVA+5Q==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'45fd1709-5fd8-4b1a-93e4-be5a98c85acc', N'System Administrator', N'admin@medlab.local', N'zIPsP5huCs+WRS8rs4p0YHJMChtzV3XMLEWmFcbpTxw=', N'NRcPK6Eue+wItg4p9shSmQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'91ae786a-3188-46e2-bba3-ef919971988e', N'Dr. Omar Khalil (Hematology)', N'o.khalil@medlab.local', N'vI033VfeKThr+GH39JE/GYNFLkVHL9D8CsO8hxwJI8I=', N'I/6jscETYBbPuAZW5ChIrg==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Email], [PasswordHash], [PasswordSalt], [CreatedAt], [IsActive], [IsApproved], [IsDeleted], [DeletedAt]) VALUES (N'e3406ba9-c5af-4a61-bb3f-f916e74560be', N'Dr. Mohamed Farouk', N'm.farouk@medlab.local', N'uSAcRWU1Ak+XsD8wi65cjAxo7CJWcJbgI8VzE0a43D0=', N'71EHTJI2vhAdyySucTocvQ==', CAST(N'2026-01-24T10:00:00.000' AS DateTime), 1, 1, 0, NULL)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LoginAttempts_Email_Time]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_LoginAttempts_Email_Time] ON [dbo].[LoginAttempts]
(
	[Email] ASC,
	[AttemptedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__RefreshT__BCB33F924F3FD90E]    Script Date: 4/25/2026 1:13:03 AM ******/
ALTER TABLE [dbo].[RefreshTokens] ADD UNIQUE NONCLUSTERED 
(
	[TokenHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RefreshTokens_Expires]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_RefreshTokens_Expires] ON [dbo].[RefreshTokens]
(
	[ExpiresAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RefreshTokens_UserId]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_RefreshTokens_UserId] ON [dbo].[RefreshTokens]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Roles__8A2B61605B5B0A39]    Script Date: 4/25/2026 1:13:03 AM ******/
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Sessions__658FEEEB14650733]    Script Date: 4/25/2026 1:13:03 AM ******/
ALTER TABLE [dbo].[Sessions] ADD UNIQUE NONCLUSTERED 
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Sessions_TokenId]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_Sessions_TokenId] ON [dbo].[Sessions]
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D105347711FD44]    Script Date: 4/25/2026 1:13:03 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_IsDeleted]    Script Date: 4/25/2026 1:13:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_IsDeleted] ON [dbo].[Users]
(
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicalReports] ADD  DEFAULT (getdate()) FOR [ReportDate]
GO
ALTER TABLE [dbo].[LabTests] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[LoginAttempts] ADD  DEFAULT (getdate()) FOR [AttemptedAt]
GO
ALTER TABLE [dbo].[LoginAttempts] ADD  DEFAULT ((0)) FOR [Success]
GO
ALTER TABLE [dbo].[RefreshTokens] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[RefreshTokens] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RefreshTokens] ADD  DEFAULT ((0)) FOR [IsRevoked]
GO
ALTER TABLE [dbo].[ReportResults] ADD  DEFAULT (getdate()) FOR [RecordedAt]
GO
ALTER TABLE [dbo].[Sessions] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Sessions] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Sessions] ADD  DEFAULT ((0)) FOR [IsRevoked]
GO
ALTER TABLE [dbo].[UserRoles] ADD  DEFAULT (getdate()) FOR [AssignedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ClinicalReports]  WITH CHECK ADD FOREIGN KEY([AssignedDoctorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ClinicalReports]  WITH CHECK ADD FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ClinicalReports]  WITH CHECK ADD FOREIGN KEY([LabTestId])
REFERENCES [dbo].[LabTests] ([Id])
GO
ALTER TABLE [dbo].[ClinicalReports]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LabTests]  WITH CHECK ADD FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportResults]  WITH CHECK ADD FOREIGN KEY([ReportId])
REFERENCES [dbo].[ClinicalReports] ([Id])
GO
ALTER TABLE [dbo].[Sessions]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
USE [master]
GO
ALTER DATABASE [medicalab] SET  READ_WRITE 
GO
