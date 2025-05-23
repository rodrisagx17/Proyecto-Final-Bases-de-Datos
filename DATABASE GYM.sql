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
UNIQUE KEY unique_persona_numero (IdenPersona, Numero)
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

CREATE TABLE `Lesiones`(
IDLes INT NOT NULL AUTO_INCREMENT,
IDCod  INT NOT NULL,
Lesion varchar(50) NOT NULL,
PRIMARY KEY (IDLes),
FOREIGN KEY (IDCod) REFERENCES ExpeMedico(Codigo)
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
