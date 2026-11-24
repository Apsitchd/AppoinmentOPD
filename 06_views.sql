-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- 5 views found in source.
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
