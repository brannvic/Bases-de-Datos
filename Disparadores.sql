--Copiar la tabla
SELECT *
INTO ProductsEjercicios 
FROM Products

--Ver que la copiamos bien
SELECT *
FROM ProductsEjercicios

IF OBJECT_ID('StockLog') IS NULL
BEGIN
CREATE TABLE StockLog(
LOGID INT IDENTITY (1,1) PRIMARY KEY,
ProductID INT NOT NULL,
Change INT NOT NULL,
ChangeDate DATETIME DEFAULT GETDATE()
)
END;

--se simula una venta 
BEGIN TRANSACTION;
BEGIN TRY
IF EXISTS (
SELECT * FROM ProductsEjercicios
WHERE ProductID = 1 
AND UnitsInStock >= 10
)
BEGIN
--Reducimos el stock del producto con ProductID=1
UPDATE ProductsEjercicios
SET UnitsInStock = UnitsInStock - 10
WHERE ProductID = 1;

INSERT INTO StockLog (ProductID, Change, ChangeDate)
VALUES (1, -10, GETDATE());

	COMMIT;
	PRINT 'Transaccion completada exitosamente'
END
ELSE
BEGIN
	ROLLBACK;
PRINT 'Stock insuficiente'
END
END TRY
BEGIN CATCH
ROLLBACK
PRINT 'Error detectado, transacción revertida'
PRINT ERROR_MESSAGE();
END CATCH;

SELECT *
INTO Copia_Orders
FROM [Order Details]

SELECT *
FROM Copia_Orders
INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10247, 2, 201, 31, 1);

CREATE OR ALTER TRIGGER trg_CheckStock_OnOrderDetailsInsert
ON Copia_Orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si hay productos con stock insuficiente
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN ProductsEjercicios p ON i.ProductID = p.ProductID
        WHERE p.UnitsInStock < i.Quantity
    )
    BEGIN
        -- Mostrar mensaje de error y revertir la transacción
        RAISERROR('Stock insuficiente para uno o más productos en la orden.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Si todo está bien, actualizar el stock
    UPDATE p
    SET p.UnitsInStock = p.UnitsInStock - i.Quantity
    FROM ProductsEjercicios p
    INNER JOIN inserted i ON i.ProductID = p.ProductID;
    
    -- Registrar el cambio en el log de stock
    INSERT INTO StockLog (ProductID, Change, ChangeDate)
    SELECT ProductID, -Quantity, GETDATE()
    FROM inserted;
END;

-- Prueba con stock suficiente (debe funcionar)
INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10247, 1, 18.00, 5, 0);

-- Verificar que el stock se redujo
SELECT ProductID, UnitsInStock FROM ProductsEjercicios WHERE ProductID = 1;

-- Verificar que se registró en el log
SELECT * FROM StockLog;

-- Prueba con stock insuficiente (debe fallar)
INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10247, 1, 18.00, 1000, 0);

-- Verifica si ya tiene clave primaria
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockDiferencia')
BEGIN
    CREATE TABLE StockDiferencia (
        DiferenciaID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(100) NOT NULL,
        CantidadFaltante INT NOT NULL,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_StockDiferencia_ProductsEjercicios 
        FOREIGN KEY (ProductID) REFERENCES ProductsEjercicios(ProductID)
    );
END



-- 1. Verificar que la tabla StockDiferencia existe y está vacía
IF OBJECT_ID('StockDiferencia') IS NULL
BEGIN
    CREATE TABLE StockDiferencia (
        DiferenciaID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(100) NOT NULL,
        CantidadFaltante INT NOT NULL,
        FechaRegistro DATETIME DEFAULT GETDATE()
    );
END
ELSE
BEGIN
    TRUNCATE TABLE StockDiferencia;
END

-- 2. Verificar datos de productos clave
SELECT ProductID, ProductName, UnitsInStock 
FROM ProductsEjercicios 
WHERE ProductID IN (1, 2, 3);


CREATE OR ALTER TRIGGER trg_StockControl_Final
ON Copia_Orders
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Registrar primero en StockDiferencia (esto garantiza que se guarde antes del ROLLBACK)
    INSERT INTO StockDiferencia (ProductID, ProductName, CantidadFaltante)
    SELECT 
        p.ProductID, 
        p.ProductName, 
        (i.Quantity - p.UnitsInStock) AS CantidadFaltante
    FROM inserted i
    JOIN ProductsEjercicios p ON i.ProductID = p.ProductID
    WHERE p.UnitsInStock < i.Quantity;
    
    -- Verificar si hubo productos con stock insuficiente
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN ProductsEjercicios p ON i.ProductID = p.ProductID
        WHERE p.UnitsInStock < i.Quantity
    )
    BEGIN
        -- Generar mensaje de error
        DECLARE @errorMsg NVARCHAR(MAX) = 'Productos con stock insuficiente:';
        SELECT @errorMsg = @errorMsg + CHAR(13) + CHAR(10) + 
                         '• ' + p.ProductName + ' (ID:' + CAST(p.ProductID AS VARCHAR) + 
                         '), Faltan ' + CAST((i.Quantity - p.UnitsInStock) AS VARCHAR) + ' unidades'
        FROM inserted i
        JOIN ProductsEjercicios p ON i.ProductID = p.ProductID
        WHERE p.UnitsInStock < i.Quantity;
        
        RAISERROR(@errorMsg, 16, 1);
        RETURN;
    END
    
    -- Si todo está bien, procesar la orden
    INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
    SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
    FROM inserted;
    
    -- Actualizar stock
    UPDATE p
    SET UnitsInStock = UnitsInStock - i.Quantity
    FROM ProductsEjercicios p
    JOIN inserted i ON p.ProductID = i.ProductID;
    
    -- Registrar en log de stock
    INSERT INTO StockLog (ProductID, Change, ChangeDate)
    SELECT ProductID, -Quantity, GETDATE()
    FROM inserted;
END;


-- 1. Insertar orden con stock insuficiente (debe registrar en StockDiferencia)
INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10292, 1, 18.00, 1000, 0);

-- 2. Verificar registro en StockDiferencia (DEBE aparecer)
SELECT * FROM StockDiferencia;

-- 3. Verificar que NO se insertó en Copia_Orders
SELECT * FROM Copia_Orders WHERE OrderID = 10290;

-- 4. Insertar orden válida
INSERT INTO Copia_Orders (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10291, 1, 18.00, 5, 0);

-- 5. Verificar que SÍ se insertó en Copia_Orders
SELECT * FROM Copia_Orders WHERE OrderID = 10291;

-- 6. Verificar que NO hay nuevos registros en StockDiferencia
SELECT * FROM StockDiferencia;