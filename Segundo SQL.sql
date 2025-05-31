CREATE TABLE Empleado(
DNI INT PRIMARY KEY,
FechaNAC_Empleado DATE,
Sueldo DECIMAL (10,2),
Sexo VarChar (20),
Nombre Varchar (20),
Apellido1 Varchar (20),
Apellido2 Varchar (20),
DNI_Supervisor INT, 
FOREIGN KEY (DNI_Supervisor) REFERENCES Empleado(DNI)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
);

CREATE TABLE Departamento(
Nombre_Dpto Varchar (50),
Numero_Dpto Varchar (50),
Ubicacion Varchar (50),
Fecha_Inicio DATE,
N_Empleados INT,
DNI INT,
FOREIGN KEY (DNI) REFERENCES Empleado(DNI) 
	ON DELETE CASCADE
	ON UPDATE CASCADE,
CONSTRAINT Pk_Dpto PRIMARY KEY (Nombre_Dpto, Numero_Dpto)
);


CREATE TABLE Ubicaciones_Dpto(
Ubicacion Varchar (50),
Nombre_Dpto Varchar (50),
Numero_Dpto Varchar (50),
FOREIGN KEY (Nombre_Dpto, Numero_Dpto) REFERENCES Departamento(Nombre_Dpto, Numero_Dpto) 
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
);

CREATE TABLE Proyecto(
Nombre_Pyto Varchar (50),
Numero_Pyto Varchar (50),
Nombre_Dpto Varchar (50),
Numero_Dpto Varchar (50),
Ubicacion Varchar (50),
CONSTRAINT Pk_Dpto2 PRIMARY KEY (Nombre_Pyto, Numero_Pyto),
FOREIGN KEY (Nombre_Dpto, Numero_Dpto) REFERENCES Departamento(Nombre_Dpto, Numero_Dpto) 
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
);

CREATE TABLE Empleado_Proyecto(
Horas INT,
DNI INT,
Nombre_Pyto Varchar (50),
Numero_Pyto Varchar (50),
FOREIGN KEY (DNI) REFERENCES Empleado(DNI) 
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
CONSTRAINT fk_pYto FOREIGN KEY (Nombre_Pyto, Numero_Pyto)REFERENCES Proyecto(Nombre_Pyto, Numero_Pyto) 
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
);

CREATE TABLE Subordinado(
Nombre_Subordinado Varchar(50),
Sexo VarChar (20),
FechaNAC_Subordinado DATE,
Relacion Varchar (50),
DNI INT,
FOREIGN KEY (DNI) REFERENCES Empleado(DNI) 
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
);
