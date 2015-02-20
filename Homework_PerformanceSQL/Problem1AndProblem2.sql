-- Problem 1
CREATE DATABASE Homework_PerformanceSQL
ON
(
NAME = PerSQL_dat,
FILENAME = 'E:\Programing\SQL\MSSQL12.MSSQLSERVER\MSSQL\DATA\PerSQL_dat.mdf',
SIZE = 1000,
MAXSIZE = 2000,
FILEGROWTH = 200
)
LOG ON
(
NAME = PerSQL_log,
FILENAME = 'E:\Programing\SQL\MSSQL12.MSSQLSERVER\MSSQL\DATA\PerSQL_log.ldf',
SIZE = 1000,
MAXSIZE = 2000, 
FILEGROWTH = 200
)

GO

USE Homework_PerformanceSQL

CREATE TABLE Task
(
ID int IDENTITY(1,1) PRIMARY KEY,
TaskDate datetime,
TaskDescription nvarchar(max)
)

GO

DECLARE @n int,
	@date datetime
SET @n=5000000
SET	@date = convert(datetime, '01/01/1990')

BEGIN TRANSACTION
WHILE(@n>0)
BEGIN
	INSERT INTO Task
	VALUES (@date, ('Text' + convert(nvarchar,@n)))
	SET @n = @n - 1
	SET @date = DATEADD(MINUTE, 1, @date)
END
COMMIT TRANSACTION

GO

-- Check min and max date in table
--SELECT MAX(TaskDate), MIN(TaskDate)
--FROM Task

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

-- Min date 1990-01-01 00:00:00.000
-- Max date 1999-07-05 05:19:00.000
SELECT TaskDate
FROM Task
WHERE TaskDate BETWEEN CONVERT(DATETIME, '03/01/1990') AND CONVERT(DATETIME, '08/01/1993')


-- Problem 2
CREATE NONCLUSTERED INDEX IX_Task_TaskDate
	ON Task(TaskDate)

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

-- Select after index
SELECT TaskDate
FROM Task
WHERE TaskDate BETWEEN CONVERT(DATETIME, '03/01/1990') AND CONVERT(DATETIME, '08/01/1993')