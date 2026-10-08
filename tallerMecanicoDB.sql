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

