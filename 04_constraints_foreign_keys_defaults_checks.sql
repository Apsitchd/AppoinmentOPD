-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- ALTER TABLE statements for defaults, foreign keys, and CHECK constraints.
ALTER TABLE [dbo].[Appointment] ADD  CONSTRAINT [DF_Appointment_Status]  DEFAULT ('Pending') FOR [AppointmentStatus]

ALTER TABLE [dbo].[Appointment] ADD  CONSTRAINT [DF_Appointment_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[AuditLog] ADD  CONSTRAINT [DF__AuditLog__Change]  DEFAULT (sysdatetime()) FOR [ChangedAt]

ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_NoShowCount]  DEFAULT ((0)) FOR [NoShowCount]

ALTER TABLE [dbo].[PatientAccessLog] ADD  DEFAULT (sysdatetime()) FOR [AccessedAt]

ALTER TABLE [dbo].[PatientAllergy] ADD  CONSTRAINT [DF_PatientAllergy_RecordedAt]  DEFAULT (getdate()) FOR [RecordedAt]

ALTER TABLE [dbo].[Prescription] ADD  CONSTRAINT [DF_Prescription_Date]  DEFAULT (getdate()) FOR [PrescriptionDate]

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Department]

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Patient]

ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])

ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Department]

ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [FK_DoctorSchedule_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])

ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [FK_DoctorSchedule_Doctor]

ALTER TABLE [dbo].[PatientAllergy]  WITH CHECK ADD  CONSTRAINT [FK_PatientAllergy_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])

ALTER TABLE [dbo].[PatientAllergy] CHECK CONSTRAINT [FK_PatientAllergy_Patient]

ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])

ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Doctor]

ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Visit] FOREIGN KEY([VisitID])
REFERENCES [dbo].[Visit] ([VisitID])

ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Visit]

ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDetail_Drug] FOREIGN KEY([DrugID])
REFERENCES [dbo].[Drug] ([DrugID])

ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [FK_PrescriptionDetail_Drug]

ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDetail_Prescription] FOREIGN KEY([PrescriptionID])
REFERENCES [dbo].[Prescription] ([PrescriptionID])

ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [FK_PrescriptionDetail_Prescription]

ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Appointment] FOREIGN KEY([AppointmentID])
REFERENCES [dbo].[Appointment] ([AppointmentID])

ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Appointment]

ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])

ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Doctor]

ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [FK_Visit_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])

ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [FK_Visit_Patient]

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [CK_Appointment_Date] CHECK  (([AppointmentDate]>=CONVERT([date],getdate())))

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [CK_Appointment_Date]

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [CK_Appointment_Status] CHECK  (([AppointmentStatus]='NoShow' OR [AppointmentStatus]='Completed' OR [AppointmentStatus]='Cancelled' OR [AppointmentStatus]='Confirmed' OR [AppointmentStatus]='Pending'))

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [CK_Appointment_Status]

ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [CK_DoctorSchedule_Duration15] CHECK  ((datediff(minute,[StartTime],[EndTime])>(0) AND datediff(minute,[StartTime],[EndTime])%(15)=(0)))

ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [CK_DoctorSchedule_Duration15]

ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [CK_DoctorSchedule_Time] CHECK  (([EndTime]>[StartTime]))

ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [CK_DoctorSchedule_Time]

ALTER TABLE [dbo].[Drug]  WITH CHECK ADD  CONSTRAINT [CK_Drug_Price] CHECK  (([Price]>(0)))

ALTER TABLE [dbo].[Drug] CHECK CONSTRAINT [CK_Drug_Price]

ALTER TABLE [dbo].[Drug]  WITH CHECK ADD  CONSTRAINT [CK_Drug_StockQuantity] CHECK  (([StockQuantity]>=(0)))

ALTER TABLE [dbo].[Drug] CHECK CONSTRAINT [CK_Drug_StockQuantity]

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_DateOfBirth] CHECK  (([DateOfBirth]<=CONVERT([date],getdate())))

ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_DateOfBirth]

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_Gender] CHECK  (([Gender]='Other' OR [Gender]='Female' OR [Gender]='Male'))

ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_Gender]

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK_Patient_NoShowCount] CHECK  (([NoShowCount]>=(0)))

ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK_Patient_NoShowCount]

ALTER TABLE [dbo].[PrescriptionDetail]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionDetail_Quantity] CHECK  (([Quantity]>(0)))

ALTER TABLE [dbo].[PrescriptionDetail] CHECK CONSTRAINT [CK_PrescriptionDetail_Quantity]

ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [CK_Visit_Temperature] CHECK  (([Temperature]>=(30) AND [Temperature]<=(45)))

ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [CK_Visit_Temperature]

ALTER TABLE [dbo].[Visit]  WITH CHECK ADD  CONSTRAINT [CK_Visit_Weight] CHECK  (([Weight]>(0)))

ALTER TABLE [dbo].[Visit] CHECK CONSTRAINT [CK_Visit_Weight]
