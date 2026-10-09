DROP DATABASE IF EXISTS tallerMecanico;
CREATE DATABASE tallerMecanico;
USE tallerMecanico;

CREATE TABLE IF NOT EXISTS Empresa(
	rutEmpresa VARCHAR(20) PRIMARY KEY,
    nombreEmpresa VARCHAR(50) NOT NULL,
    telefonoEmpresa VARCHAR(15) NOT NULL,
    correoEmpresa VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cargo(
	idCargo INT AUTO_INCREMENT PRIMARY KEY,
    nombreCargo VARCHAR(50) NOT NULL,
    descripcionCargo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Estadot (
    id_estadot INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Presupuesto (
    id_presupuesto INT AUTO_INCREMENT PRIMARY KEY,
    id_local INT NOT NULL,
    id_estadop INT NOT NULL,
    fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) DEFAULT 0.00,
    
    CONSTRAINT fk_presupuesto_local FOREIGN KEY (id_local) 
        REFERENCES local(id_local) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_presupuesto_estadop FOREIGN KEY (id_estadop) 
        REFERENCES estadop(id_estadop) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Trabajo (
    id_trabajo INT AUTO_INCREMENT PRIMARY KEY,
    id_presupuesto INT UNIQUE,
    id_local INT NOT NULL,
    id_estadot INT NOT NULL,
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME NULL,
    
    CONSTRAINT fk_trabajo_presupuesto FOREIGN KEY (id_presupuesto) 
        REFERENCES presupuesto(id_presupuesto) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_trabajo_local FOREIGN KEY (id_local) 
        REFERENCES local(id_local) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_trabajo_jefe FOREIGN KEY (id_empleado_jefe) 
        REFERENCES empleado(id_empleado) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_trabajo_estadot FOREIGN KEY (id_estadot) 
        REFERENCES estadot(id_estadot) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Detalle_presupuesto (
    id_detalle_presupuesto INT AUTO_INCREMENT PRIMARY KEY,
    id_presupuesto INT NOT NULL,
    id_tarea INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_estimado DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT fk_detpresupuesto_presupuesto FOREIGN KEY (id_presupuesto) 
        REFERENCES presupuesto(id_presupuesto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detpresupuesto_tarea FOREIGN KEY (id_tarea) 
        REFERENCES tarea(id_tarea) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Detalle_trabajo (
    id_detalle_trabajo INT AUTO_INCREMENT PRIMARY KEY,
    id_trabajo INT NOT NULL,
    id_tarea INT NOT NULL,
    id_estadot INT NOT NULL,
    costo DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    horas_dedicadas DECIMAL(5, 2) DEFAULT 0.00,
    
    CONSTRAINT fk_dettrabajo_trabajo FOREIGN KEY (id_trabajo) 
        REFERENCES trabajo(id_trabajo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dettrabajo_tarea FOREIGN KEY (id_tarea) 
        REFERENCES tarea(id_tarea) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_dettrabajo_estadot FOREIGN KEY (id_estadot) 
        REFERENCES estadot(id_estadot) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE if not exists LOCALL(
	idLocal INT AUTO_INCREMENT PRIMARY KEY,
    nombreLocal VARCHAR(100) NOT NULL,
    direccionLocal VARCHAR(100) NOT NULL,
    telefonoLocal VARCHAR(15) NOT NULL,
    rutEmpresa INT,
    
    FOREIGN KEY (rutEmpresa)
    REFERENCES Empresa(rutEmpresa)
);

CREATE TABLE IF NOT EXISTS Empleado(
	rutEmpleado VARCHAR(20) PRIMARY KEY,
    nombreEmpleado VARCHAR(50) NOT NULL,
    apellidoEmpleado VARCHAR(50) NOT NULL,
    telefonoEmpleado VARCHAR(15) NOT NULL,
    correoEmpleado VARCHAR(50) NOT NULL,
    idCargo INT NOT NULL,
    idLocal INT NOT NULL,
    
    FOREIGN KEY (idCargo)
    REFERENCES Cargo(idCargo),
	
    FOREIGN KEY (idLocal)
    REFERENCES LOCALL(idLocal)
);

CREATE TABLE IF NOT EXISTS SUELDO(
	rutEmpleado INT NOT NULL,
    fechaSueldo DATE NOT NULL,
    monto INT NOT NULL,
    
    PRIMARY KEY (rutEmpleado, fechaSueldo),
    
    FOREIGN KEY (rutEmpleado)
    REFERENCES Empleado(rutEmpleado)
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