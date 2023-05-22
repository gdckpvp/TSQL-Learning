-- BTVN2 --
--Module 2: SubQuery
-- BT1 --
USE [Sales]
GO
SELECT PRName.Name, PR.ProductID
FROM Production.Product AS PRName, Sales.SalesOrderDetail AS PR, Sales.SalesOrderHeader AS ODD
WHERE
	PRName.ProductID = PR.ProductID
	AND PR.SalesOrderID = ODD.SalesOrderID
	AND ODD.OrderDate >= '2008-07-01' 
	AND ODD.OrderDate <= '2008-07-31'
GROUP BY
	PRName.Name, PR.ProductID
HAVING COUNT(ODD.SalesOrderID) > 100
GO

-- BT2 --
USE [Sales]
GO
SELECT PR.ProductID, PR.Name
FROM Production.Product AS PR, Sales.SalesOrderDetail AS DE, Sales.SalesOrderHeader AS HE
WHERE
	PR.ProductID = DE.ProductID
	AND DE.SalesOrderID = HE.SalesOrderID
	AND HE.OrderDate BETWEEN '2008-07-01' AND '2008-07-31'
GROUP BY PR.ProductID, PR.Name
ORDER BY Count(DE.ProductID) DESC
GO

-- BT3--
USE AdventureWorks2019
GO
SELECT
	Sale.CustomerID, 
	(Per.FirstName + ' ' +Per.LAStName) AS 'NameCustomer',
	Count(Sale.SalesOrderID) AS 'CountOfOrder'
FROM Sales.SalesOrderHeader AS Sale, Person.Person AS Per
WHERE 
	Per.BusinessEntityID = Sale.CustomerID
Group BY
	Sale.CustomerID,
	Per.FirstName + ' ' +Per.LAStName
HAVING
	Count(Sale.SalesOrderID) >= All
	(
		SELECT			
			Count(Sale.SalesOrderID)
		FROM Sales.SalesOrderHeader AS Sale, Person.Person AS Per
		WHERE 
			Per.BusinessEntityID = Sale.CustomerID
		Group BY
			Sale.CustomerID
	)
Order By
	Sale.CustomerID
GO
--BT4--
/*IN*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE p.ProductID IN (
    SELECT ProductID
    FROM Production.ProductModel AS pm
    WHERE 
		p.Name LIKE 'LONg-Sleeve Logo Jersey%'
		and p.ProductModelID = pm.ProductModelID
	)
GO

/*Exists*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE EXISTS (
    SELECT *
    FROM Production.ProductModel AS pm
    WHERE 
		p.Name LIKE 'LONg-Sleeve Logo Jersey%'
		and p.ProductModelID = pm.ProductModelID 
	)
GO

--BT5--
USE AdventureWorks2019
GO
SELECT 
	P.ProductModelID
FROM 
	Production.Product AS P
Group BY 
	P.ProductModelID
HAVING
	Max(P.ListPrice) > All
	(
		SELECT 
			AVG(P.ListPrice)
		FROM 
			Production.Product AS P
	)
GO

--BT6--
/*IN*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE p.ProductID IN (
    SELECT p.ProductID
    FROM Sales.SalesOrderDetail AS Sale
    WHERE 
		p.ProductID = Sale.ProductID
	HAVING Sum(Sale.OrderQty) > 5000
	)
GO

/*Exists*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE EXISTS (
    SELECT *
    FROM Sales.SalesOrderDetail AS Sale
    WHERE 
		p.ProductID = Sale.ProductID
	HAVING Sum(Sale.OrderQty) > 5000
	)
GO

--BT7--
USE AdventureWorks2019
GO
SELECT
	ProductID,
	UnitPrice
FROM 
	Sales.SalesOrderDetail
Group BY
	ProductID,
	UnitPrice
HAVING
	UnitPrice >= ALL
	(
		SELECT UnitPrice
		FROM
			Sales.SalesOrderDetail
	)
GO

--BT8--
/*NOT IN*/
USE AdventureWorks2019
GO
SELECT
	P.ProductID,
	P.Name
FROM
	Production.Product AS P
WHERE
	P.ProductID NOT IN
	(
		SELECT Sale.ProductID
		FROM
			Sales.SalesOrderDetail AS Sale
	)
GO

/*NOT EXISTS*/
USE AdventureWorks2019
GO
SELECT P.ProductID, P.Name
FROM Production.Product AS P
WHERE
	NOT EXISTS
	(
		SELECT *
		FROM Sales.SalesOrderDetail AS S
		WHERE
			P.ProductID = S.ProductID
	)
GO

/*LEFT JOIN*/
USE AdventureWorks2019
GO
SELECT P.ProductID, P.Name
FROM Production.Product P Left JOIN Sales.SalesOrderDetail S 
	ON P.ProductID = S.ProductID
WHERE 
	S.ProductID IS null
GO

-- BT9 --
USE AdventureWorks2019
GO
SELECT ES.BusinessEntityID, E.FirstName , E.LAStName
FROM Person.Person E, Sales.SalesOrderHeader S, HumanResources.Employee AS ES
WHERE 
	E.BusinessEntityID = ES.BusinessEntityID
	AND not exists
	(
		SELECT E.BusinessEntityID
		FROM Person.Person E, Sales.SalesOrderHeader S
		WHERE
			E.BusinessEntityID = ES.BusinessEntityID
			AND E.BusinessEntityID = S.SalesPersonID
			AND S.OrderDate > '2007-05-01'
		Group by E.BusinessEntityID
	)
GROUP BY ES.BusinessEntityID, E.FirstName , E.LAStName
GO


-- BT10 --
USE AdventureWorks2019
GO
SELECT C.CustomerID, (E.FirstName + ' ' + E.LAStName) AS 'Name'
FROM (Person.Person E JOIN Sales.Customer AS C
	ON C.CustomerID = E.BusinessEntityID) JOIN Sales.SalesOrderHeader S
	ON C.CustomerID = S.CustomerID
WHERE C.CustomerID = E.BusinessEntityID
	AND S.OrderDate Between '2007-01-01' and '2007-12-31'
	AND C.CustomerID not in
	(
		SELECT C2.CustomerID
		FROM (Person.Person E JOIN Sales.Customer AS C2
			ON C2.CustomerID = E.BusinessEntityID) JOIN Sales.SalesOrderHeader S
			ON C2.CustomerID = S.CustomerID
		WHERE 
			S.OrderDate Between '2008-01-01' and '2008-12-31'
		GROUP BY C2.CustomerID
	)
GROUP BY C.CustomerID,(E.FirstName + ' ' + E.LAStName)
GO


