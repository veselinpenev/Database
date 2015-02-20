EXEC sys.sp_configure 'clr enabled', 1

GO

RECONFIGURE

GO

CREATE ASSEMBLY ConcatString
AUTHORIZATION dbo
-- Change path
FROM 'E:\Programing\SQL\Homework_T-SQL\ConcatStringSQL.dll'
WITH PERMISSION_SET = SAFE

GO

CREATE AGGREGATE dbo.StrConcat  (@value nvarchar(max))
RETURNS nvarchar(max)
EXTERNAL NAME ConcatString.[ConcatStringSQL.Concatenate]

GO

USE SoftUni
SELECT dbo.StrConcat(FirstName + ' ' + LastName)
FROM Employees