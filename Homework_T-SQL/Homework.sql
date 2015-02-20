-- Problem 1

CREATE DATABASE PersonAccount

GO

USE PersonAccount

CREATE TABLE Persons
(
ID int IDENTITY(1,1) PRIMARY KEY,
FirstName nvarchar(50),
LastName nvarchar(50),
SSN nvarchar(9)
)

GO

CREATE TABLE Accounts
(
ID int IDENTITY(1,1) PRIMARY KEY,
PersonID int FOREIGN KEY REFERENCES Persons(ID),
Balance money
)

GO

INSERT INTO Persons
	VALUES ('Pesho', 'Peshov', '123456789'),
	('Ivan', 'Ivanov', '987654321'),
	('Gosho', 'Slepiq', '564789987'),
	('Petyr', 'Gospodinov', '741852963'),
	('Kolio', 'Dimitrov', '852369741')


INSERT INTO Accounts
	VALUES (2, 2566.38),
	(3, 888888.21),
	(1, 12),
	(4, 108978)

GO

CREATE PROC usp_SelectFullNamePersons
AS
SELECT
	FirstName + ' ' + LastName AS [Full Name]
FROM Persons

GO

EXEC usp_SelectFullNamePersons

GO

-- Problem 2

CREATE PROC usp_SelectPersonHaveMoreMoney (@money money)
AS
SELECT
	p.FirstName,
	p.LastName,
	p.SSN,
	a.Balance
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID
WHERE a.Balance > @money

GO

EXEC usp_SelectPersonHaveMoreMoney 10000

GO

-- Problem 3
CREATE FUNCTION ufn_CalcNewBalance(@balance money, @interest decimal, @months int) RETURNS money
AS
BEGIN
	DECLARE @newBalance money
	SET @newBalance = @balance + (@balance * (@interest / 100 / 12 * @months))
	RETURN @newBalance
END

GO

SELECT
	p.FirstName,
	dbo.ufn_CalcNewBalance(a.Balance, 6.78, 15) AS [New Sum]
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID

GO

-- Problem 4
CREATE PROC usp_SelectPersonWitNewBalance (@AccountID int, @interest decimal)
AS
SELECT
	p.ID,
	p.FirstName,
	p.LastName,
	p.SSN,
	a.Balance,
	dbo.ufn_CalcNewBalance(a.Balance, @interest, 1) AS [New Balance],
	dbo.ufn_CalcNewBalance(a.Balance, @interest, 1) - a.Balance AS [Interest Balance]
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID
WHERE p.ID = @AccountID

GO

EXEC usp_SelectPersonWitNewBalance 2, 3.7

GO

-- Problem 5
CREATE PROC usp_WithdrawMoney (@AccountID int, @money money)
AS
DECLARE	@oldBalanace money
SELECT @oldBalanace = Balance
FROM Accounts
WHERE PersonID = @AccountID

IF(@money > @oldBalanace)
	BEGIN
		RAISERROR('Not enough balance in your account', 16, 1)
	END
IF(@money <= 0)
	BEGIN
		RAISERROR('You can not withdraw a negative or zero amount', 16, 1)
	END

UPDATE Accounts
SET Balance = Balance - @money
WHERE PersonID = @AccountID

SELECT
	p.ID,
	p.FirstName,
	p.LastName,
	p.SSN,
	a.Balance as [New Balance]
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID
WHERE p.ID = @AccountID 

GO

CREATE PROC usp_DepositMoney (@AccountID int, @money money)
AS

IF(@money <= 0)
	BEGIN
		RAISERROR('You can not deposit a negative or zero amount', 16, 1)
	END

UPDATE Accounts
SET Balance = Balance + @money
WHERE PersonID = @AccountID

SELECT
	p.ID,
	p.FirstName,
	p.LastName,
	p.SSN,
	a.Balance as [New Balance]
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID
WHERE p.ID = @AccountID 

GO

SELECT *
FROM Persons p
JOIN Accounts a
	ON p.ID = a.PersonID
WHERE p.ID = 2 

EXEC usp_WithdrawMoney 2, 566

EXEC usp_DepositMoney 2, 1000

GO

-- Problem 6
CREATE TABLE Logs
(
LogID int IDENTITY(1,1) PRIMARY KEY,
AccountID int,
OldSum money,
NewSum money 
)

GO

CREATE TRIGGER tr_LogsChangeSum
ON Accounts
AFTER UPDATE, INSERT, DELETE
AS
IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
BEGIN
	INSERT INTO Logs
	SELECT 
		i.ID, d.Balance, i.Balance
	FROM deleted d, inserted i
END

IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
BEGIN
	INSERT INTO Logs
	SELECT i.ID, 0 , i.Balance
	FROM INSERTED i
END

GO

-- Problem 7 
USE SoftUni

GO

CREATE FUNCTION ufn_CheckWordInSet(@set nvarchar(max), @word nvarchar(max)) RETURNS int
BEGIN
	DECLARE @index int, @char nchar
	SET @index = 1
	WHILE (@index <= LEN(@word))
	BEGIN
		SET @char = SUBSTRING(@word, @index, 1)

		IF (CHARINDEX(@char, @set) = 0)
		BEGIN
			RETURN 0
		END

		SET @index = @index + 1
	END
	RETURN 1
END

GO

DECLARE @set nvarchar(max)
SET @set = 'oistmiahf'
DECLARE @firstName nvarchar(max), 
	@lastName nvarchar(max), 
	@middleName nvarchar(max), 
	@town nvarchar(max)
	
DECLARE empCoursor CURSOR READ_ONLY FOR
SELECT FirstName, LastName, MiddleName FROM Employees
OPEN empCoursor
FETCH NEXT FROM empCoursor INTO @firstName, @lastName, @middleName

WHILE @@fetch_status = 0
BEGIN
	IF( dbo.ufn_CheckWordInSet(@set, @firstName) = 1 AND @firstName IS NOT NULL AND @firstName <> '')
	BEGIN
		PRINT @firstName
	END

	IF( dbo.ufn_CheckWordInSet(@set, @lastName) = 1 AND @lastName IS NOT NULL AND @lastName <> '')
	BEGIN
		PRINT @lastName
	END

	IF( dbo.ufn_CheckWordInSet(@set, @middleName) = 1  AND @middleName IS NOT NULL AND @middleName <> '')
	BEGIN
		PRINT @middleName
	END

	FETCH NEXT FROM empCoursor INTO @firstName, @lastName, @middleName
END

CLOSE empCoursor
DEALLOCATE empCoursor

DECLARE townCoursor CURSOR READ_ONLY FOR
SELECT Name FROM Towns
OPEN townCoursor
FETCH NEXT FROM townCoursor INTO @town

WHILE @@fetch_status = 0
BEGIN
	IF( dbo.ufn_CheckWordInSet(@set, @town) = 1 AND @town IS NOT NULL AND @town <> '')
	BEGIN
		PRINT @town
	END

	FETCH NEXT FROM townCoursor INTO @town
END

CLOSE townCoursor
DEALLOCATE townCoursor

GO

-- Problem 8 
DECLARE @firstName nvarchar(max), 
	@lastName nvarchar(max),
	@townName nvarchar(max), 
	@secondFirsName nvarchar(max), 
	@secondLastName nvarchar(max), 
	@secondTownName nvarchar(max)
	
DECLARE empFirstCoursor CURSOR READ_ONLY FOR
SELECT FirstName, LastName, t.Name 
FROM Employees e 
JOIN Addresses a 
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID
OPEN empFirstCoursor
FETCH NEXT FROM empFirstCoursor INTO @firstName, @lastName, @townName

WHILE @@fetch_status = 0
BEGIN
	DECLARE empSecondCoursor CURSOR READ_ONLY FOR
	SELECT FirstName, LastName, t.Name 
	FROM Employees e 
	JOIN Addresses a 
		ON e.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
	WHERE t.Name = @townName

	OPEN empSecondCoursor
	FETCH NEXT FROM empSecondCoursor INTO @secondFirsName, @secondLastName, @secondTownName

	WHILE @@fetch_status = 0
	BEGIN
		IF(@townName = @secondTownName)
		PRINT @secondLastName + ': ' 
			+ @firstName + ' ' 
			+ @lastName + ' ' 
			+ @townName + ' ' 
			+ @secondFirsName
		FETCH NEXT FROM empSecondCoursor INTO @secondFirsName, @secondLastName, @secondTownName
	END

	CLOSE empSecondCoursor
	DEALLOCATE empSecondCoursor
	FETCH NEXT FROM empFirstCoursor INTO @firstName, @lastName, @townName
END
CLOSE empFirstCoursor
DEALLOCATE empFirstCoursor

GO

-- Problem 9
-- TODO


-- Problem 10
DECLARE @firstName nvarchar(max), 
	@lastName nvarchar(max),
	@townName nvarchar(max),
	@currTown nvarchar(max),
	@print nvarchar(max)
DECLARE empCoursor CURSOR READ_ONLY FOR
SELECT FirstName, LastName, t.Name 
FROM Employees e 
JOIN Addresses a 
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID
ORDER BY t.Name
OPEN empCoursor
FETCH NEXT FROM empCoursor INTO @firstName, @lastName, @townName
SET @currTown = @townName
SET @print = @townName + ' -> '

WHILE @@fetch_status = 0
BEGIN
	IF(@currTown = @townName)
	BEGIN
		SET @print = @print + @firstName + ' ' + @lastName + ', '
	END
	ELSE
	BEGIN
		PRINT SUBSTRING(@print,1,len(@print)-1)
		SET @print = @townName + ' -> ' + @firstName + ' ' + @lastName + ', '
		SET @currTown = @townName
	END

	FETCH NEXT FROM empCoursor INTO @firstName, @lastName, @townName
END
CLOSE empCoursor
DEALLOCATE empCoursor
