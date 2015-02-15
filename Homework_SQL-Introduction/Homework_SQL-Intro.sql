-- Problem 4
SELECT * FROM Departments

-- Problem 5
SELECT Name FROM Departments

-- Problem 6
SELECT FirstName + ' ' + LastName as FullName, Salary 
FROM Employees

-- Problem 7
SELECT FirstName + ' ' + LastName as FullName
FROM Employees

-- Problem 8
SELECT FirstName + '.' + LastName + '@softuni.bg' as [Full Email Addresses] 
FROM Employees

-- Problem 9
SELECT DISTINCT Salary 
FROM Employees

-- Problem 10
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'

-- Problem 11
SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'SA%'

-- Problem 12
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

-- Problem 13
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

-- Problem 14
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

-- Problem 15
SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL

-- Problem 16
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

-- Problem 17
SELECT TOP 5 FirstName, LastName, Salary
FROM Employees
ORDER BY Salary DESC

-- Problem 18
SELECT e.FirstName, e.LastName, a.AddressText
FROM Employees e JOIN Addresses a
	ON e.AddressID = a.AddressID

	
-- Problem 19
SELECT e.FirstName, e.LastName, a.AddressText
FROM Employees e, Addresses a
WHERE e.AddressID = a.AddressID

-- Problem 20
SELECT e.FirstName, e.LastName, m.FirstName + ' ' + m.LastName as Manager
FROM Employees e JOIN Employees m
	ON e.ManagerID = m.EmployeeID

-- Problem 21
SELECT 
	e.FirstName, 
	e.LastName, 
	m.FirstName + ' ' + m.LastName as Manager,
	a.AddressText
FROM 
	Employees e LEFT JOIN Employees m
		ON e.ManagerID = m.EmployeeID 
	JOIN Addresses a
		ON e.AddressID = a.AddressID

--Problem 22
SElECT d.Name
FROM Departments d
UNION
SElECT t.Name 
FROM Towns t

-- Problem 23
SELECT e.FirstName, e.LastName, m.FirstName + ' ' + m.LastName as Manager
FROM Employees m RIGHT JOIN Employees e
	ON e.ManagerID = m.EmployeeID

-- Problem 24
SELECT e.FirstName, e.LastName,e.HireDate, d.Name as [Department Name]
FROM Employees e JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE (d.Name IN ('Sales', 'Finance')) AND (YEAR(e.HireDate) BETWEEN 1995 AND 2005)