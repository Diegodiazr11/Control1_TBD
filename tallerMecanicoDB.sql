DROP DATABASE tallerMecanico;
CREATE DATABASE tallerMecanico;
USE tallerMecanico;

CREATE TABLE IF NOT EXISTS Empresa(
	rutEmpresa INT PRIMARY KEY,
    nombreEmpresa VARCHAR(50) NOT NULL,
    telefonoEmpresa INT NOT NULL,
    correoEmpresa VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS estadot (
    id_estadot INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL
);

CREATE TABLE if not exists LOCALL(
	idLocal INT AUTO_INCREMENT PRIMARY KEY,
    nombreLocal VARCHAR(100) NOT NULL,
    direccionLocal VARCHAR(100) NOT NULL,
    telefonoLocal INT NOT NULL,
    rutEmpresa INT,
    
    FOREIGN KEY (rutEmpresa)
    REFERENCES Empresa(rutEmpresa)
);

CREATE TABLE if not exists SERVICIO(
	idServicio INT AUTO_INCREMENT PRIMARY KEY,
    nombreServicio VARCHAR(100) NOT NULL,
    descripcionServicio VARCHAR(200) NOT NULL
);

CREATE TABLE if not exists SERVICIO_LOCAL(
	fechaServicio DATETIME NOT NULL,
    idServicio INT,
    idLocal INT,
    
    FOREIGN KEY (idServicio)
		REFERENCES SERVICIO(idServicio),
	FOREIGN KEY (idLocal)
		REFERENCES LOCALL(idLocal),
	PRIMARY KEY (fechaServicio, idServicio, idLocal)
);

CREATE TABLE if not exists TAREA(
	idTarea INT AUTO_INCREMENT PRIMARY KEY,
    nombreTarea VARCHAR(100) NOT NULL,
    fechaInicioTarea DATETIME NOT NULL,
    fechaFinTarea DATETIME NOT NULL,
    descripcionTarea VARCHAR(200) NOT NULL,
    costoTarea INT NOT NULL,
    
    CONSTRAINT chk_costoTarea CHECK(costoTarea > 0)
);

CREATE TABLE if not exists DETALLE_SERVICIO(
	idDetalleServicio INT AUTO_INCREMENT PRIMARY KEY,
    subtotalDetalleServicio INT NOT NULL,
    idServicio INT,
    idTarea INT,
    
    FOREIGN KEY (idServicio)
		REFERENCES SERVICIO(idServicio),
	FOREIGN KEY (idTarea)
		REFERENCES TAREA(idTarea),
	CONSTRAINT chk_subtotalDetalleServicio CHECK(subtotalDetalleServicio > 0)
);