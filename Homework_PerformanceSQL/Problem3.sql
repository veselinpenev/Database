-- Problem 3
CREATE DATABASE Homework_PerformanceSQL

USE Homework_PerformanceSQL

CREATE TABLE Task
(
TaskDate datetime NOT NULL,
TaskDescription nvarchar(50),
primary key(TaskDate)
)
ALTER TABLE Task PARTITION BY RANGE(YEAR(TaskDate))(
	PARTITION p1990 VALUES LESS THAN (2000),
    PARTITION p2000 VALUES LESS THAN (2010),
    PARTITION p2010 VALUES LESS THAN MAXVALUE
);

DELIMITER $$
CREATE PROCEDURE insertData()
BEGIN
	SET @n=0;
	SET	@date = str_to_date('01/01/1990', '%m/%d/%Y');
    START TRANSACTION;
    WHILE @n<1000000 DO
		insert into Task SELECT @date, 'Text';
		SET @n = @n+1;
		SET @date = DATE_ADD(@date, interval +10 minute);
    END WHILE;
    COMMIT;
END

CALL insertData;

-- Check max and min date
-- Max Date 2009-01-05 10:30:00
-- Min Date 1990-01-01 00:00:00
-- SELECT MAX(TaskDate), MIN(TaskDate)
-- FROM Task

-- Partiotion 1
SELECT *
FROM Task
WHERE TaskDate BETWEEN str_to_date('01/01/1991', '%m/%d/%Y') AND str_to_date('01/01/1999', '%m/%d/%Y') 

-- Partiotion 2
SELECT *
FROM Task
WHERE TaskDate BETWEEN str_to_date('01/01/2000', '%m/%d/%Y') AND str_to_date('01/01/2009', '%m/%d/%Y') 