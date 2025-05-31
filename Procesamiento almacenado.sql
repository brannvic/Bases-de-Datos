CREATE OR ALTER PROCEDURE ProductosPorCategoria
@CategoryID INT
AS
BEGIN
SELECT ProductName, UnitPrice
FROM Products
WHERE CategoryID = @CategoryID
ORDER BY UnitPrice DESC
END

EXEC ProductosPorCategoria @CategoryID = 1;