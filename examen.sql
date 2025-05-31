--1. ¿cuantos productos diferentes tengo por categoria? ordenalos por categoria 
SELECT CategoryID, COUNT(ProductID) AS ProductosDiferentes
FROM Products
GROUP BY CategoryID

/*2. mostrar el nombre del cliente, nombbre de provedor, nombre del empleado y nombre 
de los productos que estan en la orden 10250*/
SELECT C.CompanyName, S.CompanyName, S.ContactName, E.FirstName + ' '+ E.LastName AS EMPLEADO, ProductName
FROM Suppliers S
INNER JOIN Products P
ON (P.SupplierID = S.SupplierID)
INNER JOIN [Order Details] OD
ON (P.ProductID = OD.ProductID)
INNER JOIN Orders O
ON (OD.OrderID = O.OrderID)
INNER JOIN Customers C
ON (O.CustomerID = C.CustomerID)
INNER JOIN Employees E
ON (O.EmployeeID = E.EmployeeID)
WHERE OD.OrderID = 10250

/*3 se cometio un error por un empleado y algunos precios no son los correctos en los 
detalles de las ordenes. lista las perdidas por nombre de categoria de mayor perdida a
menor*/
SELECT C.CategoryName, 
(SUM(OD.UnitPrice*Quantity) - SUM(P.UnitPrice*Quantity))AS Perdida
FROM Products P
INNER JOIN [Order Details] OD
ON (OD.ProductID = P.ProductID)
INNER JOIN Categories C
ON (P.CategoryID = C.CategoryID)
WHERE P.UnitPrice <> OD.UnitPrice
GROUP BY CategoryName
ORDER BY Perdida ASC

--4. clientes que no han realizado ningun pedido
SELECT C.CustomerID, C.CompanyName
FROM Customers C
LEFT JOIN Orders O
ON (O.CustomerID = C.CustomerID)
WHERE O.OrderID IS NULL

/*5. Crear un disparador que cuando disminuya el stock al nivel minimo automaticamente
pida mas unidadeS*/
--Copiar la tabla
SELECT *
INTO Productos 
FROM Products

--Ver que la copiamos bien
SELECT *
FROM Productos

CREATE TRIGGER trg_diferencia_stock
ON [Order Details]
AFTER INSERT
AS
BEGIN
    INSERT INTO StockDiferencia (ProductID, NombreProducto, CantidadFaltante)
    SELECT I.ProductID, P.ProductName, I.Quantity - P.UnitsInStock
    FROM INSERTED I
    JOIN Products P ON I.ProductID = P.ProductID
    WHERE I.Quantity > P.UnitsInStock
END

/*6. El o los productos que NO se vendidos en el año 1996, el nombre y el id, ademas 
mostrar la o las ventas de esos productos de los años siguientes es decir 1997*/
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
ORDER BY ProductID ASC