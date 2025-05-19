CREATE DATABASE IF NOT EXISTS `GYM`;
USE `GYM`;
drop table Sede;
drop table TelefonoSede;
drop table Zona;
drop table Clase;
drop table Usuario;
drop table DiasAsis;
drop table Asistencia;
drop table Persona;
drop table TelefonoPersona;
CREATE TABLE `Sede`(
ID int(11) NOT NULL AUTO_INCREMENT,
Nombre varchar(70) NOT NULL,
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
Condicion varchar(50) NOT NULL,
HoraA time,
HoraC time,
Fecha date,
PRIMARY KEY (ID, IDSede),
FOREIGN KEY (IDSede) REFERENCES Sede(ID)
)ENGINE = INNODB;

CREATE TABLE `Clase`(
ID int(11) NOT NULL AUTO_INCREMENT,
IDZona int(11) NOT NULL,
IDSede int(11) NOT NULL,
Nombre varchar(25) NOT NULL,
Descripcion varchar(200) NOT NULL,
NumPartic int(6) NOT NULL,
Fecha date NOT NULL, 
HoraInicio time NOT NULL,
HoraFin time NOT NULL,
PRIMARY KEY (ID,IDZona,IDSede),
FOREIGN KEY (IDZona, IDSede) REFERENCES Zona(ID, IDSede)
)ENGINE = INNODB;

CREATE TABLE `Usuario`(
CodUser int(10) NOT NULL,
Genero varchar(15) NOT NULL,
FechaNac date NOT NULL,
FechaInscrip date NOT NULL,
HoraInscrip time NOT NULL,
PRIMARY KEY (CodUser)
)ENGINE = INNODB;

CREATE TABLE `DiasAsis`(
IDDiasAsis int (11) NOT NULL AUTO_INCREMENT,
CodUserUS int(10) NOT NULL,
Dias char(1) NOT NULL,
PRIMARY KEY (IDDiasAsis),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser)
)ENGINE = INNODB;

CREATE TABLE `Asistencia`(
ID int(11) NOT NULL AUTO_INCREMENT,
CodUserUS int(10) NOT NULL,
IDClase int(11) NOT NULL,
IDZona int(11) NOT NULL,
IDSede int(11) NOT NULL,
Fecha date NOT NULL,
HoraEntrada time NOT NULL,
HoraSalida time NOT NULL,
Tipo varchar(15) NOT NULL,
PRIMARY KEY (ID, CodUserUS),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser),
FOREIGN KEY (IDSede, IDZona, IDCl) REFERENCES Clase(IDSede, IDZona, ID)
)ENGINE = INNODB;

CREATE TABLE `Persona`(
ID int(11) NOT NULL AUTO_INCREMENT,
CodUserUS int(10) NOT NULL,
Nombre1 varchar(30) NOT NULL,
Nombre2 varchar(30),
AP varchar (30) NOT NULL,
AM varchar (30) NOT NULL,
Calle varchar (50) NOT NULL,
Numero varchar (20) NOT NULL,
Ciudad varchar (50) NOT NULL,
EstadoP varchar (50) NOT NULL,
CP int NOT NULL,
Email varchar (45) NOT NULL,
Activo varchar(3) NOT NULL,
FechaDesactiv date,
TipoPersona varchar (45) NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser)
)ENGINE = INNODB;

CREATE TABLE `TelefonoPersona`(
IDTelefonoP int(11) NOT NULL AUTO_INCREMENT,
IDPersona int(11) NOT NULL,
Numero varchar(20) NOT NULL,
PRIMARY KEY (IDTelefonoP),
FOREIGN KEY (IDPersona) REFERENCES Persona(ID)
)ENGINE = INNODB;

CREATE TABLE `Zona-Manten`(


)ENGINE = INNODB;

CREATE TABLE `Usuario-Clase`(
CodUserUS int(10) NOT NULL,
IDSede int(11) NOT NULL,
IDZona int(11) NOT NULL,
IDClase int(11) NOT NULL,
Estado varchar(25),
FechaIns date,
PRIMARY KEY (CodUserUS, IDSede, IDZona, IDClase),
FOREIGN KEY (CodUserUS) REFERENCES Usuario(CodUser),
FOREIGN KEY (IDSede, IDZona, IDClase) REFERENCES Clase(IDZona, IDSede, ID)
)ENGINE = INNODB;

CREATE TABLE `Empleado-Clase`(


)ENGINE = INNODB;

CREATE TABLE `Empleado-Manten`(


)ENGINE = INNODB;

CREATE TABLE `Empleado-Equip`(
FechaPrestamo date NOT NULL,
FechaDevol date NOT NULL,
EstadoEntrega varchar(25) NOT NULL,
EstadoDevol varchar (25) NOT NULL,
Comentarios varchar (150) NOT NULL 
)ENGINE = INNODB;

CREATE TABLE `Equip-Manten`(


)ENGINE = INNODB;

CREATE TABLE `MovInventario-Equip`(


)ENGINE = INNODB;