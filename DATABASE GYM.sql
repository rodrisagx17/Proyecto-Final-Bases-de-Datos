CREATE DATABASE IF NOT EXISTS `GYM`;
USE `GYM`;

/*CREACIÓN DE TABLAS*/
CREATE TABLE `Sede`(
ID int(11) NOT NULL AUTO_INCREMENT,
Nombre varchar(70) UNIQUE,
HoraAbre time NOT NULL,
HoraCierra time NOT NULL,
Calle varchar (50) NOT NULL,
Numero varchar (20) NOT NULL,
Ciudad varchar (50) NOT NULL,
EstadoP varchar (50) NOT NULL,
CP int NOT NULL,
PRIMARY KEY (ID)
)ENGINE = INNODB;

CREATE TABLE `TelefonoSede`(
IDTelefono int(11) NOT NULL AUTO_INCREMENT,
IDSede int(11) NOT NULL,
Numero varchar(20) NOT NULL,
PRIMARY KEY (IDTelefono),
FOREIGN KEY (IDSede) REFERENCES Sede(ID)
)ENGINE = INNODB;

CREATE TABLE `Zona`(
ID int(11) NOT NULL AUTO_INCREMENT,
IDSede int(11) NOT NULL,
Nombre varchar(25) NOT NULL,
Categoria varchar(50) NOT NULL,
Condicion ENUM('Disponible', 'Ocupado') NOT NULL DEFAULT 'Disponible',
HoraA time,
HoraC time,
Fecha date NULL,
PRIMARY KEY (ID, IDSede),
FOREIGN KEY (IDSede) REFERENCES Sede(ID)
)ENGINE = INNODB;

CREATE TABLE `ZonaEquipamiento`(
    ZonaID int(11) NOT NULL,
    SedeID int(11) NOT NULL,
    EquipamientoID int(11) NOT NULL,
    FechaAsignacion DATE NOT NULL DEFAULT (CURRENT_DATE),
    EstadoAsignacion ENUM('Activo', 'Inactivo', 'Mantenimiento') NOT NULL DEFAULT 'Activo',
    PRIMARY KEY (ZonaID, SedeID, EquipamientoID),
    FOREIGN KEY (ZonaID, SedeID) REFERENCES Zona(ID, IDSede),
    FOREIGN KEY (EquipamientoID) REFERENCES Equipamiento(ID)
)ENGINE = INNODB;

CREATE TABLE `Clase`(
ID int(11) NOT NULL AUTO_INCREMENT,
IDZona int(11) NOT NULL,
IDSede int(11) NOT NULL,
Nombre varchar(25) NOT NULL,
Descripcion varchar(200) NOT NULL,
NumPartic tinyint NOT NULL,
Fecha date NULL, 
HoraInicio time NOT NULL,
HoraFin time NOT NULL,
PRIMARY KEY (ID,IDZona,IDSede),
FOREIGN KEY (IDZona, IDSede) REFERENCES Zona(ID, IDSede)
)ENGINE = INNODB;

CREATE TABLE `Usuario`(
CodUser int(10) NOT NULL,
Genero varchar(15) NOT NULL,
FechaNac date NOT NULL,
FechaInscrip date NULL,
HoraInscrip time NULL,
PRIMARY KEY (CodUser)
)ENGINE = INNODB;

CREATE TABLE `DiasAsis`(
IDDiasAsis int (11) NOT NULL AUTO_INCREMENT,
CodUserUS int(10) NOT NULL,
DiasSem ENUM('L', 'M', 'X', 'J', 'V', 'S', 'D')NOT NULL,
Activo BOOLEAN DEFAULT TRUE,
PRIMARY KEY (IDDiasAsis),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser) ON DELETE CASCADE ON UPDATE CASCADE,
UNIQUE KEY unique_usuario_dia (CodUserUS, DiasSem),
INDEX idx_usuario_dias (CodUserUS)
)ENGINE = INNODB;

CREATE TABLE `Asistencia`(
ID int(11) NOT NULL AUTO_INCREMENT,
CodUserUS int(10) NOT NULL,
IDClase int(11),
IDZona int(11),
IDSede int(11) NOT NULL,
Fecha date NULL,
HoraEntrada time NULL,
HoraSalida time NULL,
Tipo varchar(15) NOT NULL,
PRIMARY KEY (ID, CodUserUS),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser),
FOREIGN KEY (IDClase, IDZona, IDSede) REFERENCES Clase(ID, IDZona, IDSede)
)ENGINE = INNODB;

CREATE TABLE `Persona`(
IdenOf varchar(25) NOT NULL,
NombreP varchar(30) NOT NULL,
NombreS varchar(30),
AP varchar (30) NOT NULL,
AM varchar (30) NOT NULL,
Calle varchar (50) NOT NULL,
Numero varchar (20) NOT NULL,
Ciudad varchar (50) NOT NULL,
EstadoP varchar (50) NOT NULL,
CP int NOT NULL,
Email varchar (45) NOT NULL,
Activo BOOLEAN DEFAULT TRUE,
FechaDesactiv date,
TipoPersona ENUM ('Usuario', 'Empleado', 'Ambos')NOT NULL,
PRIMARY KEY (IdenOf)
)ENGINE = INNODB;

CREATE TABLE `UsuarioPersona`(
    CodUserUS int(10) NOT NULL,
    IdenPersona varchar(25) NOT NULL,
    FechaVinculacion DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (CodUserUS, IdenPersona),
    FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IdenPersona) REFERENCES Persona(IdenOf) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE `EmpleadoPersona`(
    CodEmplEM int(10) NOT NULL,
    IdenPersona varchar(25) NOT NULL,
    FechaVinculacion DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (CodEmplEM, IdenPersona),
    FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IdenPersona) REFERENCES Persona(IdenOf) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE `TelefonoPersona`(
IDTelefonoP int(11) NOT NULL AUTO_INCREMENT,
IDPersona varchar(25) NOT NULL,
Numero varchar(20) NOT NULL,
TipoTelefono ENUM('Movil', 'Casa', 'Trabajo', 'Emergencia') NOT NULL DEFAULT 'Movil',
PRIMARY KEY (IDTelefonoP),
FOREIGN KEY (IDPersona) REFERENCES Persona(IdenOf) ON DELETE CASCADE ON UPDATE CASCADE,
UNIQUE KEY unique_persona_numero (IDPersona, Numero)
)ENGINE = INNODB;

CREATE TABLE `ZonaXManten`(
ZonaID INT(11) NOT NULL,
ZonaSedeID INT(11) NOT NULL,
MantenimientoID INT(11) NOT NULL,
TipoMantenimientoZ ENUM('Limpieza', 'Revision', 'Reparacion', 'Actualizacion') NOT NULL,
PrioridadZ ENUM('Baja', 'Media', 'Alta', 'Urgente') NOT NULL DEFAULT 'Media',
TiempoEstZ DECIMAL(5,2) NULL,
CostoEstZ DECIMAL(10,2) NULL,
FechaAsignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (ZonaID, ZonaSedeID, MantenimientoID),
FOREIGN KEY (ZonaID, ZonaSedeID) REFERENCES Zona(ID, IDSede) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (MantenimientoID) REFERENCES Mantenimiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
-- Índices para optimizar consultas
INDEX idx_zona_mantenimiento (ZonaID, ZonaSedeID),
INDEX idx_mantenimiento_zona (MantenimientoID),
INDEX idx_tipo_mant_zona (TipoMantenimientoZ),
INDEX idx_prioridad_zona (PrioridadZ)
)ENGINE = INNODB;

CREATE TABLE `UsuarioXClase`(
CodUserUS int(10) NOT NULL,
IDSede int(11) NOT NULL,
IDZona int(11) NOT NULL,
IDClase int(11) NOT NULL,
Estado ENUM('Inscrito', 'Confirmado', 'Asistió', 'Faltó', 'Cancelado', 'En Lista de Espera') NOT NULL,
FechaIns DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
FechaConfirmacion DATETIME NULL, 
FechaCancelacion DATETIME NULL,  
MotivoCancelacion VARCHAR(100) NULL,
NumeroEnListaEspera TINYINT NULL, 
Observaciones VARCHAR(200) NULL,
Calificacion TINYINT NULL, 
FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FechaActualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (CodUserUS, IDSede, IDZona, IDClase),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (IDClase, IDZona, IDSede) REFERENCES Clase(ID, IDZona, IDSede) ON DELETE CASCADE ON UPDATE CASCADE,
/*Índices para mejorar rendimiento*/
INDEX idx_usuario (CodUserUS),
INDEX idx_clase_completa (IDClase, IDZona, IDSede),
INDEX idx_estado_inscripcion (Estado),
INDEX idx_fecha_inscripcion (FechaIns),
INDEX idx_sede (IDSede),
INDEX idx_zona (IDZona, IDSede),
INDEX idx_lista_espera (NumeroEnListaEspera)                               
)ENGINE = INNODB;

CREATE TABLE `EmpleadoXClase`(
CodEmplEM INT(10) NOT NULL,
IDClase INT(11) NOT NULL,
IDZona INT(11) NOT NULL,
IDSede INT(11) NOT NULL,
FechaAsig DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
FechaFinAsign DATE,
Observaciones VARCHAR(200) NULL,
TarifaXClase DECIMAL(8,2) NULL, 
FechaCrea TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FechaActua TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (CodEmplEM, IDClase, IDZona, IDSede),
FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (IDClase, IDZona, IDSede) REFERENCES Clase(ID, IDZona, IDSede) ON DELETE CASCADE ON UPDATE CASCADE,
/*Índices para mejorar rendimiento*/
INDEX idx_empleado (CodEmplEM),
INDEX idx_clase_completa (IDClase, IDZona, IDSede),
INDEX idx_sede (IDSede),
INDEX idx_zona (IDZona, IDSede),
INDEX idx_fecha_asignacion (FechaAsig)                      
)ENGINE = INNODB;

CREATE TABLE `EmpleadoXManten`(
CodEmplEM INT(10) NOT NULL,
MantenimientoID INT(11) NOT NULL,
PRIMARY KEY (CodEmplEM, MantenimientoID),
FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (MantenimientoID) REFERENCES Mantenimiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
/*Índices para mejorar rendimiento*/
INDEX idx_empleado (CodEmplEM),
INDEX idx_mantenimiento (MantenimientoID)
)ENGINE = INNODB;

CREATE TABLE `EmpleadoXEquip`(
EquipID INT(11) NOT NULL,
CodEmplEM INT(10) NOT NULL,
FechaAsignacion DATE NOT NULL,
TipoResponsabilidad ENUM('Mantenimiento', 'Operacion', 'Supervision', 'Limpieza') NOT NULL,
FechaInicio DATE NOT NULL,
FechaFin DATE NULL, 
EstadoAsignacion ENUM('Activa', 'Completada', 'Suspendida') NOT NULL DEFAULT 'Activa',
Comentarios VARCHAR(255) NULL,
PRIMARY KEY (EquipID, CodEmplEM, FechaAsignacion),
FOREIGN KEY (EquipID) REFERENCES Equipamiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl) ON DELETE CASCADE ON UPDATE CASCADE,
/*Índices para mejorar rendimiento en consultas frecuentes*/
INDEX idx_empleado_equipamiento (CodEmplEM, EquipID),
INDEX idx_fecha_asignacion (FechaAsignacion),
INDEX idx_estado_asignacion (EstadoAsignacion)
)ENGINE = INNODB;

CREATE TABLE `EquipXManten`(
EquipamientoID INT(11) NOT NULL,
MantenimientoID INT(11) NOT NULL,
TipoMantenimiento ENUM('Preventivo', 'Correctivo', 'Predictivo', 'Emergencia') NOT NULL,
PrioridadMantenimiento ENUM('Baja', 'Media', 'Alta', 'Critica') NOT NULL DEFAULT 'Media',
CostoEstimado DECIMAL(10,2) NULL,
TiempoEstimado INT NULL, -- En horas
FechaAsignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (EquipamientoID, MantenimientoID),
FOREIGN KEY (EquipamientoID) REFERENCES Equipamiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (MantenimientoID) REFERENCES Mantenimiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
/*Índices para optimizar consultas*/
INDEX idx_equipamiento_mant (EquipamientoID),
INDEX idx_mantenimiento_equip (MantenimientoID),
INDEX idx_tipo_mantenimiento (TipoMantenimiento),
INDEX idx_prioridad (PrioridadMantenimiento)
)ENGINE = INNODB;

CREATE TABLE `MovInventarioXEquip`(
 EquipIDRel INT(11) NOT NULL,
 NumMov INT NOT NULL,
 EquipIDMov INT(11) NOT NULL,
 PRIMARY KEY (EquipIDRel, NumMov, EquipIDMov),
 FOREIGN KEY (EquipIDRel) REFERENCES Equipamiento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (NumMov, EquipIDMov) REFERENCES MovInventario(NumMov, EquipID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE `Empleado`(
    CodEmpl INT(10) NOT NULL,
    FechaContrata DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    HorarTrabajo DATE NOT NULL,
    ActivoEmple BOOLEAN DEFAULT TRUE,  -- TRUE = Activo, FALSE = Inactivo
    Rol varchar(30) UNIQUE,
    Especialidad varchar(40) NOT NULL,
    PRIMARY KEY (CodEmpl)
)ENGINE = INNODB;

CREATE TABLE `Equipamiento`(
    ID INT(11) NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    TipoEquip VARCHAR(50) NOT NULL,
    CantidadAct INT(20) NOT NULL,
    Condicion ENUM('Disponible', 'En Mantenimiento') NOT NULL DEFAULT 'Disponible',
    UltMantenim DATE NOT NULL,
    PRIMARY KEY (ID)
)ENGINE = INNODB;
    
CREATE TABLE `Mantenimiento`(
    ID INT(11) NOT NULL AUTO_INCREMENT,
    EquipIDE INT(11) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NOT NULL,
    HoraInicio TIME NULL,
    HoraFin TIME NOT NULL,
    Estado ENUM('Agendado', 'En Proceso', 'Terminado') NOT NULL DEFAULT 'Agendado',
    ComentAdi varchar(100),
    PRIMARY KEY (ID),
    FOREIGN KEY (EquipIDE) REFERENCES Equipamiento(ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE `Pago`(
    Folio INT(30) NOT NULL,
    CodUserUS int(10),
    CodEmplEM INT(10),
    Memb INT(11) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    MontoRe DECIMAL(10,2) NOT NULL,
    MontoAdeu DECIMAL(10, 2),
    FechaPago DATE NULL,
    Hora TIME NULL,
    Metodo ENUM('Credito', 'Debito', 'Transferencia', 'Efectivo') NOT NULL,
    TipoPago ENUM('Quincenal', 'Mensual', 'Aportacion Voluntaria') NOT NULL,
    Concepto VARCHAR(100) NOT NULL,
    EstadoPago ENUM('Pendiente', 'Completado', 'Cancelado', 'Rechazado') NOT NULL,
    DetallesAdi varchar(100),
    FechUltPago DATE NOT NULL,
    PRIMARY KEY (Folio, CodUserUS, CodEmplEM, Memb),
    FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser),
    FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl),
    FOREIGN KEY (Memb) REFERENCES Membresia(CodMemb)
)ENGINE = INNODB;

CREATE TABLE `Membresia` (
    CodMemb INT(11) NOT NULL AUTO_INCREMENT,
    CodUserUS int(10) NOT NULL,
    Nombre ENUM('Basica', 'Premium', 'VIP') NOT NULL DEFAULT 'Basica',
    Descripcion VARCHAR(100) UNIQUE,
    precio DECIMAL(5,2) NOT NULL,
    FechaInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FechaVen TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Duracion INT GENERATED ALWAYS AS (DATEDIFF(FechaVen, FechaInicio)) STORED,
    Descuento DECIMAL(5,2) DEFAULT 0.00,
    EstadoPlan ENUM('Activo', 'Inactivo', 'Expirado', 'Pausado') NOT NULL DEFAULT 'Activo',
    NumClassIn INT UNSIGNED,
    HorasAcceso TINYINT UNSIGNED,
    PRIMARY KEY(CodMemb),
    FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser)
)ENGINE = INNODB;

CREATE TABLE `ExpeMedico` (
    Codigo INT NOT NULL AUTO_INCREMENT,
    Fecha DATE NULL,
    Hora TIME NULL,
    Resultados VARCHAR(50) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Objetivos ENUM('Ganar Masa Muscular', 'Bajar de Peso', 'Mantener Peso') NOT NULL,
    CodEmplEM INT(10) NOT NULL,
    CodCita INT NOT NULL,
    ZonasRecom VARCHAR(50) NOT NULL,
    Lesiones VARCHAR(50) NOT NULL,
    PRIMARY KEY (Codigo, CodEmplEM, CodCita),
    FOREIGN KEY (CodEmplEM) REFERENCES Empleado(CodEmpl),
    FOREIGN KEY (CodCita) REFERENCES cita(Codigo)
)ENGINE = INNODB;

CREATE TABLE `cita` (
    Codigo INT AUTO_INCREMENT NOT NULL,
    Fecha DATE NULL,
    Hora TIME NULL,
    IDSede INT(11) NOT NULL,
    CodUserUS INT(10) NOT NULL,
    PRIMARY KEY (Codigo),
    FOREIGN KEY (IDSede) REFERENCES Sede(ID),
    FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser)
)ENGINE = INNODB;

CREATE TABLE `MovInventario` (
    NumMov INT NOT NULL AUTO_INCREMENT,
    EquipID INT(11) NOT NULL,
    TipMov ENUM('Entrada', 'Salida', 'Transferencia') NOT NULL,
    Cantidad INT NOT NULL,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    PRIMARY KEY (NumMov, EquipID),
    FOREIGN KEY (EquipID) REFERENCES Equipamiento(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;

/*INSERCIÓN DE DATOS*/
/*Sede*/
INSERT INTO Sede(Nombre, HoraAbre, HoraCierra, Calle, Numero, Ciudad, EstadoP, CP) Values('GYM WARRIOR Z25','07:00:00','22:00:00','Zaragoza','#25','Monterrey','Nuevo Leon', 12415);
INSERT INTO Sede(Nombre, HoraAbre, HoraCierra, Calle, Numero, Ciudad, EstadoP, CP) Values('GYM WARRIOR G38A','06:00:00','22:00:00','Gabriel Bosco','#38A','Monterrey','Nuevo Leon', 12415);
INSERT INTO Sede(Nombre, HoraAbre, HoraCierra, Calle, Numero, Ciudad, EstadoP, CP) Values('GYM WARRIOR H76','08:00:00','20:00:00','Hidalgo','#76','CDMX','CDMX',134665);
INSERT INTO Sede(Nombre, HoraAbre, HoraCierra, Calle, Numero, Ciudad, EstadoP, CP) Values('GYM WARRIOR M13B','07:00:00','20:00:00','Miguel Toledo','#13B','Puebla','Puebla',124253);
INSERT INTO Sede(Nombre, HoraAbre, HoraCierra, Calle, Numero, Ciudad, EstadoP, CP) Values('GYM WARRIOR C12C','06:00:00','21:00:00','Constitucion','#12C','Guadalajara','Jalisco',234242);
/*Usuario*/
INSERT INTO Usuario (CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip) VALUES (10001, 'Masculino', '1990-05-15', '2024-01-10', '10:30:00');
INSERT INTO Usuario (CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip) VALUES (10002, 'Femenino', '1985-08-22', '2024-01-12', '14:15:00');  
INSERT INTO Usuario (CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip) VALUES (10003, 'Masculino', '1992-12-03', '2024-01-15', '09:45:00'); 
INSERT INTO Usuario (CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip) VALUES (10004, 'Femenino', '1988-07-18', '2024-01-18', '16:20:00');
INSERT INTO Usuario (CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip) VALUES (10005, 'Masculino', '1995-03-25', '2024-01-20', '11:10:00');
/*Empleado*/
INSERT INTO Empleado (CodEmpl, FechaContrata, salario, HorarTrabajo, ActivoEmple, Rol, Especialidad) VALUES
(20001, '2023-06-01', 15000.00, '2023-06-01', TRUE, 'Instructor', 'Entrenamiento Funcional'),
(20002, '2023-07-15', 18000.00, '2023-07-15', TRUE, 'Nutricionista', 'Nutrición Deportiva'),
(20003, '2023-08-01', 16500.00, '2023-08-01', TRUE, 'Fisioterapeuta', 'Rehabilitación'),
(20004, '2023-09-10', 14000.00, '2023-09-10', TRUE, 'Recepcionista', 'Atención al Cliente'),
(20005, '2023-10-05', 20000.00, '2023-10-05', TRUE, 'Gerente', 'Administración');
/*Equipamiento*/
INSERT INTO Equipamiento (Nombre, Categoria, TipoEquip, CantidadAct, Condicion, UltMantenim) VALUES
('Caminadora Profesional', 'Cardio', 'Caminadora', 5, 'Disponible', '2024-01-01'),
('Bicicleta Estática', 'Cardio', 'Bicicleta', 8, 'Disponible', '2024-01-05'),
('Rack de Sentadillas', 'Fuerza', 'Rack', 3, 'Disponible', '2024-01-03'),
('Mancuernas Ajustables', 'Fuerza', 'Pesas', 15, 'Disponible', '2024-01-07'),
('Colchonetas Yoga', 'Funcional', 'Accesorio', 20, 'En Mantenimiento', '2024-01-10');
/*Persona*/
INSERT INTO Persona (IdenOf, NombreP, NombreS, AP, AM, Calle, Numero, Ciudad, EstadoP, CP, Email, Activo, TipoPersona) VALUES
('CURP001', 'Juan', 'Carlos', 'Pérez', 'García', 'Calle Reforma', '100', 'Guadalajara', 'Jalisco', 44100, 'juan.perez@email.com', TRUE, 'Usuario'),
('CURP002', 'María', 'Elena', 'López', 'Martínez', 'Calle Hidalgo', '250', 'Zapopan', 'Jalisco', 45120, 'maria.lopez@email.com', TRUE, 'Usuario'),
('CURP003', 'Pedro', 'Antonio', 'Hernández', 'Rodríguez', 'Av. Revolución', '75', 'Tlaquepaque', 'Jalisco', 45500, 'pedro.hernandez@email.com', TRUE, 'Empleado'),
('CURP004', 'Ana', 'Sofía', 'González', 'Sánchez', 'Calle Morelos', '180', 'Guadalajara', 'Jalisco', 44630, 'ana.gonzalez@email.com', TRUE, 'Ambos'),
('CURP005', 'Luis', 'Miguel', 'Ramírez', 'Torres', 'Av. Independencia', '320', 'Zapopan', 'Jalisco', 45040, 'luis.ramirez@email.com', TRUE, 'Empleado');
/*TelefonoSede*/
INSERT INTO TelefonoSede (IDSede, Numero) VALUES
(1, '33-1234-5678'),
(1, '33-1234-5679'),
(2, '33-2345-6789'),
(3, '33-3456-7890'),
(4, '33-4567-8901');
/*Zona*/
INSERT INTO Zona (IDSede, Nombre, Categoria, Condicion, HoraA, HoraC, Fecha) VALUES
(1, 'Zona Cardio', 'Cardiovascular', 'Disponible', '06:00:00', '22:00:00', '2024-01-15'),
(1, 'Zona Pesas', 'Fuerza', 'Disponible', '06:00:00', '22:00:00', '2024-01-15'),
(2, 'Zona Funcional', 'Entrenamiento Funcional', 'Disponible', '05:30:00', '23:00:00', '2024-01-16'),
(3, 'Zona Yoga', 'Relajación', 'Ocupado', '06:00:00', '21:00:00', '2024-01-17'),
(4, 'Zona Spinning', 'Cardiovascular', 'Disponible', '07:00:00', '22:30:00', '2024-01-18');
/*DiasAsis*/
INSERT INTO DiasAsis (CodUserUS, DiasSem, Activo) VALUES
(10001, 'L', TRUE),
(10001, 'X', TRUE),
(10002, 'M', TRUE),
(10003, 'J', TRUE),
(10004, 'V', TRUE);
/*Membresia*/
INSERT INTO Membresia (CodMemb, CodUserUS, Nombre, Descripcion, precio, FechaInicio, FechaVen, Descuento, EstadoPlan, NumClassIn, HorasAcceso) VALUES
(3001, 10001, 'Basica', 'Acceso básico al gimnasio', 500.00, '2024-01-10 10:30:00', '2024-02-10 10:30:00', 0.00, 'Activo', 8, 12),
(3002, 10002, 'Premium', 'Acceso completo + clases grupaless', 800.00, '2024-01-12 14:15:00', '2024-02-12 14:15:00', 10.00, 'Activo', 15, 16),
(3003, 10003, 'VIP', 'Acceso total + entrenador personal', 900.00, '2024-01-15 09:45:00', '2024-02-15 09:45:00', 5.00, 'Activo', 20, 24),
(3004, 10004, 'Basica', 'Acceso básico al gimnasios', 500.00, '2024-01-18 16:20:00', '2024-02-18 16:20:00', 0.00, 'Activo', 8, 12),
(3005, 10005, 'Premium', 'Acceso completo + clases grupales', 800.00, '2024-01-20 11:10:00', '2024-02-20 11:10:00', 15.00, 'Activo', 15, 16);

/*UsuarioPersona*/
INSERT INTO UsuarioPersona (CodUserUS, IdenPersona, FechaVinculacion) VALUES
(10001, 'CURP001', '2024-01-10'),
(10002, 'CURP002', '2024-01-12'),
(10003, 'CURP004', '2024-01-15'),
(10004, 'CURP004', '2024-01-18'),
(10005, 'CURP005', '2024-01-20');
/*EmpleadoPersona*/
INSERT INTO EmpleadoPersona (CodEmplEM, IdenPersona, FechaVinculacion) VALUES
(20001, 'CURP003', '2023-06-01'),
(20002, 'CURP005', '2023-07-15'),
(20003, 'CURP004', '2023-08-01'),
(20004, 'CURP001', '2023-09-10'),
(20005, 'CURP002', '2023-10-05');
/*TelefonoPersona*/
INSERT INTO TelefonoPersona (IDPersona, Numero, TipoTelefono) VALUES
('CURP001', '33-1111-1111', 'Movil'),
('CURP002', '33-2222-2222', 'Casa'),
('CURP003', '33-3333-3333', 'Trabajo'),
('CURP004', '33-4444-4444', 'Movil'),
('CURP005', '33-5555-5555', 'Emergencia');

/*Mantenimiento*/
INSERT INTO Mantenimiento (EquipIDE, Descripcion, FechaInicio, FechaFin, HoraInicio, HoraFin, Estado, ComentAdi) VALUES
(1, 'Mantenimiento preventivo caminadora', '2024-01-15', '2024-01-15', '08:00:00', '10:00:00', 'Terminado', 'Cambio de aceite y calibración'),
(2, 'Reparación de pedales', '2024-01-20', '2024-01-21', '14:00:00', '16:00:00', 'En Proceso', 'Reemplazo de pedales dañados'),
(3, 'Inspección de seguridad', '2024-01-25', '2024-01-25', '09:00:00', '11:00:00', 'Agendado', 'Revisión de barras y seguros'),
(4, 'Limpieza profunda', '2024-01-30', '2024-01-30', '07:00:00', '09:00:00', 'Agendado', 'Desinfección y pulido'),
(5, 'Reparación de cremalleras', '2024-02-01', '2024-02-02', '13:00:00', '15:00:00', 'Agendado', 'Cambio de cremalleras defectuosas');
/*MovInventario*/
INSERT INTO MovInventario (EquipID, TipMov, Cantidad, Fecha, Descripcion) VALUES
(1, 'Entrada', 2, '2024-01-01 10:00:00', 'Compra de nuevas caminadoras'),
(2, 'Entrada', 3, '2024-01-05 14:30:00', 'Adquisición de bicicletas adicionales'),
(3, 'Salida', 1, '2024-01-10 09:15:00', 'Rack enviado a mantenimiento externo'),
(4, 'Transferencia', 5, '2024-01-12 11:45:00', 'Transferencia entre sedes'),
(5, 'Entrada', 10, '2024-01-15 16:20:00', 'Reposición de colchonetas');

/*cita*/
INSERT INTO cita (Fecha, Hora, IDSede, CodUserUS) VALUES
('2024-01-25', '10:00:00', 1, 10001),
('2024-01-26', '11:30:00', 2, 10002),
('2024-01-27', '14:00:00', 1, 10003),
('2024-01-28', '16:15:00', 3, 10004),
('2024-01-29', '09:45:00', 4, 10005);
/*ZonaEquipamiento*/
INSERT INTO ZonaEquipamiento (ZonaID, SedeID, EquipamientoID, FechaAsignacion, EstadoAsignacion) VALUES
(1, 1, 1, '2024-01-15', 'Activo'),
(1, 1, 2, '2024-01-15', 'Activo'),
(2, 1, 3, '2024-01-16', 'Activo'),
(3, 2, 4, '2024-01-17', 'Activo'),
(4, 3, 5, '2024-01-18', 'Mantenimiento');

/*Clase*/
INSERT INTO Clase (IDZona, IDSede, Nombre, Descripcion, NumPartic, Fecha, HoraInicio, HoraFin) VALUES
(1, 1, 'Cardio Matutino', 'Clase de cardio para principiantes', 15, '2024-01-25', '07:00:00', '08:00:00'),
(2, 1, 'Fuerza Avanzada', 'Entrenamiento de fuerza para nivel avanzado', 10, '2024-01-25', '18:00:00', '19:30:00'),
(3, 2, 'Funcional Cross', 'Entrenamiento funcional de alta intensidad', 12, '2024-01-26', '19:00:00', '20:00:00'),
(4, 3, 'Yoga Relajante', 'Sesión de yoga para relajación y flexibilidad', 20, '2024-01-27', '10:00:00', '11:30:00'),
(5, 4, 'Spinning Extremo', 'Clase de spinning de alta intensidad', 18, '2024-01-28', '20:00:00', '21:00:00');
/*ExpeMedico*/
INSERT INTO ExpeMedico (Fecha, Hora, Resultados, Tipo, Objetivos, CodEmplEM, CodCita, ZonasRecom, Lesiones) VALUES
('2024-01-25', '10:30:00', 'Excelente condición', 'Evaluación Inicial', 'Ganar Masa Muscular', 20002, 1, 'Zona Pesas', 'Ninguna'),
('2024-01-26', '12:00:00', 'Sobrepeso leve', 'Evaluación Nutricional', 'Bajar de Peso', 20002, 2, 'Zona Cardio', 'Dolor rodilla izquierda'),
('2024-01-27', '14:30:00', 'Buena resistencia', 'Evaluación Física', 'Mantener Peso', 20003, 3, 'Zona Funcional', 'Ninguna'),
('2024-01-28', '16:45:00', 'Flexibilidad limitada', 'Evaluación Postural', 'Ganar Masa Muscular', 20003, 4, 'Zona Yoga', 'Lumbalgia'),
('2024-01-29', '10:15:00', 'Cardio deficiente', 'Evaluación Cardiovascular', 'Bajar de Peso', 20002, 5, 'Zona Spinning', 'Ninguna');

/*Pago*/
INSERT INTO Pago (Folio, CodUserUS, CodEmplEM, Memb, Monto, MontoRe, MontoAdeu, FechaPago, Hora, Metodo, TipoPago, Concepto, EstadoPago, DetallesAdi, FechUltPago) VALUES
(1001, 10001, 20004, 3001, 500.00, 500.00, 0.00, '2024-01-10', '10:45:00', 'Efectivo', 'Mensual', 'Pago mensualidad enero', 'Completado', 'Pago completo', '2024-01-10'),
(1002, 10002, 20004, 3002, 800.00, 720.00, 0.00, '2024-01-12', '14:30:00', 'Credito', 'Mensual', 'Pago mensualidad enero con descuento', 'Completado', 'Descuento aplicado', '2024-01-12'),
(1003, 10003, 20004, 3003, 1200.00, 1140.00, 0.00, '2024-01-15', '10:00:00', 'Transferencia', 'Mensual', 'Pago mensualidad enero VIP', 'Completado', 'Descuento fidelidad', '2024-01-15'),
(1004, 10004, 20004, 3004, 500.00, 250.00, 250.00, '2024-01-18', '16:35:00', 'Debito', 'Quincenal', 'Pago parcial enero', 'Pendiente', 'Pendiente segunda quincena', '2024-01-18'),
(1005, 10005, 20004, 3005, 800.00, 680.00, 0.00, '2024-01-20', '11:25:00', 'Efectivo', 'Mensual', 'Pago mensualidad enero premium', 'Completado', 'Descuento estudiante', '2024-01-20');
/*Asistencia*/
INSERT INTO Asistencia (CodUserUS, IDClase, IDZona, IDSede, Fecha, HoraEntrada, HoraSalida, Tipo) VALUES
(10001, 1, 1, 1, '2024-01-25', '06:55:00', '08:05:00', 'Clase'),
(10002, 2, 2, 1, '2024-01-25', '17:55:00', '19:35:00', 'Clase'),
(10003, NULL, 3, 2, '2024-01-26', '10:00:00', '11:30:00', 'Libre'),
(10004, 4, 4, 3, '2024-01-27', '09:55:00', '11:35:00', 'Clase'),
(10005, 5, 5, 4, '2024-01-28', '19:55:00', '21:05:00', 'Clase');

/*ZonaXManten*/
INSERT INTO `Zona-Manten` (ZonaID, ZonaSedeID, MantenimientoID, TipoMantenimientoZ, PrioridadZ, TiempoEstZ, CostoEstZ, FechaAsignacion) VALUES
(1, 2, 2, 'Limpieza', 'Media', 2.00, 150.00, '2024-01-15 08:00:00'),
(2, 1, 2, 'Revision', 'Alta', 1.50, 200.00, '2024-01-20 14:00:00'),
(3, 2, 3, 'Reparacion', 'Urgente', 3.00, 500.00, '2024-01-25 09:00:00'),
(4, 3, 4, 'Limpieza', 'Baja', 1.00, 100.00, '2024-01-30 07:00:00'),
(5, 4, 5, 'Actualizacion', 'Media', 4.00, 300.00, '2024-02-01 13:00:00');
/*UsuarioXClase*/
INSERT INTO `Usuario-Clase` (CodUserUS, IDSede, IDZona, IDClase, Estado, FechaIns, FechaConfirmacion, NumeroEnListaEspera, Observaciones, Calificacion) VALUES
(10001, 1, 1, 1, 'Asistió', '2024-01-20 10:30:00', '2024-01-24 18:00:00', NULL, 'Excelente participación', 5),
(10002, 1, 2, 2, 'Asistió', '2024-01-21 14:15:00', '2024-01-24 19:00:00', NULL, 'Buen desempeño', 4),
(10003, 2, 3, 3, 'Confirmado', '2024-01-22 09:45:00', '2024-01-25 10:00:00', NULL, 'Primera clase', NULL),
(10004, 3, 4, 4, 'Inscrito', '2024-01-23 16:20:00', NULL, NULL, 'Interesada en yoga', NULL),
(10005, 4, 5, 5, 'En Lista de Espera', '2024-01-24 11:10:00', NULL, 3, 'Clase llena', NULL);

/*EmpleadoXClase*/
INSERT INTO EmpleadoXClase (CodEmplEM, IDClase, IDZona, IDSede, FechaAsig, FechaFinAsign, Observaciones, TarifaXClase) VALUES
(20001, 1, 1, 1, '2024-01-15 10:00:00', NULL, 'Instructor principal cardio', 200.00),
(20001, 2, 2, 1, '2024-01-15 10:00:00', NULL, 'Instructor fuerza avanzada', 250.00),
(20002, 3, 3, 2, '2024-01-16 14:00:00', NULL, 'Instructor funcional', 220.00),
(20003, 4, 4, 3, '2024-01-17 09:00:00', NULL, 'Instructor yoga certificado', 180.00),
(20001, 5, 5, 4, '2024-01-18 16:00:00', NULL, 'Instructor spinning', 200.00);
/*EmpleadoXManten*/
INSERT INTO EmpleadoXManten (CodEmplEM, MantenimientoID) VALUES
(20005, 1),
(20001, 2),
(20005, 3),
(20004, 4),
(20001, 5);
/*EmpleadoXEquip*/
INSERT INTO EmpleadoXEquip (EquipID, CodEmplEM, FechaAsignacion, TipoResponsabilidad, FechaInicio, FechaFin, EstadoAsignacion, Comentarios) VALUES
(1, 20001, '2024-01-15', 'Mantenimiento', '2024-01-15', NULL, 'Activa', 'Responsable de caminadoras'),
(2, 20001, '2024-01-16', 'Operacion', '2024-01-16', NULL, 'Activa', 'Supervisión de bicicletas'),
(3, 20005, '2024-01-17', 'Supervision', '2024-01-17', NULL, 'Activa', 'Control de racks de pesas'),
(4, 20004, '2024-01-18', 'Limpieza', '2024-01-18', NULL, 'Activa', 'Limpieza de mancuernas'),
(5, 20003, '2024-01-19', 'Mantenimiento', '2024-01-19', '2024-02-02', 'Completada', 'Reparación de colchonetas terminada');

/*Equip-Manten*/
INSERT INTO EquipXManten (EquipamientoID, MantenimientoID, TipoMantenimiento, PrioridadMantenimiento, CostoEstimado, TiempoEstimado, FechaAsignacion) VALUES
(1, 1, 'Preventivo', 'Media', 200.00, 2, '2024-01-15 08:00:00'),
(2, 2, 'Correctivo', 'Alta', 350.00, 4, '2024-01-20 14:00:00'),
(3, 3, 'Preventivo', 'Baja', 150.00, 2, '2024-01-25 09:00:00'),
(4, 4, 'Preventivo', 'Media', 100.00, 1, '2024-01-30 07:00:00'),
(5, 5, 'Correctivo', 'Critica', 500.00, 8, '2024-02-01 13:00:00');
/*MovInventarioXEquip*/
INSERT INTO MovInventarioXEquip (EquipIDRel, NumMov, EquipIDMov) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);
