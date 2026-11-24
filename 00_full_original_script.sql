USE [master]
GO
/****** Object:  Database [AppointmentOPD]    Script Date: 25/11/2569 4:14:37 ******/
CREATE DATABASE [AppointmentOPD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AppointmentOPD', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS2025\MSSQL\DATA\AppointmentOPD.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AppointmentOPD_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS2025\MSSQL\DATA\AppointmentOPD_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AppointmentOPD] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AppointmentOPD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AppointmentOPD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ARITHABORT OFF 
GO
ALTER DATABASE [AppointmentOPD] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AppointmentOPD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AppointmentOPD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AppointmentOPD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AppointmentOPD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AppointmentOPD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AppointmentOPD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AppointmentOPD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AppointmentOPD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AppointmentOPD] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AppointmentOPD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AppointmentOPD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AppointmentOPD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AppointmentOPD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AppointmentOPD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AppointmentOPD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AppointmentOPD] SET RECOVERY FULL 
GO
ALTER DATABASE [AppointmentOPD] SET  MULTI_USER 
GO
ALTER DATABASE [AppointmentOPD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AppointmentOPD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AppointmentOPD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AppointmentOPD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AppointmentOPD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AppointmentOPD] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [AppointmentOPD] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AppointmentOPD] SET QUERY_STORE = ON
GO
ALTER DATABASE [AppointmentOPD] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AppointmentOPD]
GO
/****** Object:  User [usr_Registration]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Registration] FOR LOGIN [usr_Registration] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [usr_Pharmacy]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Pharmacy] FOR LOGIN [usr_Pharmacy] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [usr_Finance]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Finance] FOR LOGIN [usr_Finance] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [usr_Doctor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Doctor] FOR LOGIN [usr_Doctor] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [usr_Auditor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Auditor] FOR LOGIN [usr_Auditor] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Role_Registration]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Registration]
GO
/****** Object:  DatabaseRole [Role_Pharmacy]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Pharmacy]
GO
/****** Object:  DatabaseRole [Role_Finance]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Finance]
GO
/****** Object:  DatabaseRole [Role_Doctor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Doctor]
GO
/****** Object:  DatabaseRole [Role_Auditor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Auditor]
GO
ALTER ROLE [Role_Registration] ADD MEMBER [usr_Registration]
GO
ALTER ROLE [Role_Pharmacy] ADD MEMBER [usr_Pharmacy]
GO
ALTER ROLE [Role_Finance] ADD MEMBER [usr_Finance]
GO
ALTER ROLE [Role_Doctor] ADD MEMBER [usr_Doctor]
GO
ALTER ROLE [Role_Auditor] ADD MEMBER [usr_Auditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CalculateAge]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_CalculateAge]
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN
    IF @DateOfBirth IS NULL
        RETURN NULL;

    DECLARE @Age INT;

    SET @Age =
        DATEDIFF(YEAR, @DateOfBirth, GETDATE())
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, @DateOfBirth, GETDATE()),
                @DateOfBirth
            ) > CONVERT(DATE, GETDATE())
            THEN 1
            ELSE 0
        END;

    RETURN @Age;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPrescriptionTotal]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetPrescriptionTotal]
(
    @PrescriptionID INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Total DECIMAL(12,2);

    SELECT
        @Total = SUM(
            CAST(pd.Quantity AS DECIMAL(12,2))
            * d.Price
        )
    FROM dbo.PrescriptionDetail pd
    INNER JOIN dbo.Drug d
        ON pd.DrugID = d.DrugID
    WHERE pd.PrescriptionID = @PrescriptionID;

    RETURN ISNULL(@Total, 0);
END;

GO
/****** Object:  Table [dbo].[Department]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK__DepartmentID] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_DepartmentName] UNIQUE NONCLUSTERED 
(
	[DepartmentName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[DoctorID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorName] [nvarchar](150) NOT NULL,
	[Specialty] [nvarchar](100) NOT NULL,
	[Phone] [varchar](15) NULL,
	[DepartmentID] [int] NOT NULL,
 CONSTRAINT [PK__DoctorID] PRIMARY KEY CLUSTERED 
(
	[DoctorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[HN] [varchar](20) NOT NULL,
	[CitizenID] [varchar](20) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXXXX", 4)') NOT NULL,
	[PatientName] [nvarchar](150) NOT NULL,
	[Gender] [nvarchar](20) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Phone] [varchar](15) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXX", 4)') NULL,
	[Address] [nvarchar](255) MASKED WITH (FUNCTION = 'default()') NULL,
	[NoShowCount] [int] NOT NULL,
	[OnlineBookingBlockedUntil] [datetime2](0) NULL,
 CONSTRAINT [PK__PatientID] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CitizenID] UNIQUE NONCLUSTERED 
(
	[CitizenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_HN] UNIQUE NONCLUSTERED 
(
	[HN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointment](
	[AppointmentID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[DoctorID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[AppointmentDate] [date] NOT NULL,
	[AppointmentTime] [time](7) NOT NULL,
	[AppointmentStatus] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK__AppointmentID] PRIMARY KEY CLUSTERED 
(
	[AppointmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetDoctorAppointments]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetDoctorAppointments]
(
    @DoctorID INT,
    @AppointmentDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        a.AppointmentID,
        a.AppointmentDate,
        a.AppointmentTime,
        a.AppointmentStatus,

        p.PatientID,
        p.HN,
        p.PatientName,

        d.DoctorID,
        d.DoctorName,

        dep.DepartmentName

    FROM dbo.Appointment a

    INNER JOIN dbo.Patient p
        ON a.PatientID = p.PatientID

    INNER JOIN dbo.Doctor d
        ON a.DoctorID = d.DoctorID

    INNER JOIN dbo.Department dep
        ON a.DepartmentID = dep.DepartmentID

    WHERE a.DoctorID = @DoctorID
      AND a.AppointmentDate = @AppointmentDate
);

GO
/****** Object:  View [dbo].[vw_DailyAppointmentReport]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_DailyAppointmentReport]
AS
SELECT
    a.AppointmentID,
    a.AppointmentDate,
    a.AppointmentTime,
    a.AppointmentStatus,

    p.HN,
    p.PatientName,

    d.DoctorName,
    d.Specialty,

    dep.DepartmentName

FROM dbo.Appointment a

INNER JOIN dbo.Patient p
    ON a.PatientID = p.PatientID

INNER JOIN dbo.Doctor d
    ON a.DoctorID = d.DoctorID

INNER JOIN dbo.Department dep
    ON a.DepartmentID = dep.DepartmentID;

GO
/****** Object:  Table [dbo].[Visit]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Visit](
	[VisitID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[DoctorID] [int] NOT NULL,
	[AppointmentID] [int] NULL,
	[VisitDate] [datetime] NOT NULL,
	[Weight] [decimal](5, 2) NOT NULL,
	[BloodPressure] [nvarchar](20) NOT NULL,
	[Temperature] [decimal](4, 1) NOT NULL,
	[Symptoms] [nvarchar](500) NOT NULL,
	[Diagnosis] [nvarchar](500) NOT NULL,
	[ICD10Code] [varchar](10) NULL,
 CONSTRAINT [PK__VisitID] PRIMARY KEY CLUSTERED 
(
	[VisitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_DepartmentVisitSummary]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_DepartmentVisitSummary]
AS
SELECT
    dep.DepartmentID,
    dep.DepartmentName,

    COUNT(DISTINCT v.PatientID)
        AS TotalPatients,

    COUNT(v.VisitID)
        AS TotalVisits

FROM dbo.Department dep

LEFT JOIN dbo.Doctor d
    ON dep.DepartmentID = d.DepartmentID

LEFT JOIN dbo.Visit v
    ON d.DoctorID = v.DoctorID

GROUP BY
    dep.DepartmentID,
    dep.DepartmentName;

GO
/****** Object:  View [dbo].[vw_PatientSafeInfo]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_PatientSafeInfo]
AS
SELECT
    PatientID,
    HN,
    PatientName,
    Gender,
    DateOfBirth,

    CASE
        WHEN Phone IS NULL THEN NULL
        ELSE
            CONCAT(
                REPLICATE('*',
                    CASE
                        WHEN LEN(Phone) > 4
                        THEN LEN(Phone) - 4
                        ELSE 0
                    END
                ),
                RIGHT(Phone, 4)
            )
    END AS MaskedPhone,

    NoShowCount

FROM dbo.Patient;

GO
/****** Object:  Table [dbo].[Drug]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drug](
	[DrugID] [int] IDENTITY(1,1) NOT NULL,
	[DrugName] [nvarchar](150) NOT NULL,
	[DrugDescription] [nvarchar](255) NULL,
	[Unit] [nvarchar](50) NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[ExpiryDate] [date] NOT NULL,
 CONSTRAINT [PK__DrugID] PRIMARY KEY CLUSTERED 
(
	[DrugID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[PrescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[VisitID] [int] NOT NULL,
	[DoctorID] [int] NOT NULL,
	[PrescriptionDate] [datetime] NOT NULL,
 CONSTRAINT [PK__PrescriptionID] PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrescriptionDetail]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrescriptionDetail](
	[PrescriptionDetailID] [int] IDENTITY(1,1) NOT NULL,
	[PrescriptionID] [int] NOT NULL,
	[DrugID] [int] NOT NULL,
	[Dosage] [nvarchar](100) NOT NULL,
	[Frequency] [nvarchar](100) NOT NULL,
	[Duration] [nvarchar](100) NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK__PrescriptionDetailID] PRIMARY KEY CLUSTERED 
(
	[PrescriptionDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_FinancePrescriptionSummary]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_FinancePrescriptionSummary]
AS
SELECT
    p.PrescriptionID,
    p.PrescriptionDate,
    COUNT(pd.PrescriptionDetailID) AS TotalDrugItems,
    SUM(pd.Quantity) AS TotalQuantity,
    SUM(pd.Quantity * d.Price) AS TotalAmount
FROM dbo.Prescription p
INNER JOIN dbo.PrescriptionDetail pd
    ON p.PrescriptionID = pd.PrescriptionID
INNER JOIN dbo.Drug d
    ON pd.DrugID = d.DrugID
GROUP BY
    p.PrescriptionID,
    p.PrescriptionDate;

GO
/****** Object:  View [dbo].[vw_PharmacyPrescriptionQueue]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_PharmacyPrescriptionQueue]
AS
SELECT
    p.PrescriptionID,
    p.PrescriptionDate,
    pd.PrescriptionDetailID,
    d.DrugID,
    d.DrugName,
    d.Unit,
    pd.Dosage,
    pd.Frequency,
    pd.Duration,
    pd.Quantity,
    d.StockQuantity,
    d.ExpiryDate
FROM dbo.Prescription p
INNER JOIN dbo.PrescriptionDetail pd
    ON p.PrescriptionID = pd.PrescriptionID
INNER JOIN dbo.Drug d
    ON pd.DrugID = d.DrugID;

GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[RecordID] [int] NOT NULL,
	[ActionType] [nvarchar](20) NOT NULL,
	[ChangedBy] [nvarchar](128) NOT NULL,
	[ChangedAt] [datetime2](0) NOT NULL,
	[OldData] [nvarchar](max) NULL,
	[NewData] [nvarchar](max) NULL,
 CONSTRAINT [PK__AuditID] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DoctorSchedule]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorID] [int] NOT NULL,
	[WorkDate] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
 CONSTRAINT [PK__ScheduleID] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_DoctorSchedule] UNIQUE NONCLUSTERED 
(
	[DoctorID] ASC,
	[WorkDate] ASC,
	[StartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientAccessLog]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientAccessLog](
	[AccessID] [bigint] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[AccessedBy] [nvarchar](128) NOT NULL,
	[AccessedAt] [datetime2](0) NOT NULL,
	[AccessType] [nvarchar](50) NOT NULL,
	[AccessStatus] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientAllergy]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientAllergy](
	[AllergyID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[AllergyName] [nvarchar](150) NOT NULL,
	[Reaction] [nvarchar](255) NOT NULL,
	[RecordedAt] [datetime] NOT NULL,
 CONSTRAINT [PK__AllergyID] PRIMARY KEY CLUSTERED 
(
	[AllergyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_PatientAllergy] UNIQUE NONCLUSTERED 
(
	[PatientID] ASC,
	[AllergyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [UX_Appointment_Doctor_Date_Time]    Script Date: 25/11/2569 4:14:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Appointment_Doctor_Date_Time] ON [dbo].[Appointment]
(
	[DoctorID] ASC,
	[AppointmentDate] ASC,
	[AppointmentTime] ASC
)
WHERE ([AppointmentStatus] IN ('Pending', 'Confirmed'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_Appointment_Patient_Department_Date]    Script Date: 25/11/2569 4:14:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Appointment_Patient_Department_Date] ON [dbo].[Appointment]
(
	[PatientID] ASC,
	[DepartmentID] ASC,
	[AppointmentDate] ASC
)
WHERE ([AppointmentStatus] IN ('Pending', 'Confirmed'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Appointment] ADD  CONSTRAINT [DF_Appointment_Status]  DEFAULT ('Pending') FOR [AppointmentStatus]
GO
ALTER TABLE [dbo].[Appointment] ADD  CONSTRAINT [DF_Appointment_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AuditLog] ADD  CONSTRAINT [DF__AuditLog__Change]  DEFAULT (sysdatetime()) FOR [ChangedAt]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_NoShowCount]  DEFAULT ((0)) FOR [NoShowCount]
GO
ALTER TABLE [dbo].[PatientAccessLog] ADD  DEFAULT (sysdatetime()) FOR [AccessedAt]
GO
ALTER TABLE [dbo].[PatientAllergy] ADD  CONSTRAINT [DF_PatientAllergy_RecordedAt]  DEFAULT (getdate()) FOR [RecordedAt]
GO
ALTER TABLE [dbo].[Prescription] ADD  CONSTRAINT [DF_Prescription_Date]  DEFAULT (getdate()) FOR [PrescriptionDate]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Department]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Patient]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Department]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [FK_DoctorSchedule_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [FK_DoctorSchedule_Doctor]
GO
ALTER TABLE [dbo].[PatientAllergy]  WITH CHECK ADD  CONSTRAINT [FK_PatientAllergy_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[PatientAllergy] CHECK CONSTRAINT [FK_PatientAllergy_Patient]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Doctor]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Visit] FOREIGN KEY([VisitID])
REFERENCES [dbo].[Visit] ([VisitID])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Visit]
GO
ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDetail_Drug] FOREIGN KEY([DrugID])
REFERENCES [dbo].[Drug] ([DrugID])
GO
ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [FK_PrescriptionDetail_Drug]
GO
ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDetail_Prescription] FOREIGN KEY([PrescriptionID])
REFERENCES [dbo].[Prescription] ([PrescriptionID])
GO
ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [FK_PrescriptionDetail_Prescription]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Appointment] FOREIGN KEY([AppointmentID])
REFERENCES [dbo].[Appointment] ([AppointmentID])
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Appointment]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Doctor]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Patient]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [CK_Appointment_Date] CHECK  (([AppointmentDate]>=CONVERT([date],getdate())))
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [CK_Appointment_Date]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [CK_Appointment_Status] CHECK  (([AppointmentStatus]='NoShow' OR [AppointmentStatus]='Completed' OR [AppointmentStatus]='Cancelled' OR [AppointmentStatus]='Confirmed' OR [AppointmentStatus]='Pending'))
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [CK_Appointment_Status]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [CK_DoctorSchedule_Duration15] CHECK  ((datediff(minute,[StartTime],[EndTime])>(0) AND datediff(minute,[StartTime],[EndTime])%(15)=(0)))
GO
ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [CK_DoctorSchedule_Duration15]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [CK_DoctorSchedule_Time] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [CK_DoctorSchedule_Time]
GO
ALTER TABLE [dbo].[Drug]  WITH CHECK ADD  CONSTRAINT [CK_Drug_Price] CHECK  (([Price]>(0)))
GO
ALTER TABLE [dbo].[Drug] CHECK CONSTRAINT [CK_Drug_Price]
GO
ALTER TABLE [dbo].[Drug]  WITH CHECK ADD  CONSTRAINT [CK_Drug_StockQuantity] CHECK  (([StockQuantity]>=(0)))
GO
ALTER TABLE [dbo].[Drug] CHECK CONSTRAINT [CK_Drug_StockQuantity]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_DateOfBirth] CHECK  (([DateOfBirth]<=CONVERT([date],getdate())))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_DateOfBirth]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_Gender] CHECK  (([Gender]='Other' OR [Gender]='Female' OR [Gender]='Male'))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_Gender]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_NoShowCount] CHECK  (([NoShowCount]>=(0)))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_NoShowCount]
GO
ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionDetail_Quantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [CK_PrescriptionDetail_Quantity]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [CK_Visit_Temperature] CHECK  (([Temperature]>=(30) AND [Temperature]<=(45)))
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [CK_Visit_Temperature]
GO
ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [CK_Visit_Weight] CHECK  (([Weight]>(0)))
GO
ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [CK_Visit_Weight]
GO
/****** Object:  StoredProcedure [dbo].[sp_AddPrescriptionDetail]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- 2. STORED PROCEDURE เพิ่มรายการยาในใบสั่งยา
--    Trigger จะตรวจสอบแพ้ยา หมดอายุ และตัดสต็อกให้เอง

CREATE   PROCEDURE [dbo].[sp_AddPrescriptionDetail]
    @PrescriptionID INT,
    @DrugID INT,
    @Dosage NVARCHAR(100),
    @Frequency NVARCHAR(100),
    @Duration NVARCHAR(100),
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- ตรวจสอบใบสั่งยา
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Prescription
            WHERE PrescriptionID = @PrescriptionID
        )
        BEGIN
            THROW 50404, N'ไม่พบใบสั่งยาที่ระบุ', 1;
        END;

        -- ตรวจสอบข้อมูลยา
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Drug
            WHERE DrugID = @DrugID
        )
        BEGIN
            THROW 50405, N'ไม่พบข้อมูลยา', 1;
        END;

        -- ตรวจสอบจำนวนยา
        IF @Quantity IS NULL OR @Quantity <= 0
        BEGIN
            THROW 50406, N'จำนวนยาต้องมากกว่า 0', 1;
        END;

        -- ตรวจสอบข้อมูลวิธีใช้ยา
        IF NULLIF(LTRIM(RTRIM(@Dosage)), '') IS NULL
           OR NULLIF(LTRIM(RTRIM(@Frequency)), '') IS NULL
           OR NULLIF(LTRIM(RTRIM(@Duration)), '') IS NULL
        BEGIN
            THROW 50407, N'กรุณาระบุวิธีใช้ยา ความถี่ และระยะเวลาให้ครบ', 1;
        END;

        -- เพิ่มรายการยา
        -- Trigger จะตรวจสอบและตัดสต็อกโดยอัตโนมัติ
        INSERT INTO dbo.PrescriptionDetail
        (
            PrescriptionID,
            DrugID,
            Dosage,
            Frequency,
            Duration,
            Quantity
        )
        VALUES
        (
            @PrescriptionID,
            @DrugID,
            @Dosage,
            @Frequency,
            @Duration,
            @Quantity
        );

        DECLARE @NewDetailID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @NewDetailID AS PrescriptionDetailID,
            N'เพิ่มรายการยาและตัดสต็อกสำเร็จ' AS Result;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_BookAppointment]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4. ปรับปรุง Stored Procedure สำหรับจองนัดหมาย
CREATE   PROCEDURE [dbo].[sp_BookAppointment]
    @PatientID INT,
    @DoctorID INT,
    @DepartmentID INT,
    @AppointmentDate DATE,
    @AppointmentTime TIME(7),
    @BookingChannel VARCHAR(10) = 'Online'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- ตรวจสอบช่องทางการจอง
        IF @BookingChannel NOT IN ('Online', 'Staff')
            THROW 50100, N'ช่องทางการจองไม่ถูกต้อง', 1;

        -- ตรวจสอบผู้ป่วย
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Patient WITH (UPDLOCK, HOLDLOCK)
            WHERE PatientID = @PatientID
        )
            THROW 50101, N'ไม่พบข้อมูลผู้ป่วย', 1;

        -- ตรวจสอบการระงับจองออนไลน์
        IF @BookingChannel = 'Online'
           AND EXISTS (
               SELECT 1
               FROM dbo.Patient
               WHERE PatientID = @PatientID
                 AND OnlineBookingBlockedUntil > GETDATE()
           )
            THROW 50108, N'บัญชีถูกระงับการจองออนไลน์ชั่วคราว', 1;

        -- ตรวจสอบแพทย์และแผนก
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Doctor
            WHERE DoctorID = @DoctorID
              AND DepartmentID = @DepartmentID
        )
            THROW 50102, N'ไม่พบแพทย์ในแผนกที่เลือก', 1;

        -- ห้ามจองย้อนหลัง
        IF @AppointmentDate < CONVERT(DATE, GETDATE())
            THROW 50103, N'ไม่สามารถจองวันย้อนหลังได้', 1;

        -- ห้ามจองเวลาที่ผ่านไปแล้ว
        IF @AppointmentDate = CONVERT(DATE, GETDATE())
           AND @AppointmentTime <= CONVERT(TIME(7), GETDATE())
            THROW 50104, N'เวลานัดหมายต้องเป็นเวลาในอนาคต', 1;

        -- ตรวจสอบตารางออกตรวจและ Slot 15 นาที
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.DoctorSchedule WITH (UPDLOCK, HOLDLOCK)
            WHERE DoctorID = @DoctorID
              AND WorkDate = @AppointmentDate
              AND @AppointmentTime >= StartTime
              AND DATEADD(
                    MINUTE, 15,
                    CAST(@AppointmentTime AS DATETIME)
                  ) <= CAST(EndTime AS DATETIME)
              AND DATEDIFF(
                    MINUTE, StartTime, @AppointmentTime
                  ) % 15 = 0
              AND DATEPART(SECOND, @AppointmentTime) = 0
        )
            THROW 50105, N'แพทย์ไม่ได้ออกตรวจในเวลาที่เลือก หรือเวลาไม่ตรง Slot 15 นาที', 1;

        -- ผู้ป่วยมีนัดในแผนกเดียวกันได้วันละ 1 คิว
        IF EXISTS (
            SELECT 1
            FROM dbo.Appointment WITH (UPDLOCK, HOLDLOCK)
            WHERE PatientID = @PatientID
              AND DepartmentID = @DepartmentID
              AND AppointmentDate = @AppointmentDate
              AND AppointmentStatus IN ('Pending', 'Confirmed')
        )
            THROW 50106, N'ผู้ป่วยมีนัดในแผนกนี้แล้วในวันนี้', 1;

        -- แพทย์ห้ามมีนัดซ้อนเวลา
        IF EXISTS (
            SELECT 1
            FROM dbo.Appointment WITH (UPDLOCK, HOLDLOCK)
            WHERE DoctorID = @DoctorID
              AND AppointmentDate = @AppointmentDate
              AND AppointmentTime = @AppointmentTime
              AND AppointmentStatus IN ('Pending', 'Confirmed')
        )
            THROW 50107, N'แพทย์มีนัดในช่วงเวลานี้แล้ว', 1;

        -- บันทึกนัดหมาย
        INSERT INTO dbo.Appointment
        (
            PatientID,
            DoctorID,
            DepartmentID,
            AppointmentDate,
            AppointmentTime
        )
        VALUES
        (
            @PatientID,
            @DoctorID,
            @DepartmentID,
            @AppointmentDate,
            @AppointmentTime
        );

        DECLARE @NewAppointmentID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

        SELECT
            @NewAppointmentID AS AppointmentID,
            N'จองนัดหมายสำเร็จ' AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_CancelAppointment]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 5. สร้างระบบยกเลิกนัดหมาย
CREATE   PROCEDURE [dbo].[sp_CancelAppointment]
    @AppointmentID INT,
    @PatientID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AppointmentDate DATE;
    DECLARE @AppointmentTime TIME(7);
    DECLARE @Status NVARCHAR(30);
    DECLARE @AppointmentDateTime DATETIME;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT
            @AppointmentDate = AppointmentDate,
            @AppointmentTime = AppointmentTime,
            @Status = AppointmentStatus
        FROM dbo.Appointment WITH (UPDLOCK, HOLDLOCK)
        WHERE AppointmentID = @AppointmentID
          AND PatientID = @PatientID;

        IF @Status IS NULL
            THROW 50201, N'ไม่พบนัดหมายของผู้ป่วยรายนี้', 1;

        IF @Status NOT IN ('Pending', 'Confirmed')
            THROW 50202, N'นัดหมายนี้ไม่สามารถยกเลิกได้', 1;

        SET @AppointmentDateTime =
            DATEADD(
                DAY,
                DATEDIFF(DAY, 0, @AppointmentDate),
                CAST(@AppointmentTime AS DATETIME)
            );

        IF DATEDIFF(MINUTE, GETDATE(), @AppointmentDateTime) < 120
            THROW 50203, N'ต้องยกเลิกนัดหมายล่วงหน้าอย่างน้อย 2 ชั่วโมง', 1;

        UPDATE dbo.Appointment
        SET AppointmentStatus = 'Cancelled'
        WHERE AppointmentID = @AppointmentID;

        COMMIT TRANSACTION;

        SELECT N'ยกเลิกนัดหมายสำเร็จ' AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_CreateVisit]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ==========================================
   PROCEDURE 3: บันทึกการตรวจผู้ป่วย
   สร้าง Visit และ Prescription
   รองรับผู้ป่วย Walk-in
   ========================================== */

CREATE   PROCEDURE [dbo].[sp_CreateVisit]
    @PatientID INT,
    @DoctorID INT,
    @AppointmentID INT = NULL,
    @Weight DECIMAL(5,2),
    @BloodPressure NVARCHAR(20),
    @Temperature DECIMAL(4,1),
    @Symptoms NVARCHAR(500),
    @Diagnosis NVARCHAR(500),
    @ICD10Code VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- ตรวจสอบผู้ป่วย
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Patient
            WHERE PatientID = @PatientID
        )
        BEGIN
            THROW 50201, N'ไม่พบข้อมูลผู้ป่วย', 1;
        END;

        -- ตรวจสอบแพทย์
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Doctor
            WHERE DoctorID = @DoctorID
        )
        BEGIN
            THROW 50202, N'ไม่พบข้อมูลแพทย์', 1;
        END;

        -- ตรวจสอบข้อมูลการตรวจ
        IF @Weight <= 0
        BEGIN
            THROW 50203, N'น้ำหนักต้องมากกว่า 0', 1;
        END;

        IF @Temperature < 30 OR @Temperature > 45
        BEGIN
            THROW 50204, N'อุณหภูมิต้องอยู่ระหว่าง 30 ถึง 45 องศา', 1;
        END;

        -- ถ้ามีนัด ต้องตรวจสอบว่านัดถูกต้องและยังไม่เคยตรวจ
        IF @AppointmentID IS NOT NULL
        BEGIN
            IF NOT EXISTS (
                SELECT 1
                FROM dbo.Appointment WITH (UPDLOCK, HOLDLOCK)
                WHERE AppointmentID = @AppointmentID
                  AND PatientID = @PatientID
                  AND DoctorID = @DoctorID
                  AND AppointmentStatus IN ('Pending', 'Confirmed')
            )
            BEGIN
                THROW 50205, N'ข้อมูลนัดหมายไม่ถูกต้อง หรือไม่สามารถใช้ตรวจได้', 1;
            END;

            IF EXISTS (
                SELECT 1
                FROM dbo.Visit
                WHERE AppointmentID = @AppointmentID
            )
            BEGIN
                THROW 50206, N'นัดหมายนี้มีการตรวจแล้ว', 1;
            END;
        END;

        -- สร้าง Visit
        INSERT INTO dbo.Visit
        (
            PatientID,
            DoctorID,
            AppointmentID,
            VisitDate,
            Weight,
            BloodPressure,
            Temperature,
            Symptoms,
            Diagnosis,
            ICD10Code
        )
        VALUES
        (
            @PatientID,
            @DoctorID,
            @AppointmentID,
            GETDATE(),
            @Weight,
            @BloodPressure,
            @Temperature,
            @Symptoms,
            @Diagnosis,
            @ICD10Code
        );

        DECLARE @VisitID INT = SCOPE_IDENTITY();

        -- สร้างหัวใบสั่งยา
        INSERT INTO dbo.Prescription
        (
            VisitID,
            DoctorID,
            PrescriptionDate
        )
        VALUES
        (
            @VisitID,
            @DoctorID,
            GETDATE()
        );

        DECLARE @PrescriptionID INT = SCOPE_IDENTITY();

        -- เปลี่ยนสถานะนัดเป็น Completed
        IF @AppointmentID IS NOT NULL
        BEGIN
            UPDATE dbo.Appointment
            SET AppointmentStatus = 'Completed'
            WHERE AppointmentID = @AppointmentID;
        END;

        COMMIT TRANSACTION;

        SELECT
            @VisitID AS VisitID,
            @PrescriptionID AS PrescriptionID,
            N'บันทึกการตรวจและสร้างใบสั่งยาสำเร็จ' AS Result;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_MarkNoShow]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 6. สร้างระบบบันทึก NoShow
CREATE   PROCEDURE [dbo].[sp_MarkNoShow]
    @AppointmentID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PatientID INT;
    DECLARE @AppointmentDate DATE;
    DECLARE @AppointmentTime TIME(7);
    DECLARE @Status NVARCHAR(30);
    DECLARE @NoShowCount INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT
            @PatientID = PatientID,
            @AppointmentDate = AppointmentDate,
            @AppointmentTime = AppointmentTime,
            @Status = AppointmentStatus
        FROM dbo.Appointment WITH (UPDLOCK, HOLDLOCK)
        WHERE AppointmentID = @AppointmentID;

        IF @PatientID IS NULL
            THROW 50301, N'ไม่พบข้อมูลนัดหมาย', 1;

        IF @Status NOT IN ('Pending', 'Confirmed')
            THROW 50302, N'สถานะนัดหมายไม่สามารถเปลี่ยนเป็น NoShow ได้', 1;

        -- ต้องเลยเวลานัดหมายแล้ว
        IF DATEADD(
               DAY,
               DATEDIFF(DAY, 0, @AppointmentDate),
               CAST(@AppointmentTime AS DATETIME)
           ) > GETDATE()
            THROW 50303, N'ยังไม่ถึงเวลานัดหมาย', 1;

        UPDATE dbo.Appointment
        SET AppointmentStatus = 'NoShow'
        WHERE AppointmentID = @AppointmentID;

        UPDATE dbo.Patient
        SET NoShowCount = NoShowCount + 1
        WHERE PatientID = @PatientID;

        SELECT @NoShowCount = NoShowCount
        FROM dbo.Patient
        WHERE PatientID = @PatientID;

        -- ขาดนัดครบ 3 ครั้ง ระงับการจองออนไลน์ 30 วัน
        IF @NoShowCount >= 3
        BEGIN
            UPDATE dbo.Patient
            SET OnlineBookingBlockedUntil =
                DATEADD(DAY, 30, GETDATE())
            WHERE PatientID = @PatientID;
        END;

        COMMIT TRANSACTION;

        SELECT
            @NoShowCount AS TotalNoShow,
            CASE
                WHEN @NoShowCount >= 3
                    THEN N'ระงับการจองออนไลน์ 30 วัน'
                ELSE N'บันทึก NoShow สำเร็จ'
            END AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_RegisterPatient]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ==========================================
   PROCEDURE 1: ลงทะเบียนผู้ป่วย
   สร้าง HN อัตโนมัติ เช่น HN69-00001
   ========================================== */

CREATE   PROCEDURE [dbo].[sp_RegisterPatient]
    @CitizenID VARCHAR(20),
    @PatientName NVARCHAR(150),
    @Gender NVARCHAR(20),
    @DateOfBirth DATE,
    @Phone VARCHAR(15) = NULL,
    @Address NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- ตรวจสอบข้อมูลที่จำเป็น
        IF @CitizenID IS NULL
           OR LEN(@CitizenID) <> 13
           OR @CitizenID LIKE '%[^0-9]%'
        BEGIN
            THROW 50001, N'เลขบัตรประชาชนต้องเป็นตัวเลข 13 หลัก', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Patient
            WHERE CitizenID = @CitizenID
        )
        BEGIN
            THROW 50002, N'เลขบัตรประชาชนนี้มีในระบบแล้ว', 1;
        END;

        IF @DateOfBirth > CONVERT(DATE, GETDATE())
        BEGIN
            THROW 50003, N'วันเกิดไม่สามารถเป็นวันในอนาคตได้', 1;
        END;

        IF @Gender NOT IN (N'Male', N'Female', N'Other')
        BEGIN
            THROW 50004, N'Gender ไม่ถูกต้อง', 1;
        END;

        -- สร้าง HN ตามปี พ.ศ.
        DECLARE @YearCode VARCHAR(2);
        DECLARE @Prefix VARCHAR(10);
        DECLARE @NextNumber INT;
        DECLARE @HN VARCHAR(20);
        DECLARE @LockResult INT;
        DECLARE @LockResource NVARCHAR(255);

        SET @YearCode =
            RIGHT(CONVERT(VARCHAR(4), YEAR(GETDATE()) + 543), 2);

        SET @Prefix = 'HN' + @YearCode;
        SET @LockResource = 'Patient_HN_' + @YearCode;

        -- ป้องกันการสร้าง HN ซ้ำเมื่อมีผู้ใช้พร้อมกัน
        EXEC @LockResult = sys.sp_getapplock
            @Resource = @LockResource,
            @LockMode = 'Exclusive',
            @LockOwner = 'Transaction',
            @LockTimeout = 10000;

        IF @LockResult < 0
        BEGIN
            THROW 50005, N'ไม่สามารถสร้าง HN ได้ กรุณาลองใหม่', 1;
        END;

        SELECT @NextNumber =
            ISNULL(MAX(TRY_CONVERT(INT, RIGHT(HN, 5))), 0) + 1
        FROM dbo.Patient WITH (UPDLOCK, HOLDLOCK)
        WHERE HN LIKE @Prefix + '-%';

        SET @HN = @Prefix + '-' +
            RIGHT('00000' + CONVERT(VARCHAR(5), @NextNumber), 5);

        -- เพิ่มข้อมูลผู้ป่วย
        INSERT INTO dbo.Patient
        (
            HN,
            CitizenID,
            PatientName,
            Gender,
            DateOfBirth,
            Phone,
            Address
        )
        VALUES
        (
            @HN,
            @CitizenID,
            @PatientName,
            @Gender,
            @DateOfBirth,
            @Phone,
            @Address
        );

        DECLARE @PatientID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @PatientID AS PatientID,
            @HN AS HN,
            N'ลงทะเบียนผู้ป่วยสำเร็จ' AS Result;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_SearchPatientSafe]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SearchPatientSafe]
    @Keyword NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PatientID,
        HN,
        PatientName,
        Gender,
        DateOfBirth,
        MaskedPhone,
        NoShowCount
    FROM dbo.vw_PatientSafeInfo
    WHERE PatientName LIKE N'%' + @Keyword + N'%'
       OR HN LIKE '%' + @Keyword + '%';
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_ViewPatientSafeInfo]    Script Date: 25/11/2569 4:14:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Procedure for accessing patient information */

CREATE   PROCEDURE [dbo].[sp_ViewPatientSafeInfo]
    @PatientID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        INSERT INTO dbo.PatientAccessLog
        (
            PatientID,
            AccessedBy,
            AccessType,
            AccessStatus
        )
        VALUES
        (
            @PatientID,
            COALESCE(
                TRY_CONVERT(
                    NVARCHAR(128),
                    SESSION_CONTEXT(N'AppUser')
                ),
                ORIGINAL_LOGIN()
            ),
            N'VIEW_PATIENT',
            N'SUCCESS'
        );

        SELECT *
        FROM dbo.vw_PatientSafeInfo
        WHERE PatientID = @PatientID;

    END TRY
    BEGIN CATCH

        THROW;

    END CATCH
END;

GO
USE [master]
GO
ALTER DATABASE [AppointmentOPD] SET  READ_WRITE 
GO
