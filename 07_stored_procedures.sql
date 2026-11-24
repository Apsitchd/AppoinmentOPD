-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- 8 stored procedures found in source.
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
