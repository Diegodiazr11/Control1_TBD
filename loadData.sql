USE tallerMecanico;

-- ---------------------------------------------------------------------
-- 1. Empresa (15)
-- ---------------------------------------------------------------------
INSERT INTO Empresa (rutEmpresa, nombreEmpresa, telefonoEmpresa, correoEmpresa) VALUES
('76123456-7', 'Servicios Automotrices Master Ltda', '+56223445566', 'contacto@mastertaller.cl'),
('76987654-3', 'Red de Talleres Mecánicos del Sur SpA', '+56229887766', 'admin@talleressur.cl'),
('77111222-K', 'AutoFix Chile S.A.', '+56224445588', 'soporte@autofix.cl'),
('78333444-1', 'Mecánica Integral Los Conquistadores', '+56227778899', 'contacto@conquistadores.cl'),
('79555666-8', 'Tecnología Automotriz Avanzada Ltda', '+56221112233', 'info@tecnoauto.cl'),
('76222333-4', 'Talleres Mecánicos del Norte SpA', '+56552334455', 'norte@talleres.cl'),
('77333444-5', 'Servicios Integrales del Maipo', '+56228556677', 'maipo@servicios.cl'),
('78444555-6', 'Mecánica Express Santiago', '+56229112233', 'express@santiago.cl'),
('79666777-8', 'AutoServicios Austral', '+56612223344', 'austral@autos.cl'),
('76777888-9', 'Repuestos y Talleres El Trébol', '+56226334455', 'trebol@talleres.cl'),
('77888999-0', 'Inversiones Mecánicas Valparaíso', '+56322112233', 'valpo@mecanica.cl'),
('78999000-1', 'Centro Automotriz Concepción', '+56412556677', 'conce@auto.cl'),
('79000111-2', 'Servicios Mecánicos La Serena', '+56512334455', 'serena@talleres.cl'),
('76111222-3', 'Taller Mecánico Ruta 5 Sur', '+56712445566', 'ruta5@taller.cl'),
('77222333-4', 'Soluciones Automotrices Globales', '+56227889900', 'global@autofix.cl');

-- ---------------------------------------------------------------------
-- 2. Cargo (15)
-- ---------------------------------------------------------------------
INSERT INTO Cargo (idCargo, nombreCargo, descripcionCargo) VALUES
(1, 'Mecánico Senior', 'Encargado de reparaciones complejas de motor'),
(2, 'Mecánico Junior', 'Asistente en mantenciones preventivas'),
(3, 'Jefe de Local', 'Administra la sucursal y presupuestos'),
(4, 'Recepcionista', 'Atención al cliente y gestión de citas'),
(5, 'Especialista en Electrónica', 'Diagnóstico computarizado y sistemas eléctricos'),
(6, 'Especialista en Frenos', 'Revisión y rectificación de sistemas de frenado'),
(7, 'Técnico en Suspensión', 'Cambio de amortiguadores y tren delantero'),
(8, 'Chapista / Carrocero', 'Reparación de carrocería y enderezado'),
(9, 'Pintor Automotriz', 'Aplicación de pintura y pulido de piezas'),
(10, 'Asesor de Servicio', 'Recepción de vehículos y cotización con clientes'),
(11, 'Supervisor de Calidad', 'Inspección final de trabajos terminados'),
(12, 'Bodeguero de Repuestos', 'Control de stock e inventario de piezas'),
(13, 'Técnico en Climatización', 'Reparación de aire acondicionado y calefacción'),
(14, 'Auxiliar de Limpieza', 'Mantención y orden de las dependencias del taller'),
(15, 'Gerente de Operaciones', 'Supervisión general de la red de talleres');

-- ---------------------------------------------------------------------
-- 3. Estadop (2)
-- ---------------------------------------------------------------------
INSERT INTO Estadop (id_estadop, nombre_estado) VALUES
(1, 'Aceptado'),
(2, 'Rechazado');

-- ---------------------------------------------------------------------
-- 4. Estadot (3)
-- ---------------------------------------------------------------------
INSERT INTO Estadot (id_estadot, nombre_estado) VALUES
(1, 'Iniciado'),
(2, 'En proceso'),
(3, 'Terminado');

-- ---------------------------------------------------------------------
-- 5. LOCALL (15)
-- ---------------------------------------------------------------------
INSERT INTO LOCALL (idLocal, nombreLocal, direccionLocal, telefonoLocal, rutEmpresa) VALUES
(1, 'Taller Central Santiago', 'Av. Vicuña Mackenna 4500', '+56225554433', '76123456-7'),
(2, 'Sucursal Maipú', 'Av. Pajaritos 1200', '+56226667788', '76123456-7'),
(3, 'Sucursal Talagante', 'Camino Lonquén 850', '+56228112233', '76987654-3'),
(4, 'Sucursal Viña del Mar', 'Av. Libertad 1250', '+56322998877', '77111222-K'),
(5, 'Sucursal Concepción', 'Barros Arana 600', '+56412334455', '78333444-1'),
(6, 'Sucursal Antofagasta', 'Av. Argentina 1400', '+56552112233', '79555666-8'),
(7, 'Sucursal Temuco', 'Av. Alemania 0450', '+56452223344', '76222333-4'),
(8, 'Sucursal La Serena', 'Av. Francisco de Aguirre 500', '+56512445566', '77333444-5'),
(9, 'Sucursal Rancagua', 'Carretera Ruta 5 Sur Km 70', '+56722334455', '78444555-6'),
(10, 'Sucursal Curicó', 'Pedro Nolasco Videla 300', '+56752112233', '79666777-8'),
(11, 'Sucursal Talca', 'Calle 1 Norte 1200', '+56712334455', '76777888-9'),
(12, 'Sucursal Chillán', 'Av. Libertad 800', '+56422223344', '77888999-0'),
(13, 'Sucursal Valdivia', 'Picarte 1500', '+56632223344', '78999000-1'),
(14, 'Sucursal Puerto Montt', 'Av. Presidente Ibáñez 900', '+56652334455', '79000111-2'),
(15, 'Sucursal Puente Alto', 'Av. Concha y Toro 2500', '+56224445566', '76111222-3');

-- ---------------------------------------------------------------------
-- 6. Empleado (16)
-- ---------------------------------------------------------------------
INSERT INTO Empleado (rutEmpleado, nombreEmpleado, apellidoEmpleado, telefonoEmpleado, correoEmpleado, idCargo, idLocal) VALUES
('15234567-8', 'Carlos', 'Pérez', '+56911223344', 'cperez@mastertaller.cl', 1, 1),
('17345678-9', 'Esteban', 'González', '+56922334455', 'egonzalez@mastertaller.cl', 2, 1),
('14123456-5', 'Marcela', 'Rojas', '+56933445566', 'mrojas@mastertaller.cl', 3, 1),
('18987654-2', 'Daniela', 'Soto', '+56944556677', 'dsoto@mastertaller.cl', 4, 2),
('16456789-1', 'Matías', 'Muñoz', '+56955667788', 'mmunoz@mastertaller.cl', 5, 2),
('19111222-3', 'Valentina', 'Silva', '+56966778899', 'vsilva@mastertaller.cl', 1, 3),
('13888999-4', 'Rodrigo', 'Contreras', '+56977889900', 'rcontreras@mastertaller.cl', 2, 3),
('20123456-7', 'Ignacio', 'Vidal', '+56988990011', 'ividal@mastertaller.cl', 3, 3),
('17555666-8', 'Camila', 'Araya', '+56999001122', 'caraya@autofix.cl', 1, 4),
('15444333-2', 'Felipe', 'Morales', '+56911223355', 'fmorales@autofix.cl', 2, 4),
('18777888-9', 'Francisca', 'Navarro', '+56922334466', 'fnavarro@autofix.cl', 3, 4),
('14999888-1', 'Diego', 'Riquelme', '+56933445577', 'driquelme@conquistadores.cl', 1, 5),
('16222333-4', 'Sofía', 'Espinoza', '+56944556688', 'sespinoza@conquistadores.cl', 2, 5),
('19333444-5', 'Lucas', 'Fuentes', '+56955667799', 'lfuentes@conquistadores.cl', 4, 5),
('17888777-6', 'Antonia', 'Bravo', '+56966778800', 'abravo@mastertaller.cl', 5, 1),
('21444555-0', 'Benjamín', 'Gatica', '+56977889911', 'bgatica@mastertaller.cl', 2, 2);

-- ---------------------------------------------------------------------
-- 7. SUELDO (16)
-- ---------------------------------------------------------------------
INSERT INTO SUELDO (rutEmpleado, fechaSueldo, monto) VALUES
('15234567-8', '2026-09-01', 1350000),
('17345678-9', '2026-09-01', 850000),
('14123456-5', '2026-09-01', 1600000),
('18987654-2', '2026-09-01', 700000),
('16456789-1', '2026-09-01', 1150000),
('19111222-3', '2026-09-01', 1400000),
('13888999-4', '2026-09-01', 820000),
('20123456-7', '2026-09-01', 1550000),
('17555666-8', '2026-09-01', 1300000),
('15444333-2', '2026-09-01', 800000),
('18777888-9', '2026-09-01', 1500000),
('14999888-1', '2026-09-01', 1380000),
('16222333-4', '2026-09-01', 780000),
('19333444-5', '2026-09-01', 680000),
('17888777-6', '2026-09-01', 1250000),
('21444555-0', '2026-09-01', 760000);

-- ---------------------------------------------------------------------
-- 8. SERVICIO (15)
-- ---------------------------------------------------------------------
INSERT INTO SERVICIO (idServicio, nombreServicio, descripcionServicio) VALUES
(1, 'Afinamiento Completo', 'Cambio de bujías, filtros y revisión de inyección'),
(2, 'Reparación de Frenos', 'Rectificación de discos y cambio de pastillas'),
(3, 'Cambio de Correa de Distribución', 'Sustitución de kit de distribución y bomba de agua'),
(4, 'Mantención por Kilometraje (10k)', 'Cambio de aceite, filtros y revisión general'),
(5, 'Alineación y Balanceo', 'Calibración geométrica de dirección y balanceo de ruedas'),
(6, 'Diagnóstico Electrónico OBD2', 'Escaneo computarizado de códigos de falla'),
(7, 'Cambio de Embrague', 'Sustitución de disco, prensa y collarín'),
(8, 'Reparación de Suspensión', 'Cambio de amortiguadores y bandejas'),
(9, 'Limpieza de Inyectores', 'Ultrasonido y prueba de inyectores de bencina/diésel'),
(10, 'Revisión Técnica Previa', 'Inspección de 50 puntos para plantas de revisión'),
(11, 'Cambio de Batería y Alternador', 'Prueba de carga y reemplazo de acumulador'),
(12, 'Rectificación de Motores', 'Trabajo completo en culata y cilindros'),
(13, 'Aire Acondicionado Carga de Gas', 'Recarga de refrigerante R134a y revisión de fugas'),
(14, 'Cambio de Sistema de Escape', 'Sustitución de silenciadores y convertidor catalítico'),
(15, 'Tratamiento Cerómico de Pintura', 'Pulido y protección de carrocería');

-- ---------------------------------------------------------------------
-- 9. SERVICIO_LOCAL (15)
-- ---------------------------------------------------------------------
INSERT INTO SERVICIO_LOCAL (fechaServicio, idServicio, idLocal) VALUES
('2026-01-10 08:00:00', 1, 1),
('2026-02-15 08:00:00', 2, 1),
('2021-05-10 09:00:00', 3, 2),
('2021-06-12 10:00:00', 4, 2),
('2021-07-20 11:00:00', 5, 3),
('2022-03-14 08:30:00', 6, 3),
('2022-08-19 09:30:00', 7, 4),
('2023-01-05 10:30:00', 8, 4),
('2023-05-22 08:00:00', 9, 5),
('2024-02-11 09:00:00', 10, 5),
('2024-06-18 10:00:00', 11, 1),
('2025-01-30 11:00:00', 12, 2),
('2025-04-15 08:30:00', 13, 3),
('2025-09-09 09:30:00', 14, 4),
('2026-02-28 10:30:00', 15, 5);

-- ---------------------------------------------------------------------
-- 10. TAREA (15)
-- ---------------------------------------------------------------------
INSERT INTO TAREA (idTarea, nombreTarea, fechaInicioTarea, fechaFinTarea, descripcionTarea, costoTarea) VALUES
(1, 'Desmontaje de culata', '2021-06-01 09:00:00', '2021-06-01 12:00:00', 'Extracción de componentes superiores del motor', 45000),
(2, 'Cambio de pastillas de freno', '2021-06-02 10:00:00', '2021-06-02 11:30:00', 'Sustitución de sistema de frenado delantero', 25000),
(3, 'Escaneo computarizado', '2026-03-10 08:30:00', '2026-03-10 09:15:00', 'Diagnóstico por puerto OBD2', 20000),
(4, 'Sustitución de aceite sintético', '2021-06-05 09:00:00', '2021-06-05 10:00:00', 'Cambio de aceite 5W30 y filtro', 18000),
(5, 'Balanceo de neumáticos', '2021-06-08 11:00:00', '2021-06-08 12:00:00', 'Calibración en máquina estática', 15000),
(6, 'Cambio de kit distribución', '2021-06-10 08:00:00', '2021-06-10 13:00:00', 'Instalación de correa dentada y tensor', 85000),
(7, 'Rectificación de discos', '2021-06-15 14:00:00', '2021-06-15 16:00:00', 'Mecanizado de discos de freno', 30000),
(8, 'Prueba de banco alternador', '2021-06-20 09:30:00', '2021-06-20 10:30:00', 'Verificación de carga eléctrica', 22000),
(9, 'Limpieza de inyectores', '2021-06-25 10:00:00', '2021-06-25 13:00: