-- AppointmentOPD | SQL Server
-- Extracted from uploaded script.sql; source statements retained.
-- Creates database users, roles, and role membership. The source does not include CREATE LOGIN, GRANT, DENY, or REVOKE statements.
/****** Object:  User [usr_Registration]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Registration] FOR LOGIN [usr_Registration] WITH DEFAULT_SCHEMA=[dbo]

/****** Object:  User [usr_Pharmacy]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Pharmacy] FOR LOGIN [usr_Pharmacy] WITH DEFAULT_SCHEMA=[dbo]

/****** Object:  User [usr_Finance]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Finance] FOR LOGIN [usr_Finance] WITH DEFAULT_SCHEMA=[dbo]

/****** Object:  User [usr_Doctor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Doctor] FOR LOGIN [usr_Doctor] WITH DEFAULT_SCHEMA=[dbo]

/****** Object:  User [usr_Auditor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE USER [usr_Auditor] FOR LOGIN [usr_Auditor] WITH DEFAULT_SCHEMA=[dbo]

/****** Object:  DatabaseRole [Role_Registration]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Registration]

/****** Object:  DatabaseRole [Role_Pharmacy]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Pharmacy]

/****** Object:  DatabaseRole [Role_Finance]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Finance]

/****** Object:  DatabaseRole [Role_Doctor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Doctor]

/****** Object:  DatabaseRole [Role_Auditor]    Script Date: 25/11/2569 4:14:38 ******/
CREATE ROLE [Role_Auditor]

ALTER ROLE [Role_Registration] ADD MEMBER [usr_Registration]

ALTER ROLE [Role_Pharmacy] ADD MEMBER [usr_Pharmacy]

ALTER ROLE [Role_Finance] ADD MEMBER [usr_Finance]

ALTER ROLE [Role_Doctor] ADD MEMBER [usr_Doctor]

ALTER ROLE [Role_Auditor] ADD MEMBER [usr_Auditor]
