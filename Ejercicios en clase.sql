/*TODOS LOS EJERCICIOS DE SQL*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Ejercicios_SQL_01 (WHERE)  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Productos donde el precio sea 18 o 34 o 17
SELECT *
FROM Products
WHERE UnitPrice IN (18, 34, 17)

--2. El nombre de los productos que cuesten más de 40 dólares y estén descontinuados y aun no se hayan vendido
SELECT ProductName
FROM Products
WHERE UnitPrice > 40
AND Discontinued = 1
AND UnitsInStock >= 1

--3. El producto y el vendedor del producto que tengamos menos de 10 unidades y que aún no se haya ordenado más mercancía
SELECT ProductName, SupplierID
FROM Products
WHERE UnitsInStock <= 10
AND UnitsOnOrder = 0

--4. ¿Qué productos ya se han ordenado nuevamente?
SELECT ProductName
FROM Products
WHERE UnitsOnOrder > 0
AND ReorderLevel > 0

--5. ¿Qué productos aún no se han ordenado a pesar de estar por debajo del mínimo de Stock?**
SELECT ProductName
FROM Products
WHERE UnitsInStock < ReorderLevel
AND UnitsOnOrder = 0

/*6. ¿Qué productos tiene más de 100 unidades sin vender y cuesta más de 100? O los productos que cuesten menos de 20 y se tenga más de 100 unidades y además venga del 
proveedor 1*/
SELECT ProductName
FROM Products
WHERE (UnitPrice > 100 AND UnitsInStock > 100)
   OR (UnitPrice < 20 AND UnitsInStock > 100 AND SupplierID = 1)

--7. ¿Que productos se pidieron al proveedor 5 que surta nuevamente?
SELECT ProductName
FROM Products
WHERE SupplierID = 5
AND UnitsOnOrder > 0

--8. Listar los productos que pertenecen a la categoría 1, 5, 7 y además están descontinuados
SELECT ProductName
FROM Products
WHERE CategoryID IN(1, 5, 7)
AND Discontinued = 1

--9. ¿Se ha ordenado algo que no se necesitaba?
SELECT ProductName
FROM Products
WHERE UnitsInStock > ReorderLevel
AND UnitsOnOrder > 0

--10. Los Productos que tenemos con más de 40 unidades, pero menos de 100
SELECT ProductName
FROM Products
WHERE UnitsInStock > 40 
AND UnitsInStock < 100

--11. ¿Qué productos vendemos por onzas?
SELECT ProductName
FROM Products
WHERE QuantityPerUnit LIKE '%oz%'

--12. ¿Qué productos se nos surten por caja o por bolsa (‘Boxes’,‘bags’)?
SELECT ProductName
FROM Products
WHERE QuantityPerUnit LIKE '%bags%' 
OR QuantityPerUnit LIKE '%boxes%' 

--13. Los precios y productos donde el precio es cerrado (el precio no tiene valor en los decimales)
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice = FLOOR(UnitPrice) 

-- EJERCICIOS EXTRA
--14. ¿Qué productos nos lo surten en cajas y por piezas?
SELECT ProductName, QuantityPerUnit
FROM Products
WHERE QuantityPerUnit LIKE '%pieces%' 
AND QuantityPerUnit LIKE '%boxes%' 

--15. El o los productos que se surte por paquetes 'pkgs' y además está bajos Stock
SELECT ProductName
FROM Products
WHERE QuantityPerUnit LIKE '%pkgs%' 
AND UnitsInStock < ReorderLevel

--16. Los productos que nos venden a partir de 100 piezas y además las unidades son gramos 'g'
SELECT ProductName
FROM Products
WHERE QuantityPerUnit LIKE '%100 g pieces%'
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  EjerciciosGroupByCOD02_Lite (GROUP BY)  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. ¿Cuántos productos hay en total?
SELECT COUNT(*) 
FROM Products

--2. ¿Cúantas piezas de productos hay en total?
SELECT SUM(UnitsInStock)
FROM Products


--3. ¿Cuál es el precio más alto entre todos los productos?
SELECT MAX(UnitPrice)
FROM Products

--4. ¿Cuál es el precio más alto por cada una de las categorias?
SELECT MAX(UnitPrice)
FROM Products
GROUP BY CategoryID

--5. ¿Cúantas piezas de pruductos hay en total por cada proveedor?*
SELECT SUM(UnitsInStock)
FROM Products
GROUP BY SupplierID

--6. ¿Cuántos proveedores hay registrados?
SELECT COUNT(*) 
FROM Suppliers

--7. ¿Cuál es el precio promedio de los productos por categoría?
SELECT AVG(UnitPrice)
FROM Products
GROUP BY CategoryID

--8. ¿Cuántos pedidos ha realizado cada cliente?
SELECT COUNT(OrderID)
FROM Orders
GROUP BY CustomerID

--9. ¿Cuál es la fecha más reciente de pedido para cada cliente?
SELECT MAX(OrderDate)
FROM Orders
GROUP BY CustomerID
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Solucion_EjerciciosClaseGroupByCOD02  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Determinar la cantidad de producto en stock que tenemos por proveedor. Presentarlo de la mayor cantidad a la menor.
SELECT SupplierID, 
SUM(UnitsInStock) AS Total
FROM Products
GROUP BY SupplierID
ORDER BY Total DESC

--2. ¿De que Proveedor tenemos más dinero en almacén?
SELECT SupplierID, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY SupplierID
ORDER BY Total DESC

--3. Necesitamos saber cuántas ordenes le hemos hecho a cada proveedor
SELECT SupplierID, 
COUNT(DISTINCT UnitsOnOrder) AS Ordenes
FROM Products
WHERE UnitsOnOrder > 0
GROUP BY SupplierID
ORDER BY Ordenes DESC

--4. ¿Cuánto dinero hemos pagado a cada proveedor por los productos de las ordenes? (estan en camino las unidades
SELECT SupplierID, 
SUM(UnitPrice*UnitsOnOrder) AS Total
FROM Products
GROUP BY SupplierID
ORDER BY Total DESC

--5. ¿Cuántas categorías de productos tenemos?*
SELECT COUNT(DISTINCT CategoryID)
FROM Categories

--6. ¿Cuántos productos diferentes tenemos por categoría?
SELECT CategoryID, 
COUNT(ProductID) AS Total
FROM Products
GROUP BY CategoryID
ORDER BY Total ASC

/*7. Se necesita saber cuánto dinero tenemos en stock por cada categoría y por proveedor, mostrar el resultado primero todo por la categoría uno y después todo por la 
categoría dos así hasta la categoría 8*/
SELECT CategoryID, SupplierID, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY CategoryID, SupplierID
ORDER BY CategoryID, SupplierID ASC

/*8. Se necesita un reporte para saber por categoría el total de los niveles mínimos para re ordenar más producto, En otras palabras, de que categoría debemos tener 
niveles altos de stock*/
SELECT CategoryID, 
SUM(ReorderLevel) AS Total
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID, Total ASC

--9. De la Pregunta 7 ahora solo se requiere reportar aquellos resultados donde el dinero en stock sea mayor a 3 mil dólares.
SELECT CategoryID, SupplierID, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY CategoryID, SupplierID
HAVING SUM(UnitPrice*UnitsInStock) > 3000
ORDER BY CategoryID ASC

--10. De la pregunta 6
--a. Ahora también se requiere saber el dinero en stock, Primer reporte
SELECT CategoryID, 
COUNT(UnitsInStock) AS Productos, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID, Productos, Total ASC

--b. El segundo reporte solo se quiere los registros donde la categoría tiene más de 7 productos.
SELECT CategoryID, 
COUNT(UnitsInStock) AS Productos, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY CategoryID
HAVING COUNT(UnitsInStock) > 7
ORDER BY Productos ASC

--c. Tercer reporte, todo lo anterior pero donde el dinero en Stock es más de 11 mil dólares.
SELECT CategoryID, 
COUNT(UnitsInStock) AS Productos, 
SUM(UnitPrice*UnitsInStock) AS Total
FROM Products
GROUP BY CategoryID
HAVING COUNT(UnitsInStock) > 7
AND SUM(UnitPrice*UnitsInStock) > 11000
ORDER BY Productos ASC

--11. Un reporte por empleado del total de ordenes atendidas, desglosado por número de órdenes y tipo de envió, pero solo de las ordenes que superen las 30
SELECT EmployeeID, ShipVia, COUNT(OrderID)
AS Conteo
FROM Orders
GROUP BY ShipVia, EmployeeID
HAVING COUNT(OrderID) > 30
ORDER BY ShipVia, EmployeeID ASC

/*12. En algunas ordenes ciertos productos tienen descuento, generar un reporte que muestre el subtotal a pagar de cada orden (el subtotal es el precio total sin aplicar 
descuento), el total a pagar (total es el precio final ya con el descuento aplicado), el descuento aplicado (cuánto dinero se descontó), Todo lo anterior solo para las 
ordenes donde el descuento (dinero ahorrado) no supere el 20% de la venta del subtotal*/
SELECT OrderID, 
SUM(UnitPrice*Quantity) AS Subtotal,
SUM(UnitPrice*Quantity*Discount) AS Descuento, 
SUM(UnitPrice*Quantity) - SUM(UnitPrice*Quantity*Discount) AS Total,
(SUM(UnitPrice*Quantity)*0.20) AS DescuentoDelVeinte  
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(UnitPrice*Quantity*Discount) <= SUM((UnitPrice*Quantity) * 0.20)
ORDER BY Total DESC

--a. Agregar la restricción “Y ahora además que las ordenes tengan al menos un producto con descuento”
SELECT OrderID, SUM(UnitPrice*Quantity) AS Subtotal, 
SUM(UnitPrice*Quantity*Discount) AS Descuento,
SUM(UnitPrice*Quantity) - SUM(UnitPrice*Quantity*Discount)  AS Total,
SUM((UnitPrice*Quantity)*0.20) AS VeintePorCiento
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(UnitPrice*Quantity*Discount) <= SUM((UnitPrice*Quantity)*0.20)
AND SUM(UnitPrice*Quantity*Discount) >= 1
ORDER BY SUM(UnitPrice*Quantity) - SUM(UnitPrice*Discount*Quantity) DESC
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Solucion_EjerciciosJoins_COD04  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Se requiere mostrar las ordenes con los productos que contiene cada orden, se debe mostrar el id de la orden, el descuento de producto, nombre del producto
SELECT OD.OrderID, OD.ProductID, OD.UnitPrice, OD.Quantity, OD. Discount, P.ProductName 
FROM [Order Details] OD
INNER JOIN Products P
ON (OD.ProductID = P.ProductID)

--2. Mostrar que productos provee cada compañía, mostrar producto y nombre de la compañía, ordenar por nombre de compañía.
SELECT P.ProductName, S.CompanyName
FROM Products P
INNER JOIN Suppliers S
ON (P.SupplierID = S.SupplierID)
ORDER BY CompanyName ASC

--3. Calcular el dinero que tenemos en stock por cada proveedor, mostrar la cantidad de dinero y el nombre de la compañía.
SELECT SUM(UnitPrice*UnitsInStock), S.CompanyName
FROM Products P
INNER JOIN Suppliers S
ON (P.SupplierID = S.SupplierID)
GROUP BY CompanyName
ORDER BY CompanyName ASC

--4. Se requiere saber la descripción de la categoría de cada producto que se encuentraen los detalles de orden.
SELECT C.Description, P.ProductName, OD.OrderID
FROM Products P
INNER JOIN Categories C
ON (C.CategoryID = P.CategoryID)
INNER JOIN [Order Details] OD
ON (OD.ProductID = P.ProductID)

--5. Calcular el total de dinero por ventas hechas a cada país
SELECT ShipCountry, SUM(UnitPrice*Quantity)
FROM Orders O
INNER JOIN [Order Details] OD
ON (OD.OrderID = O.OrderID)
GROUP BY ShipCountry

--a. ¿Cuál es el país en donde se ha vendido más?
SELECT ShipCountry, SUM(UnitPrice*Quantity) AS Total
FROM Orders O
INNER JOIN [Order Details] OD
ON (OD.OrderID = O.OrderID)
GROUP BY ShipCountry
ORDER BY Total DESC

--b. ¿México qué lugar ocupa?
SELECT ShipCountry, SUM(UnitPrice*Quantity) AS Total
FROM Orders O
INNER JOIN [Order Details] OD
ON (OD.OrderID = O.OrderID)
GROUP BY ShipCountry
ORDER BY Total DESC

/*6. Se cometió un error por un empleado y algunos precios no son los correctos en los detalles de las ordenes, el precio por unidad en el detalle de las ordenes debe 
coincidir con el precio unitario de los productos. Determinar en qué ordenes el precio por unidad no coincide, Dar una posible explicación.*/
--a. ¿En cuantas ordenes se cometió el error de precios?
SELECT OD.OrderID, OD.ProductID, OD.UnitPrice, P.ProductID, P.UnitPrice
FROM Products P
INNER JOIN [Order Details] OD
ON (OD.ProductID = P.ProductID)
WHERE P.UnitPrice <> OD.UnitPrice

--b ¿Cuántos errores se cometieron por orden?
SELECT COUNT(OD.OrderID)
FROM Products P
INNER JOIN [Order Details] OD
ON (OD.ProductID = P.ProductID)
WHERE P.UnitPrice <> OD.UnitPrice
GROUP BY OrderID

/*7. Listar los proveedores (nombre del proveedor) dependiendo de que proveedor vendemos más producto hemos vendido (más unidades, no tipos de productos) ordenarlo de 
mayor a menor*/
SELECT S.CompanyName, SUM(Quantity) AS Total
FROM Suppliers S
INNER JOIN Products P
ON S.SupplierID = P.SupplierID
INNER JOIN [Order Details] OD
ON OD.ProductID = P.ProductID
GROUP BY CompanyName
ORDER BY Total DESC

-- 8. Suponiendo que ya se ha encontrado el problema del ejercicio 6 ahora se debe determinar cuánto dinero estamos perdiendo en cada orden, ordenar por mayor perdida
SELECT OD.OrderID, 
SUM(OD.UnitPrice*Quantity) AS Real, 
SUM(P.UnitPrice*Quantity) AS Normal, 
(SUM(OD.UnitPrice*Quantity) - SUM(P.UnitPrice*Quantity))AS Perdida
FROM Products P
INNER JOIN [Order Details] OD
ON (OD.ProductID = P.ProductID)
WHERE P.UnitPrice <> OD.UnitPrice
GROUP BY OrderID
ORDER BY Perdida ASC

-- 9.  Listar cuantos productos se han vendido por país
SELECT ShipCountry, COUNT(ProductID) AS VENDIDO
FROM [Order Details] OD
INNER JOIN Orders O
ON (OD.OrderID = O.OrderID)
GROUP BY ShipCountry
ORDER BY VENDIDO DESC

--10. Listar cuantos productos diferentes se venden por país(o se han vendido)
SELECT ShipCountry,COUNT(DISTINCT ProductID) AS PRODUCTOS
FROM [Order Details] OD
INNER JOIN Orders O
ON (OD.OrderID = O.OrderID)
GROUP BY ShipCountry
ORDER BY PRODUCTOS DESC

-- 11. Listar el nombre y cantidad del producto menos vendido por país.
SELECT P.ProductName, ShipCountry, SUM(OD.Quantity) AS VENDIDO
FROM Products P
INNER JOIN [Order Details] OD
ON (P.ProductID = OD.ProductID)
INNER JOIN Orders O
ON (OD.OrderID = O.OrderID)
GROUP BY ProductName, ShipCountry
ORDER BY VENDIDO ASC
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Joins2COD05  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Mostrar el precio máximo y precio mínimo de cada categoría, se debe mostrar el nombre de la categoría.
SELECT CategoryName, MAX(UnitPrice) AS MAXIMO,
MIN(UnitPrice) AS MIN
FROM Products P
INNER JOIN Categories C
ON (P.CategoryID = C.CategoryID)
GROUP BY CategoryName
ORDER BY CategoryName ASC

--2. Listar el apellido de los trabajadores y el número de órdenes que ha despachado.
SELECT E.EmployeeID, LastName, COUNT(OrderID) AS DESPACHO
FROM Employees E
INNER JOIN Orders O
ON (E.EmployeeID = O.EmployeeID)
GROUP BY E.EmployeeID, LastName

--a. ¿Que trabajador es el más flojo?
SELECT E.EmployeeID, LastName, COUNT(OrderID) AS DESPACHO
FROM Employees E
INNER JOIN Orders O
ON (E.EmployeeID = O.EmployeeID)
GROUP BY E.EmployeeID, LastName
ORDER BY DESPACHO ASC

--b. ¿Suyama que lugar ocupa?
SELECT E.EmployeeID, LastName, COUNT(OrderID) AS DESPACHO
FROM Employees E
INNER JOIN Orders O
ON (E.EmployeeID = O.EmployeeID)
GROUP BY E.EmployeeID, LastName
ORDER BY DESPACHO ASC

--3. Mostrar el nombre de la compañía y el total de productos que nos han comprados 
SELECT CompanyName, SUM(Quantity) AS COMPRADO
FROM Customers c
INNER JOIN Orders O
ON (C.CustomerID = O.CustomerID)
INNER JOIN [Order Details] OD
ON (O.OrderID = OD.OrderID)
GROUP BY CompanyName

--a. ¿Qué compañía es la que más productos ha Comprado?
SELECT CompanyName, SUM(Quantity) AS COMPRADO
FROM Customers c
INNER JOIN Orders O
ON (C.CustomerID = O.CustomerID)
INNER JOIN [Order Details] OD
ON (O.OrderID = OD.OrderID)
GROUP BY CompanyName
ORDER BY COMPRADO DESC

--b. ¿Qué lugar ocupa “Tortuga Restaurante” 39
SELECT CompanyName, SUM(Quantity) AS COMPRADO
FROM Customers c
INNER JOIN Orders O
ON (C.CustomerID = O.CustomerID)
INNER JOIN [Order Details] OD
ON (O.OrderID = OD.OrderID)
GROUP BY CompanyName
ORDER BY COMPRADO DESC

/*4. Listar todos los clientes registrados en nuestra base de datos, (ID del cliente, nombre de la compañía), junto con todas las ordenes que nos han realizado, 
mostrar el cliente incluso si no ha realizado ningún pedido.*/
SELECT C.CustomerID, CompanyName, O.OrderID
FROM Customers C
LEFT JOIN Orders O 
ON C.CustomerID = O.CustomerID
ORDER BY CompanyName


--5. ¿Todos los pedidos u órdenes tienen asignado un cliente? Confirmarlo con una consulta SQL y explicarlo.
SELECT COUNT(*) AS PedidosSinCliente
FROM Orders
WHERE CustomerID IS NULL

--a. Si existe clientes sin haber realizado pedidos, ahora mostrar esos registros.
SELECT C.CustomerID
FROM Customers C
LEFT JOIN Orders O
ON (O.CustomerID = C.CustomerID)
WHERE O.OrderID IS NULL

/*6. Como ya se sabe se cometió un error por un empleado y algunos precios no son los correctos, Listar las perdidas por empleado, mostrar ID empleado, Primer Nombre,
Venta normal, venta real, perdidas y también el nombre del jefe del empleado y su id*/
SELECT E.EmployeeID, E.FirstName, J.EmployeeID AS JEFE, J.FIRSTNAME AS NOMBRE, 
SUM(OD.UnitPrice*Quantity)AS NORMAL,
SUM(P.UnitPrice*Quantity) AS REAL,
SUM(OD.UnitPrice*Quantity) - SUM(P.UnitPrice*Quantity) AS PERDIDA
FROM Employees E
INNER JOIN Orders O
ON (E.EmployeeID = O.EmployeeID)
INNER JOIN [Order Details] OD
ON (O.OrderID = OD.OrderID)
INNER JOIN Products P
ON (OD.ProductID = P.ProductID)
LEFT JOIN Employees J
ON (E.ReportsTo = J.EmployeeID)
GROUP BY E.EmployeeID, E.FirstName, J.EmployeeID, J.FirstName
ORDER BY NOMBRE DESC
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Solucion_ejerciciosUlt_SubConsultasCOD01  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Listar el nombre de los productos para los cuales la categoría a la que pertenecen tiene más de 350 unidades en Stock.
SELECT * FROM Products
	WHERE CategoryID IN(SELECT CategoryID
	FROM Products 
	GROUP BY CategoryID
	HAVING SUM(UnitsInStock) >350)

--2. Listar toda la información para los productos donde para su categoría el dinero que se tienen en stock esta entre 3500 y 4000 dólares.
	SELECT * FROM Products
	WHERE CategoryID IN(SELECT CategoryID
	FROM Products 
	GROUP BY CategoryID
	HAVING SUM(UnitPrice*UnitsInStock) BETWEEN 3500 AND 4000)

--a. El nombre de las categorías que cumplen lo anterior (Sin usar JOINS)
	SELECT CategoryID,  CategoryName FROM Categories
	WHERE CategoryID IN(SELECT CategoryID
	FROM Products 
	GROUP BY CategoryID
	HAVING SUM(UnitPrice*UnitsInStock) BETWEEN 3500 AND 4000)

--b. Mostrar ahora el nombre de las categorías y además el dinero en stock de cada categoría.
SELECT C.CategoryID, 
       C.CategoryName,
       (SELECT SUM(P.UnitPrice * P.UnitsInStock)
        FROM Products P
        WHERE P.CategoryID = C.CategoryID) AS DineroEnStock
FROM Categories C
WHERE C.CategoryID IN (
    SELECT CategoryID
    FROM Products
    GROUP BY CategoryID
    HAVING SUM(UnitPrice * UnitsInStock) BETWEEN 3500 AND 4000
)

--c. Todo lo anterior pero ahora para el proveedor.
SELECT S.SupplierID, 
       S.CompanyName,
       (SELECT SUM(P.UnitPrice * P.UnitsInStock)
        FROM Products P
        WHERE P.SupplierID = S.SupplierID) AS DineroEnStock
FROM Suppliers S
WHERE S.SupplierID IN (
    SELECT SupplierID
    FROM Products
    GROUP BY SupplierID
    HAVING SUM(UnitPrice * UnitsInStock) BETWEEN 3500 AND 4000
)

--3. Que categorías son las que su promedio de dinero en stock es mayor al promedio general de dinero en stock.
	SELECT CategoryID, Promedio FROM 
		(SELECT CategoryID, AVG(UnitsInStock*UnitPrice) AS Promedio 
		FROM Products
		GROUP BY CategoryID) AS Promedios
		WHERE Promedio > (SELECT AVG(UnitPrice*UnitsInStock)
		FROM Products)

--4. Las categorías sdonde el promedio de todo lo ordenado (lo que viene en camino) supera el 10% de las unidades que se tiene en stock por categoría.
SELECT CategoryID, SUM(UnitsInStock) AS TOTAL
FROM Products
GROUP BY CategoryID
HAVING SUM(UnitsInStock)*0.1 <=(
SELECT AVG(UnitsOnOrder)
FROM Products
WHERE UnitsOnOrder<>0)

/*5. Listar toda la información de los productos suministrados por los proveedores a los cuales no se les ha pedido nuevamente ninguna orden de ningún 
producto.*/
SELECT * 
FROM Products
WHERE SupplierID IN(
SELECT SupplierID
FROM Products 
GROUP BY SupplierID
HAVING SUM(UnitsOnOrder) = 0)

/*6. Agregar una columna temporal “Venta” que es el precio de venta final al cual se le debe ganar el 50% del precio unitario de compra, lo anterior solo
aplica para los productos de la categoría con el precio más bajo*/
SELECT *, UnitPrice * 1.5 AS Venta
FROM Products
WHERE CategoryID = (
SELECT TOP 1 CategoryID 
FROM Products 
ORDER BY UnitPrice ASC)
ORDER BY ProductID;

/*a. Los proveedores donde las unidades que se tienen en Stock por cada uno de los proveedores son menores a las unidades totales que se tiene en stock por
categoría.*/
WITH CategoryStock AS (
SELECT CategoryID, SUM(UnitsInStock) AS TotalUnitsInStock
FROM Products 
GROUP BY CategoryID
)
SELECT  p.SupplierID, SUM(p.UnitsInStock) AS UnitsInStockSupplier
FROM Products p
JOIN  CategoryStock cs 
ON p.CategoryID = cs.CategoryID
GROUP BY p.SupplierID
HAVING SUM(p.UnitsInStock) < MAX(cs.TotalUnitsInStock)
ORDER BY p.SupplierID

/*7. ¿De qué Proveedor tenemos más dinero en almacén? Listar también el dinero. Un solo registro. (No se puede usar TOP ni LIMIT ROW etc.)*/
SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS TOTAL
FROM Products
WHERE SupplierID = (
SELECT SupplierID
FROM Products
WHERE UnitPrice =(
SELECT MAX(UnitPrice)
FROM Products
))
GROUP BY SupplierID

/*8. Listar todos los productos que son igual o más caros que cada uno de los productos de la categoría 4 y 2.*/
SELECT * 
FROM Products
WHERE UnitPrice >=(
SELECT MAX(UnitPrice)
FROM Products 
WHERE CategoryID IN (2,4))

/*9. Listar todos los productos donde al menos un producto de cada categoría es mayor a algún producto de la categoría 4 y 2.*/
SELECT * 
FROM Products
WHERE UnitPrice >= SOME(
SELECT (UnitPrice)
FROM Products 
WHERE CategoryID IN (2,4))

--Para el ejercicio 8 y 9 se debe explicar el resultado y la lógica de la consulta
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Procedimientos Almacenados  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--1. Crear un SP para cambiar el Stock de un producto EXEC SP_cambiarStock (ID_Producto,NuevoStock)
CREATE PROCEDURE SP_cambiarStock
    @ID_Producto INT,
    @NuevoStock INT
AS
BEGIN
    UPDATE Products
    SET UnitsInStock = @NuevoStock
    WHERE ProductID = @ID_Producto
END

/*2. Crear un SP que muestre todo sobre un producto que busque un cliente Nota: el cliente puede ingresar parte del nombre del producto, en otras palabra mostrar todo lo 
que coincida con lo ingresado por el cliente. EXEC SP_ListarProducto(NombreProducto)*/
CREATE PROCEDURE SP_ListarProducto
    @NombreProducto NVARCHAR(40)
AS
BEGIN
    SELECT * FROM Products
    WHERE ProductName LIKE '%' + @NombreProducto + '%'
END

--3. Mostrar cuantas ordenes a realizado cada empleado(mostrar nombre, apellidos y número de pedidos) que sean mayores al parámetro indicado. EXEC SP_NumOrdenesEmpleado(15)
CREATE PROCEDURE SP_NumOrdenesEmpleado
    @MinOrdenes INT
AS
BEGIN
    SELECT E.FirstName, E.LastName, COUNT(O.OrderID) AS NumeroPedidos
    FROM Employees E
    JOIN Orders O ON E.EmployeeID = O.EmployeeID
    GROUP BY E.FirstName, E.LastName
    HAVING COUNT(O.OrderID) > @MinOrdenes
END

/*4. Crear un SP que me liste el nombre y el dinero generado de los productos más vendidos ,parámetros (el año y el número de registros que quiero mostrar), (los primeros 5
registros o los primeros 10 registros) EXEC SP_monto_vendido 1998,3 NOTA* En el ejercico 4 usar top*/
CREATE PROCEDURE SP_monto_vendido
    @Anio INT,
    @Cantidad INT
AS
BEGIN
    SELECT TOP (@Cantidad) P.ProductName,
           SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS MontoVendido
    FROM [Order Details] OD
    JOIN Orders O ON OD.OrderID = O.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE YEAR(O.OrderDate) = @Anio
    GROUP BY P.ProductName
    ORDER BY MontoVendido DESC
END

--5. Crear un SP que me regrese el segundo país que más nos ha comprado NOTA* No se puede usar TOP, NI RANK, NI WITH, NI OVER. EXEC SP_SegundoLugar
CREATE PROCEDURE SP_SegundoLugar
AS
BEGIN
    SELECT Country
    FROM (
        SELECT C.Country,
               SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS TotalComprado
        FROM Customers C
        JOIN Orders O ON C.CustomerID = O.CustomerID
        JOIN [Order Details] OD ON O.OrderID = OD.OrderID
        GROUP BY C.Country
    ) AS T
    WHERE TotalComprado < (
        SELECT MAX(TotalComprado)
        FROM (
            SELECT SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS TotalComprado
            FROM Customers C
            JOIN Orders O ON C.CustomerID = O.CustomerID
            JOIN [Order Details] OD ON O.OrderID = OD.OrderID
            GROUP BY C.Country
        ) AS X
    )
    AND TotalComprado >= ALL (
        SELECT SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount))
        FROM Customers C
        JOIN Orders O ON C.CustomerID = O.CustomerID
        JOIN [Order Details] OD ON O.OrderID = OD.OrderID
        GROUP BY C.Country
        HAVING SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) <
        (
            SELECT MAX(TotalComprado)
            FROM (
                SELECT SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS TotalComprado
                FROM Customers C
                JOIN Orders O ON C.CustomerID = O.CustomerID
                JOIN [Order Details] OD ON O.OrderID = OD.OrderID
                GROUP BY C.Country
            ) AS X
        )
    )
END
/*______________________________________________________________________________________________________________________________________________________________________*/


/*______________________________________________________________________________________________________________________________________________________________________*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   Disparadores  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*1. Crear un disparador que me indique si al generar una nueva orden(venta) las unidades que estoy vendiendo no superen las unidades en stock y si tengo unidades en stock
disminuir mi stock dependiendo de lo que he vendido en dicha orden.*/
CREATE TRIGGER trg_validar_stock_venta
ON [Order Details]
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN Products P ON I.ProductID = P.ProductID
        WHERE I.Quantity > P.UnitsInStock
    )
    BEGIN
        RAISERROR('No hay suficiente stock disponible.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE P
    SET P.UnitsInStock = P.UnitsInStock - I.Quantity
    FROM Products P
    JOIN INSERTED I ON P.ProductID = I.ProductID
END

/*2. Crear un disparador que solo cuando NO exista cantidad suficiente el stock agregue el id del producto y nombre y la cantidad que falta en una nueva tabla 
(StockDiferencia).*/
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

/*3. Crear un disparador para cuando un usuario devuelva un producto restablecer el stock en almacén y además en una nueva tabla agregue Id del comprador, id deL producto
devuelto, cantidad devuelta, de que orden es y que dinero se debe rembolsar*/
-- 3. Devolución: restablecer stock y registrar en tabla de devoluciones
CREATE TRIGGER trg_devolucion
ON Devoluciones
AFTER INSERT
AS
BEGIN
    -- Restablecer stock
    UPDATE P
    SET P.UnitsInStock = P.UnitsInStock + D.CantidadDevuelta
    FROM Products P
    JOIN INSERTED D ON P.ProductID = D.ProductID

    -- Registrar en tabla de rembolsos
    INSERT INTO Rembolsos (CustomerID, ProductID, CantidadDevuelta, OrderID, DineroAReembolsar)
    SELECT D.CustomerID, D.ProductID, D.CantidadDevuelta, D.OrderID,
           D.CantidadDevuelta * OD.UnitPrice * (1 - OD.Discount)
    FROM INSERTED D
    JOIN [Order Details] OD ON D.OrderID = OD.OrderID AND D.ProductID = OD.ProductID
END

/*______________________________________________________________________________________________________________________________________________________________________*/