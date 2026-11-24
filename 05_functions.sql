-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- 3 functions found in source, including one table-valued function.
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
