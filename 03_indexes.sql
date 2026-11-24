-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- Unique indexes found in source.
/****** Object:  Index [UX_Appointment_Doctor_Date_Time]    Script Date: 25/11/2569 4:14:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Appointment_Doctor_Date_Time] ON [dbo].[Appointment]
(
	[DoctorID] ASC,
	[AppointmentDate] ASC,
	[AppointmentTime] ASC
)
WHERE ([AppointmentStatus] IN ('Pending', 'Confirmed'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

/****** Object:  Index [UX_Appointment_Patient_Department_Date]    Script Date: 25/11/2569 4:14:38 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Appointment_Patient_Department_Date] ON [dbo].[Appointment]
(
	[PatientID] ASC,
	[DepartmentID] ASC,
	[AppointmentDate] ASC
)
WHERE ([AppointmentStatus] IN ('Pending', 'Confirmed'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
