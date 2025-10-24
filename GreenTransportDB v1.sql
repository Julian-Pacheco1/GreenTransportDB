--1.	Crear las tablas: Vehículos, Conductores y Mantenimientos
CREATE TABLE Vehiculos (
    IdVehiculo INT PRIMARY KEY IDENTITY(1,1),
    Placa NVARCHAR(10) UNIQUE NOT NULL,
    Modelo NVARCHAR(50),
    Año INT,
    Estado NVARCHAR(20) DEFAULT 'Activo' 
);

CREATE TABLE Conductores (
    IdConductor INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Licencia NVARCHAR(20)
);

CREATE TABLE Mantenimientos (
    IdMantenimiento INT PRIMARY KEY IDENTITY(1,1),
    IdVehiculo INT FOREIGN KEY REFERENCES Vehiculos(IdVehiculo),
    IdConductor INT FOREIGN KEY REFERENCES Conductores(IdConductor),
    FechaMantenimiento DATE,
    Descripcion NVARCHAR(200)
);

--2.	Insertar datos simulando la flota actual.
INSERT INTO Vehiculos (Placa, Modelo, Año) VALUES
('BQB906', 'Toyota Hilux', 2020),
('PLV472', 'Volvo S60', 2012),
('LMN456', 'Land Rover', 2021),
('JWB321', 'Chevrolet D-Max', 2022);

INSERT INTO Conductores (Nombre, Licencia) VALUES
('Ricardo Leitón', 'B12345'),
('Fernanda Viquez', 'C67890'),
('Luis Aragón', 'D11223');

INSERT INTO Mantenimientos (IdVehiculo, IdConductor, FechaMantenimiento, Descripcion) VALUES
(1, 1, '2025-09-10', 'Cambio de aceite y filtro'),
(2, 2, '2025-10-01', 'Revisión de frenos'),
(1, 3, '2025-08-20', 'Cambio de neumáticos');

-- 3.a.	Listar mantenimientos por conductor.
SELECT c.Nombre, v.Placa, m.FechaMantenimiento, m.Descripcion
FROM Mantenimientos m
JOIN Conductores c ON m.IdConductor = c.IdConductor
JOIN Vehiculos v ON m.IdVehiculo = v.IdVehiculo
ORDER BY c.Nombre;

-- 3.b vehiculos sin mantenimiento en el ultimo mes
SELECT v.Placa, v.Modelo, v.Año
FROM Vehiculos v
WHERE v.IdVehiculo NOT IN (
    SELECT IdVehiculo 
    FROM Mantenimientos 
    WHERE FechaMantenimiento >= DATEADD(MONTH, -1, GETDATE())
);


--4.	Usar operaciones de conjuntos (UNION, INTERSECT, EXCEPT) para:
--a.	Comparar vehículos activos vs. en mantenimiento.

UPDATE Vehiculos SET Estado = 'Activo' WHERE IdVehiculo = 4;
UPDATE Vehiculos SET Estado = 'En mantenimiento' WHERE IdVehiculo = 2;

SELECT Placa FROM Vehiculos WHERE Estado = 'Activo'
UNION
SELECT Placa FROM Vehiculos WHERE Estado = 'En mantenimiento';

SELECT Placa FROM Vehiculos WHERE Estado = 'Activo'
INTERSECT
SELECT Placa FROM Vehiculos WHERE Estado = 'En mantenimiento';

SELECT Placa FROM Vehiculos WHERE Estado = 'Activo'
EXCEPT
SELECT Placa FROM Vehiculos WHERE Estado = 'En mantenimiento';

-- 5.	Implementar una transacción 
BEGIN TRANSACTION;  
--a.	Registre un mantenimiento.
INSERT INTO Mantenimientos (IdVehiculo, IdConductor, FechaMantenimiento, Descripcion)
VALUES (3, 2, GETDATE(), 'Revisión de frens');  

--b.	Descuente temporalmente la disponibilidad del vehículo.
BEGIN TRANSACTION; 
UPDATE Vehiculos
SET Estado = 'En mantenimiento'
WHERE IdVehiculo = 3; 

--c.	Asegure la consistencia usando BEGIN TRANSACTION, COMMIT y ROLLBACK.
IF @@ERROR <> 0
    ROLLBACK TRANSACTION;  
ELSE
    COMMIT TRANSACTION;    
