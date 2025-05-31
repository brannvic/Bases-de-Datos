--Ejercios con WHERE
--1
SELECT OrderID
FROM Orders
WHERE Freight > 50

--2
SELECT ProductName
FROM Products
WHERE UnitsInStock > 75

--3
SELECT ProductName
FROM Products
WHERE Discontinued = 1
AND UnitsInStock >= 1

--4
SELECT OrderID
FROM Orders
WHERE ShipCountry LIKE '%Germany%'

--5
SELECT OrderID
FROM Orders
WHERE ShippedDate IS NULL

--6
SELECT ContactName
FROM Customers
WHERE FAX IS NOT NULL

--7
SELECT FirstName, HireDate
FROM Employees
WHERE YEAR(HireDate) = 1993
OR YEAR(HIREDATE) = 1994

--8
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%QUESO%'

--9
SELECT OrderID
FROM Orders
WHERE ShipVia = 2

--10
SELECT OrderID
FROM Orders
WHERE MONTH(OrderDate) = 12

--11
SELECT CompanyName
FROM  Suppliers
WHERE Country LIKE '%JAPAN%'

--12
SELECT ProductName
FROM Products
WHERE QuantityPerUnit LIKE '%oz%'

--13
SELECT ProductID, Discount
FROM [Order Details]
WHERE Discount > 0

--14
SELECT OrderID
FROM [Order Details]
WHERE ProductID <> 3

--15
SELECT ProductName
FROM Products
WHERE UnitsInStock >= 50
AND Discontinued = 0

--16
SELECT OrderID
FROM Orders
WHERE Freight < 10
AND YEAR(OrderDate) = 1997

--17
SELECT ContactName
FROM Customers
WHERE ContactName LIKE 'B%'

--Ejercicios con funciones de agregación, WHERE, GROUP BY, HAVING y ORDER BY
--1
SELECT CustomerID, SUM(OrderID) AS TOTAL
FROM Orders
GROUP BY CustomerID

--2
SELECT ReportsTo, COUNT(EmployeeID) AS EMPLEADOS
FROM Employees
GROUP BY ReportsTo

--3
SELECT MONTH(OrderDate) AS MES, COUNT(OrderID) AS ORDENES
FROM Orders
GROUP BY MONTH(OrderDate)

--4
SELECT SupplierID, SUM(UnitsInStock) AS TOTAL
FROM Products
GROUP BY SupplierID

--5
SELECT CategoryID, COUNT(ProductID) AS TOTAL
FROM Products
GROUP BY CategoryID

--6
SELECT ProductID,SUM(UnitPrice*UnitsInStock) AS TOTAL
FROM Products
GROUP BY ProductID

--7
SELECT ShipCountry, AVG(Freight) AS COSTO
FROM Orders
GROUP BY ShipCountry
ORDER BY ShipCountry ASC

--9
SELECT EmployeeID, COUNT(OrderID) AS ORDENES
FROM Orders
GROUP BY EmployeeID
ORDER BY EmployeeID ASC

--10
SELECT ProductID, SUM(Quantity) AS VENDIDO
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID ASC

--11
SELECT Country, COUNT(CustomerID) AS CLIENTES
FROM Customers
GROUP BY Country
ORDER BY Country ASC

--12
SELECT ShipVia, COUNT(OrderID) AS PEDIDOS
FROM Orders
GROUP BY ShipVia
ORDER BY ShipVia ASC

--13
SELECT CategoryID, AVG(UnitPrice) AS PRECIO
FROM Products
GROUP BY CategoryID
HAVING AVG(UnitPrice) >= 30

--14
SELECT ProductName, SUM(UnitsInStock) AS STOCK
FROM Products
GROUP BY ProductName
HAVING SUM(UnitsInStock) > 1000

--15
SELECT Country, COUNT(CustomerID) AS CLIENTE
FROM Customers
GROUP BY Country
ORDER BY CLIENTE DESC

--16
SELECT CustomerID, COUNT(OrderID) AS ORDENES
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) >= 5

--17
SELECT EmployeeID, COUNT(OrderID) AS ORDENES
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(OrderID) > 100

--18
SELECT OrderDate, COUNT(OrderID)
FROM Orders
GROUP BY OrderDate
HAVING COUNT(OrderID) > 10

--19
SELECT SupplierID, COUNT(ProductName)
FROM Products
WHERE Discontinued = 0
GROUP BY SupplierID 


--20
SELECT Country, COUNT(CustomerID)
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) >= 3

--Ejercicios que requieren el uso de JOINs (INNER, LEFT o RIGHT) junto con WHERE, GROUP BY, HAVING, ORDER BY y funciones de agregación. EX
--1. ¿Qué categorias de productos tienen un precio promedio de venta mayor a $20, mostrar el id de la categoria y el precio promedio
SELECT CategoryID, UnitPrice
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC

--CORRECTO
SELECT CategoryID, AVG(UnitPrice) AS PrecioPromedio
FROM Products
GROUP BY CategoryID
HAVING AVG(UnitPrice) > 20


--2. Mostrar el maximo y el minimo del precio de los productos que me vende el proveedor tambien mostrar el nombre de la compañia proveedora
SELECT SU.COMPANYNAME, MAX(PO.UNITPRICE) AS MAXIMO, MIN(PO.UNITPRICE) AS MINIMO
FROM PRODUCTS PO
INNER JOIN SUPPLIERS SU
ON PO.SUPPLIERID = SU.SUPPLIERID
GROUP BY SU.COMPANYNAME

--3. Mostrar el nombre del cliente, nombre de la compañia del proveedor, nombre del empleado y nombre de los productos que estan en la orden 10250
SELECT CO.CONTACTNAME, CO.COMPANYNAME AS COMPA_CLIENTE, SU.COMPANYNAME AS PROVEEDOR, SU.CONTACTNAME AS CONTACTO_PROVEEDOR,
(EM.FIRSTNAME + ' ' + EM.LASTNAME) AS EMPLEADO, PO.PRODUCTNAME
FROM SUPPLIERS SU
JOIN PRODUCTS PO ON SU.SUPPLIERID = PO.SUPPLIERID
JOIN [ORDER DETAILS] ODS ON PO.PRODUCTID = ODS.PRODUCTID
JOIN ORDERS OD ON ODS.ORDERID = OD.ORDERID
JOIN EMPLOYEES EM ON OD.EMPLOYEEID = EM.EMPLOYEEID
JOIN CUSTOMERS CO ON OD.CUSTOMERID = CO.CUSTOMERID
WHERE OD.ORDERID = 10250

--4. Clientes que no han realizado ningun pedido
SELECT * FROM [ORDER DETAILS]
SELECT * FROM CUSTOMERS
SELECT * FROM ORDERS

SELECT CU.CUSTOMERID, CU.COMPANYNAME
FROM CUSTOMERS CU
LEFT JOIN Orders OD ON CU.CUSTOMERID = OD.CUSTOMERID
WHERE OD.ORDERID IS NULL

--5. Productos o producto que aun no hemos ordenado a pesar de que ya deberiamos haber pedido más, está bajo en stock
SELECT * FROM PRODUCTS

SELECT *
FROM PRODUCTS
WHERE REORDERLEVEL > UNITSINSTOCK AND UNITSONORDER = 0

--6. Listar ID del cliente y número de ordenes compradas, pero solo del cliente con el mayor numero de ordenes compradas (no se permite el uso de TOP, ni ninguna otra instruccion que no sea de SQL estandar)
SELECT * FROM ORDERS

SELECT CUSTOMERID, COUNT(CUSTOMERID) AS CONTEO
FROM ORDERS
GROUP BY CUSTOMERID
HAVING COUNT(CUSTOMERID) >= ALL(
SELECT COUNT(CUSTOMERID)
FROM ORDERS
GROUP BY CUSTOMERID
);

--7. Desarrollar una consulta con la que se pueda responder la pregunta ¿Todas las ordenes tienen al menos un produto de descuento?
SELECT * FROM [ORDER DETAILS]

SELECT DISTINCT OD.ORDERID
FROM ORDERS OD
LEFT JOIN [ORDER DETAILS] ODS ON OD.ORDERID = ODS.ORDERID AND ODS.DISCOUNT > 0
WHERE ODS.ORDERID IS NULL;


--8. Mostrar la diferencia de venta entre las diferentes regiones, contra la region que más compra y la region que menos compra.
WITH VENTASPORREGION AS (
SELECT
COALESCE(C.REGION, 'RESTO DEL MUNDO') AS REGION,
COUNT(O.ORDERID) AS NUMEROORDENES,
SUM(OD.UNITPRICE * OD.QUANTITY * (1 - OD.DISCOUNT)) AS TOTALVENTAS
FROM ORDERS O
LEFT JOIN CUSTOMERS C ON O.CUSTOMERID = C.CUSTOMERID
JOIN [ORDER DETAILS] OD ON O.ORDERID = OD.ORDERID
GROUP BY COALESCE(C.REGION, 'RESTO DEL MUNDO')
),
ESTADISTICASREGION AS (
SELECT
REGION,
TOTALVENTAS,
NUMEROORDENES,
MAX(TOTALVENTAS) OVER () AS MAXVENTAS,
MIN(TOTALVENTAS) OVER () AS MINVENTAS,
AVG(TOTALVENTAS) OVER () AS PROMEDIOVENTAS
FROM VENTASPORREGION
)
SELECT
E.REGION,
ROUND(E.TOTALVENTAS, 2) AS TOTALVENTAS,
ROUND(E.MAXVENTAS - E.TOTALVENTAS, 2) AS DIFCONELMAXIMO,
ROUND(E.TOTALVENTAS - E.MINVENTAS, 2) AS DIFCONELMINIMO
FROM ESTADISTICASREGION E
ORDER BY E.TOTALVENTAS DESC;

--9. El o los productos que no se vendieron en 1996, el nombre y ID, además de mostrar la o las ventas de esos productos del siguiente año. YEAR(ORDERDATE) = 1996
SELECT 
  P.ProductID,
  P.ProductName,
  SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas1997
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997
AND P.ProductID NOT IN (
  SELECT DISTINCT OD.ProductID
  FROM [Order Details] OD
  JOIN Orders O ON OD.OrderID = O.OrderID
  WHERE YEAR(O.OrderDate) = 1996
)
GROUP BY P.ProductID, P.ProductName