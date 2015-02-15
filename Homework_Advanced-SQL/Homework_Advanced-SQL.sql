-- Problem 1
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary = (SELECT MIN(Salary) FROM Employees)

-- Problem 2
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary <= (SELECT MIN(Salary) FROM Employees) * 1.10

-- Problem 3
SELECT FirstName + ' ' + LastName as FullName, Salary, d.Name as DepartmentsName
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE Salary = 
	(SELECT MIN(Salary) 
	FROM Employees em 
	WHERE em.DepartmentID = d.DepartmentID)

-- Problem 4
SELECT AVG(Salary) as [Average Salary in Department #1]
FROM Employees e 
WHERE e.DepartmentID = 1

-- Problem 5
SELECT AVG(Salary) as [Average Salary for Sales Department]
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

-- Problem 6
SELECT COUNT(*) as [Sales Employees Count]
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

-- Problem 7
SELECT COUNT(*) as [Employees with manager]
FROM Employees 
WHERE ManagerID IS NOT NULL

-- Problem 8
SELECT COUNT(*) as [Employees without manager]
FROM Employees 
WHERE ManagerID IS NULL

-- Problem 9
SELECT d.Name as Deparment, AVG(Salary) as [Average Salary]
FROM Departments d JOIN Employees e
	ON d.DepartmentID = e.DepartmentID
GROUP BY d.Name

-- Problem 10
SELECT t.Name as Town, d.Name as Department, COUNT(e.EmployeeID) as [Employees count]
FROM 
	Departments d JOIN Employees e
		ON d.DepartmentID = e.DepartmentID
	JOIN Addresses a
		ON e.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
GROUP BY t.Name, d.Name

-- Problem 11
SELECT m.FirstName, m.LastName, COUNT(e.EmployeeID)
FROM Employees e JOIN Employees m
	ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(e.EmployeeID) = 5

-- Problem 12
SELECT 
	e.FirstName + ' ' + e.LastName as [Full Name],
	ISNULL(m.FirstName + ' ' + m.LastName, 'No manager') as [Manager]
FROM Employees e LEFT JOIN Employees m
	ON e.ManagerID = m.EmployeeID

-- Problem 13
SELECT FirstName, LastName
FROM Employees e
WHERE LEN(e.LastName) = 5

-- Problem 14
SELECT CONVERT(NVARCHAR(MAX), GETDATE(), 104) + ' ' + CONVERT(NVARCHAR(MAX), GETDATE(), 114)

-- Problem 15
CREATE TABLE Users
(
Id int IDENTITY(1,1) PRIMARY KEY,
Username nvarchar(50) NOT NULL UNIQUE,
Password nvarchar(50) CHECK (LEN(Password) >=5),
FullName nvarchar(100),
LastLogin date 
)

GO

-- Problem 16
CREATE VIEW UsersLoginToday AS
SELECT *
FROM Users
WHERE YEAR(LastLogin) = YEAR(GETDATE())
	AND MONTH(LastLogin) = MONTH(GETDATE())
	AND DAY(LastLogin) = DAY(GETDATE())

GO

-- Problem 17
CREATE TABLE Groups
(
Id int IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(50) NOT NULL UNIQUE,
)

-- Problem 18
ALTER TABLE Users
ADD GroupId int

ALTER TABLE Users
ADD FOREIGN KEY (GroupId) REFERENCES Groups (Id)

-- Problem 19
INSERT INTO Groups(Name)
VALUES 
	('Kaspichan'),
	('Pernik'),
	('Plovdiv')

INSERT INTO Users(Username, Password, FullName, LastLogin, GroupId)
VALUES 
	('peshoP', '12345', 'Pesho izvestniq', '01.02.2015', 1),
	('goshoG', 'adsasd', 'Gosho Qkiq', '08.29.2014', 3),
	('ivan', 'qwer123', 'Ivan Ivanov', '02.14.2015' , 2)

-- Problem 20
UPDATE Groups
SET	Name = 'Third'
WHERE Id = 3

UPDATE Users
SET	FullName = FullName + '_Third'
WHERE GroupId = 3

-- Problem 21
DELETE FROM Users
WHERE GroupId = 3

DELETE FROM Groups
WHERE Id = 3

-- Problem 22 
-- Add Middle Name because have equal username.
INSERT INTO Users(Username, Password, FullName)
SELECT LOWER(LEFT(FirstName,1) + ISNULL(MiddleName,'') + LastName), '12345', FirstName + ' ' + LastName
FROM Employees;

-- Problem 23
UPDATE Users
SET	Password = NULL
WHERE LastLogin < CONVERT(date, '03.10.2010')

-- Problem 24
DELETE FROM Users
WHERE Password IS NULL

-- Problem 25
SELECT d.Name, e.JobTitle, AVG(e.Salary) as [Average Salary]
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle

-- Problem 26
SELECT d.Name, e.JobTitle, e.FirstName ,MIN(Salary) as [Min Salary]
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle, e.FirstName

-- Problem 27
SELECT TOP 1 t.Name, COUNT(e.EmployeeID) as [Number of employees]
FROM
	Employees e JOIN Addresses a
		ON e.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
GROUP BY t.Name
ORDER BY COUNT(e.EmployeeID) DESC


-- Problem 28
SELECT t.Name, COUNT(DISTINCT m.EmployeeID) as [Number of managers]
FROM
	Employees e JOIN Employees m 
		ON e.ManagerID = m.EmployeeID
	JOIN Addresses a
		ON m.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
GROUP BY t.Name

GO

-- Problem 29
CREATE TABLE WorkHours
(
Id int IDENTITY(1,1) PRIMARY KEY,
WorkDate datetime,
Task nvarchar(100),
Hours int,
Comments nvarchar(250),
EmployeeId int,
Constraint FK_Work_emp FOREIGN KEY (EmployeeId) REFERENCES Employees (EmployeeID) 
)

-- Problem 30
INSERT INTO WorkHours
VALUES 
	(GETDATE(), 'C# Game', 5, NULL, 2),
	(GETDATE(), 'Java Game', 11, '8 Pool', 10)

UPDATE WorkHours
SET	Task = 'JS Project'
WHERE EmployeeId = 2

DELETE FROM WorkHours
WHERE EmployeeId = 2

-- Problem 31
CREATE TABLE WorkHoursLogs
(
Id int IDENTITY(1,1) PRIMARY KEY,
ChangeDate datetime,
Command nvarchar(6),
OldDate dateTime,
OldTask nvarchar(100),
OldHours int,
OldComments nvarchar(250),
OldEmployeeId int,
NewDate dateTime,
NewTask nvarchar(100),
NewHours int,
NewComments nvarchar(250),
NewEmployeeId int,  
)

GO

CREATE TRIGGER WorkHours_trigger
ON WorkHours
AFTER UPDATE, INSERT, DELETE
AS
IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
BEGIN
	INSERT INTO WorkHoursLogs
	SELECT 
		GETDATE(), 
		'UPDATE', 
		d.WorkDate, 
		d.Task, 
		d.Hours, 
		d.Comments, 
		d.EmployeeId, 
		i.WorkDate, 
		i.Task, 
		i.Hours, 
		i.Comments,
		i.EmployeeId 
	FROM deleted d, inserted i
END

IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
BEGIN
	INSERT INTO WorkHoursLogs(ChangeDate, Command, NewDate, NewTask, NewHours, NewComments, NewEmployeeId)
	SELECT 
		GETDATE(), 
		'INSERT',
		i.WorkDate, 
		i.Task, 
		i.Hours, 
		i.Comments,
		i.EmployeeId 
	FROM inserted i
END

IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted) 
BEGIN
	INSERT INTO WorkHoursLogs(ChangeDate, Command, OldDate, OldTask, OldHours, OldComments, OldEmployeeId)
	SELECT 
		GETDATE(), 
		'DELETE', 
		d.WorkDate, 
		d.Task, 
		d.Hours, 
		d.Comments, 
		d.EmployeeId
	FROM deleted d
END

-- Problem 32
BEGIN TRANSACTION [DeleteEmp]

ALTER TABLE EmployeesProjects
DROP Constraint FK_EmployeesProjects_Employees

ALTER TABLE EmployeesProjects
ADD Constraint FK_EmployeesProjects_Employees 
FOREIGN KEY(EmployeeID) 
REFERENCES Employees(EmployeeID)
ON DELETE CASCADE;

ALTER TABLE Departments
DROP Constraint FK_Departments_Employees

ALTER TABLE Departments
ADD Constraint FK_Departments_Employees 
FOREIGN KEY(ManagerID) 
REFERENCES Employees(EmployeeID)
ON DELETE CASCADE;

ALTER TABLE WorkHours
DROP Constraint FK_Work_emp

ALTER TABLE WorkHours
ADD Constraint FK_Work_emp 
FOREIGN KEY(EmployeeID) 
REFERENCES Employees(EmployeeID)
ON DELETE CASCADE

DELETE e
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

ROLLBACK TRANSACTION [DeleteEmp]

-- Problem 33
BEGIN TRANSACTION [DropEmpProjects]

DROP TABLE EmployeesProjects

ROLLBACK TRANSACTION [DropEmpProjects]

-- Problem 34
DECLARE @tempEmpProjects TABLE
(
EmployeeID int NOT NULL,
ProjectID int NOT NULL
)

INSERT INTO @tempEmpProjects
SELECT *
FROM EmployeesProjects

DROP TABLE EmployeesProjects
CREATE TABLE EmployeesProjects
(
	EmployeeID int NOT NULL,
	ProjectID int NOT NULL,
	CONSTRAINT FK_EmployeesProjects_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
	CONSTRAINT FK_EmployeesProjects_Project FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID),
	CONSTRAINT PK_EmployeesProjects PRIMARY KEY (EmployeeID, ProjectID)
)

INSERT INTO EmployeesProjects
SELECT *
FROM @tempEmpProjects
