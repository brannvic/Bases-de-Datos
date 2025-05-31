--CREACIÓN DE TABLAS
CREATE TABLE Camion (
    Placa VARCHAR(7) PRIMARY KEY,
    CargaMaxima DECIMAL(10,2) NOT NULL CHECK (CargaMaxima > 0),
    CiudadResguardo VARCHAR(70) NOT NULL
);

CREATE TABLE Conductor (
    RFC VARCHAR(13) PRIMARY KEY,
    Nombre VARCHAR(70) NOT NULL,
    Direccion VARCHAR(255) NOT NULL
);

--PRIMER RUTA
CREATE TABLE Ruta_C (
    RFC_FK VARCHAR(13) NOT NULL,
    Ruta NUMERIC(10) NOT NULL,
    FOREIGN KEY (RFC_FK) REFERENCES Conductor(RFC) ON DELETE CASCADE
);

CREATE TABLE C_Local (
    Codigo INT PRIMARY KEY,
    Nombre VARCHAR(70) NOT NULL
);

CREATE TABLE Paquete (
    Codigo INT PRIMARY KEY,
    Destinatario VARCHAR(70) NOT NULL,
    Peso DECIMAL(10,2) NOT NULL CHECK (Peso > 0),
    Direccion VARCHAR(255) NOT NULL
);

CREATE TABLE Internacional (
    LineaAerea VARCHAR(70) NOT NULL,
    CodigoLocal_FK INT NOT NULL,
    F_Entrega DATE NOT NULL,
    CodigoPaquete_FK INT NOT NULL,
    FOREIGN KEY (CodigoLocal_FK) REFERENCES C_Local(Codigo),
    FOREIGN KEY (CodigoPaquete_FK) REFERENCES Paquete(Codigo)
);

CREATE TABLE Nacional (
    CiudadDestino VARCHAR(70) NOT NULL,
    CodigoPaquete_FK INT NOT NULL,
    RFC_FK VARCHAR(13) NOT NULL,
    FOREIGN KEY (RFC_FK) REFERENCES Conductor(RFC),
    FOREIGN KEY (CodigoPaquete_FK) REFERENCES Paquete(Codigo)
);

--SEGUNDA RUTA
CREATE TABLE Ruta_N (
    Ruta NUMERIC(10) NOT NULL,
    CodigoPaquete_FK INT NOT NULL,
    FOREIGN KEY (CodigoPaquete_FK) REFERENCES Paquete(Codigo)
);

--TABLA RELACION
CREATE TABLE Conduce (
    Fecha DATE NOT NULL,
    RFC_FK VARCHAR(13),
    Placa_FK VARCHAR(7),
    PRIMARY KEY (RFC_FK, Placa_FK),
    FOREIGN KEY (RFC_FK) REFERENCES Conductor(RFC) ON DELETE CASCADE,
    FOREIGN KEY (Placa_FK) REFERENCES Camion(Placa) ON DELETE CASCADE
);

--INSERCIÓN DE DATOS (MÍNIMO 4 POR TABLA)
INSERT INTO Camion VALUES 
    ('MUS123', 5000, 'CDMX'),
    ('MDF456', 7000, 'Guadalajara'),
    ('QWE789', 6000, 'Monterrey'),
    ('CAS012', 8000, 'Puebla');

INSERT INTO Conductor VALUES 
    ('RFC001', 'Abraham Pérez', 'Puente Rojo #12'),
    ('RFC002', 'Ana Guadarrama', 'Pablo Neruda #456'),
    ('RFC003', 'Carlos Aragon', 'Republica de Bolivia #789'),
    ('RFC004', 'Viridiana Badillo', 'Norte 33 #101');

INSERT INTO Ruta_C VALUES 
    ('RFC001', 1),
    ('RFC002', 2),
    ('RFC003', 3),
    ('RFC004', 4);

INSERT INTO C_Local VALUES 
    (1, 'Sucursal Centro'),
    (2, 'Sucursal Norte'),
    (3, 'Sucursal Sur'),
    (4, 'Sucursal Oeste');

INSERT INTO Paquete VALUES 
    (101, 'Cesar López', 2.5, 'Av. del Taller 742'),
    (102, 'Eric Ramírez', 5.0, 'Dr Galvez 123'),
    (103, 'Mario Morales', 3.2, 'Reforma 222'),
    (104, 'Samantha Castillo', 4.8, 'Circuito Interior 789');

INSERT INTO Internacional VALUES 
    ('AeroMéxico', 1, '2025-04-21', 101),
    ('American Airlines', 2, '2025-10-03', 102),
    ('Delta', 3, '2025-04-14', 103),
    ('Volaris', 4, '2025-03-21', 104);

INSERT INTO Nacional VALUES 
    ('Tijuana', 101, 'RFC001'),
    ('Querétaro', 102, 'RFC002'),
    ('La Paz', 103, 'RFC003'),
    ('Cancún', 104, 'RFC004');

INSERT INTO Ruta_N VALUES 
    (1, 101),
    (2, 102),
    (3, 103),
    (4, 104);

INSERT INTO Conduce VALUES 
    ('2025-03-24', 'RFC001', 'MUS123'),
    ('2025-03-25', 'RFC002', 'MDF456'),
    ('2025-03-26', 'RFC003', 'QWE789'),
    ('2025-03-27', 'RFC004', 'CAS012');

--ELIMINAR LAS TABLAS SI EXISTEN
DROP TABLE IF EXISTS Conduce;
DROP TABLE IF EXISTS Ruta_N;
DROP TABLE IF EXISTS Nacional;
DROP TABLE IF EXISTS Internacional;
DROP TABLE IF EXISTS C_Local;
DROP TABLE IF EXISTS Ruta_C;
DROP TABLE IF EXISTS Conductor;
DROP TABLE IF EXISTS Camion;
DROP TABLE IF EXISTS Paquete;