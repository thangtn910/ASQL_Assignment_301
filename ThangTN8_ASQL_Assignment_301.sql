-- ASQL Assignment 301
-- Problem Descriptions: Login SQL Server and create database name EMS

USE master
GO
-- Check if Database EMS exists

IF EXISTS 
	(	SELECT name 
			FROM sys.databases 
				WHERE name = N'EMS'
	)

DROP DATABASE EMS
GO

CREATE DATABASE EMS
GO

USE EMS
GO

-- Create table Employee
CREATE TABLE	dbo.Employee (
	EmpNo		INT			NOT NULL,
	EmpName		NCHAR(30)	NOT NULL,
	BirthDay	DATETIME	NOT NULL,
	DeptNo		INT			NOT NULL,
	MgrNo		INT					,
	StartDate	DATETIME	NOT NULL,
	Salary		MONEY		NOT NULL,
	[Status]	INT			NOT NULL,
	Note		NCHAR(100),
	[Level]		INT			NOT NULL
)
GO

-- Add CONSTRAINT FOR Columns Of Employee
ALTER TABLE dbo.Employee
ADD CONSTRAINT PK_Emp PRIMARY KEY(EmpNo)
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT chk_Level
	CHECK (([Level]=(7) OR [Level]=(6) OR [Level]=(5) OR [Level]=(4) OR [Level]=(3) OR [Level]=(2) OR [Level]=(1)))
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT chk_Status
	CHECK (([Status]=(2) OR [Status]=(1) OR [Status]=(0)))
GO

ALTER TABLE dbo.Employee
ADD Email NCHAR(30)
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT chk_Email CHECK(Email IS NOT NULL)
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT chk_Email1 UNIQUE(Email)
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT DF_EmpNo DEFAULT 0 FOR EmpNo
GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT DF_Status DEFAULT 0 FOR Status
GO

-- Create table Skill
CREATE TABLE	dbo.Skill(
	SkillNo		INT			NOT NULL	IDENTITY(1,1),
	SkillName	NCHAR(30)   NOT NULL,
	Note		NCHAR(100) 
)
GO

ALTER TABLE	dbo.Skill
ADD CONSTRAINT PK_Skill PRIMARY KEY (SkillNo)

-- Create table Department
GO
CREATE TABLE	dbo.Department(
	DeptNo		INT			NOT NULL	IDENTITY(1,1) ,
	DeptName	NCHAR(30)	NOT NULL,
	Note		NCHAR(100) 
)

GO
ALTER TABLE dbo.Department
ADD CONSTRAINT PK_Dept PRIMARY KEY (DeptNo)

-- Create table Emp_Skill
GO
CREATE TABLE dbo.Emp_Skill(
	SkillNo			INT			NOT NULL,
	EmpNo			INT			NOT NULL,	
	SkillLevel		INT			NOT NULL,	
	RegDate			DATETIME	NOT NULL,	
	[Description]	NCHAR(100) 
)

GO
ALTER TABLE dbo.Emp_Skill
ADD CONSTRAINT PK_Emp_Skill PRIMARY KEY (SkillNo, EmpNo)

GO
ALTER TABLE dbo.Employee  
ADD  CONSTRAINT FK_1 FOREIGN KEY(DeptNo)
REFERENCES dbo.Department (DeptNo)

GO
ALTER TABLE dbo.Employee  
ADD  CONSTRAINT FK_Manager FOREIGN KEY(MgrNo)
REFERENCES dbo.Employee(EmpNo)

GO
ALTER TABLE dbo.Emp_Skill
ADD CONSTRAINT FK_2 FOREIGN KEY (EmpNo)
REFERENCES Employee(EmpNo)

GO
ALTER TABLE dbo.Emp_Skill
ADD CONSTRAINT FK_3 FOREIGN KEY (SkillNo)
REFERENCES Skill(SkillNo)

--1. Add at least 8 records into each created tables.
GO
INSERT INTO dbo.Department(DeptName,Note)
	VALUES	('R&D','Phong R&D'),
			('SX','Phong SX'),
			('Product','Phong Product'),
			('Sale','Phong Sale'),
			('BV','Phong BV'),
			('GYM','Phong GYM'),
			('Meeting','Phong Meeting'),
			('Lunch','Phong Lunch');

GO
INSERT INTO	dbo.Employee 
	VALUES		(1,'Thang','1998/01/02',2,NULL,'2021/06/08',9000,1,'VN',7,'thang@gmail.com'),
				(2,'Dieu','1998/01/23',1,1,'2021/06/08',6000,1,'US',5,'dieu@gmail.com'),
				(3,'Tu','1998/09/04',1,1,'2021/06/08',5000,0,'UK',3,'tu@gmail.com'),
				(4,'Duc','1998/12/25',3,1,'2021/06/08',8000,1,'RS',6,'duc@gmail.com'),
				(5,'Viet','1998/01/31',4,4,'2021/06/08',6000,1,'VNA',3,'viet@gmail.com'),
				(6,'Thien','1998/11/08',2,2,'2021/06/08',5000,2,'VNL',4,'thien@gmail.com'),
				(7,'Cuong','1998/12/09',5,2,'2021/06/08',7000,2,'CH',5,'cuong@gmail.com'),
				(8,'Nam','1998/06/12',2,3,'2021/06/08',2000,1,'MU',2,'nam@gmail.com');

GO
INSERT INTO SKILL
	VALUES		('C','BASIC'),
				('C++','ADVANCE'),
				('JAVA','ADVANCE'),
				('PYTHON','BASIC'),
				('GOLANG','BASIC'),
				('LOL','MASTER'),
				('.NET','BASIC'),
				('C#','ADVANCE');

GO
INSERT INTO Emp_Skill
VALUES
	(5,4,2,'2021/12/12','LDM'),
	(2,1,3,'2021/12/12','GK'),
	(3,1,3,'2021/12/12','CDM'),
	(4,1,3,'2021/12/12','ST'),
	(1,5,1,'2021/12/12','RM'),
	(8,8,3,'2021/12/12','LB'),
	(7,2,1,'2021/12/12','LCB'),
	(8,6,2,'2021/12/12','RCB'),
	(3,7,2,'2021/12/12','CM'),
	(2,4,2,'2021/12/12','CO'),
	(2,8,2,'2021/12/12','CMC');

--2. Specify the name, email and department name of the employees that have been working at least six months.

SELECT e.EmpName, e.Email, d.DeptName
FROM     dbo.Employee AS e INNER JOIN
                  dbo.Department AS d ON e.DeptNo = d.DeptNo
WHERE  (DATEDIFF(MONTH, e.StartDate, GETDATE()) > 6)

--3. Specify the names of the employees whore have either ‘C++’ or ‘.NET’ skills.

SELECT e.EmpName
FROM     dbo.Employee AS e INNER JOIN
                  dbo.Emp_Skill AS es ON e.EmpNo = es.EmpNo INNER JOIN
                  dbo.Skill AS s ON es.SkillNo = s.SkillNo
WHERE  (s.SkillName = N'C++') OR
                  (s.SkillName = N'.NET')

--4. List all employee names, manager names, manager emails of those employees.

SELECT e1.EmpName, e2.EmpName AS Expr1, e2.Email
FROM     dbo.Employee AS e1 INNER JOIN
                  dbo.Employee AS e2 ON e1.MgrNo = e2.EmpNo

--5. Specify the departments which have >=2 employees, print out the list of departments’ employees right after each department.
	
SELECT d.DeptName, e.EmpName
FROM     dbo.Department AS d INNER JOIN
                  dbo.Employee AS e ON d.DeptNo = e.DeptNo
WHERE  (d.DeptNo IN
                      (SELECT DeptNo
                       FROM      dbo.Employee
                       GROUP BY DeptNo
                       HAVING  (COUNT(EmpNo) >= 2)))
ORDER BY d.DeptName

--6. List all name, email and number of skills of the employees and sort ascending order by employee’s name.

GO
CREATE VIEW dbo.Total_Skill AS
	SELECT		EmpNo,	COUNT(SkillNo) AS TotalSkill
	FROM		dbo.Emp_Skill
	GROUP BY	EmpName

GO
SELECT DISTINCT e.EmpNo, e.EmpName, e.Email, ISNULL(t.TotalSkill,0) TotalSkill
FROM     dbo.Employee AS e LEFT JOIN
                  dbo.Emp_Skill AS es ON e.EmpNo = es.EmpNo FULL JOIN
                  dbo.Total_Skill AS t ON t.EmpNo = es.EmpNo
ORDER BY EmpName

--7. Use SUB-QUERY technique to list out the different employees (include name, email, birthday) who are working and have multiple skills.

GO
SELECT DISTINCT e.EmpName, e.Email, e.BirthDay
FROM     dbo.Employee AS e INNER JOIN
                  dbo.Emp_Skill AS es ON e.EmpNo = es.EmpNo
WHERE  (e.Status = 1) AND (es.EmpNo IN
                      (SELECT EmpNo
                       FROM      dbo.Emp_Skill
                       GROUP BY EmpNo
                       HAVING  (COUNT(SkillNo) >= 2)))

--8. Create a view to list all employees are working (include: name of employee and skill name, department name).
GO
CREATE VIEW dbo.List_Employee AS
	SELECT		e.EmpName,	s.SkillName, d.DeptName
	FROM		dbo.Skill s
	INNER JOIN  dbo.Emp_Skill es ON s.SkillNo = es.SkillNo
	INNER JOIN	dbo.Employee e	ON es.EmpNo = e.EmpNo
	INNER JOIN	dbo.Department d ON e.DeptNo = d.DeptNo
	WHERE e.Status = 1

GO
SELECT * FROM dbo.List_Employee

