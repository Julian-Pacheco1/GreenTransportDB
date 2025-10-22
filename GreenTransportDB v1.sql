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
