-- 1. Presupuesto más caro realizado por año y valor total
SELECT
    YEAR(P.fecha_emision) AS anio,
    P.id_presupuesto,
    P.total AS valor_total
FROM Presupuesto P
WHERE P.total = (
    SELECT MAX(P2.total)
    FROM Presupuesto P2
    WHERE YEAR(P2.fecha_emision) = YEAR(P.fecha_emision)
)
ORDER BY anio;


-- 2. Empleado que participó en más trabajos el 2020
SELECT
    E.idEmpleado,
    E.rutEmpleado,
    E.nombreEmpleado,
    E.apellidoEmpleado,
    COUNT(*) AS total_trabajos
FROM Trabajo T
JOIN Empleado E
    ON T.id_jefeProyecto = E.idEmpleado
WHERE YEAR(T.fecha_inicio) = 2020
GROUP BY
    E.idEmpleado,
    E.rutEmpleado,
    E.nombreEmpleado,
    E.apellidoEmpleado
ORDER BY total_trabajos DESC
LIMIT 1;


-- 3. Trabajos finalizados por mes durante el 2020
SELECT
    MONTH(T.fecha_fin) AS mes,
    COUNT(*) AS trabajos_finalizados
FROM Trabajo T
JOIN Estadot E
    ON T.id_estadot = E.id_estadot
WHERE YEAR(T.fecha_fin) = 2020
  AND E.nombre_estado = 'Terminado'
GROUP BY MONTH(T.fecha_fin)
ORDER BY mes;


-- 4. Empleado con más presupuestos rechazados

WITH rechazados_empleado AS (
    SELECT
        E.idEmpleado,
        E.rutEmpleado,
        E.nombreEmpleado,
        E.apellidoEmpleado,
        COUNT(*) AS presupuestos_rechazados
    FROM Presupuesto P
    JOIN Empleado E
        ON P.id_local = E.idLocal
    WHERE P.estado_p = 'Rechazado'
      AND E.tipoEmpleado = 'Jefe de proyecto'
    GROUP BY
        E.idEmpleado,
        E.rutEmpleado,
        E.nombreEmpleado,
        E.apellidoEmpleado
),
ranking_rechazados AS (
    SELECT *,
        DENSE_RANK() OVER (
            ORDER BY presupuestos_rechazados DESC
        ) AS posicion
    FROM rechazados_empleado
)
SELECT
    idEmpleado,
    rutEmpleado,
    nombreEmpleado,
    apellidoEmpleado,
    presupuestos_rechazados
FROM ranking_rechazados
WHERE posicion = 1;


-- 5. Tarea más realizada por trabajo
WITH tareas_por_trabajo AS (
    SELECT
        DT.id_trabajo,
        DT.id_tarea,
        TA.nombreTarea,
        COUNT(*) AS cantidad,
        DENSE_RANK() OVER (
            PARTITION BY DT.id_trabajo
            ORDER BY COUNT(*) DESC
        ) AS posicion
    FROM Detalle_trabajo DT
    JOIN TAREA TA
        ON DT.id_tarea = TA.idTarea
    GROUP BY
        DT.id_trabajo,
        DT.id_tarea,
        TA.nombreTarea
)
SELECT
    id_trabajo,
    id_tarea,
    nombreTarea,
    cantidad
FROM tareas_por_trabajo
WHERE posicion = 1
ORDER BY id_trabajo;

-- 6. Empleado con el mayor sueldo por cargo
SELECT 
    C.nombreCargo,
    E.nombreEmpleado,
    E.apellidoEmpleado,
    S.monto AS mayor_sueldo
FROM Cargo C
JOIN Empleado E ON C.idCargo = E.idCargo
JOIN SUELDO S ON E.rutEmpleado = S.rutEmpleado
WHERE S.monto = (
    SELECT MAX(S2.monto)
    FROM Sueldo S2
    JOIN Empleado E2 ON S2.rutEmpleado = E2.rutEmpleado
    WHERE E2.idCargo = C.idCargo
)
GROUP BY C.idCargo, C.nombreCargo, E.rutEmpleado, E.nombreEmpleado, E.apellidoEmpleado, S.monto
ORDER BY mayor_sueldo DESC;

-- 7. Presupuesto con más actividades a realizar por mes en los últimos 2 años

SELECT 
    YEAR(P.fecha_emision) AS anno,
    MONTH(P.fecha_emision) AS mes,
    P.id_presupuesto,
    COUNT(DP.id_tarea) AS total_actividades
FROM Presupuesto P
JOIN Detalle_presupuesto DP ON P.id_presupuesto = DP.id_presupuesto
WHERE P.fecha_emision >= DATE_SUB(NOW(), INTERVAL 2 YEAR)
GROUP BY YEAR(P.fecha_emision), MONTH(P.fecha_emision), P.id_presupuesto
ORDER BY anno DESC, mes DESC, total_actividades DESC;

-- 8. Trabajo más rápido finalizado por mes durante el 2021

SELECT 
    MONTH(T.fecha_inicio) AS mes,
    T.id_trabajo,
    T.fecha_inicio,
    T.fecha_fin,
    TIMESTAMPDIFF(HOUR, T.fecha_inicio, T.fecha_fin) AS duracion_horas
FROM Trabajo T
WHERE YEAR(T.fecha_inicio) = 2021
  AND T.fecha_fin IS NOT NULL
  AND TIMESTAMPDIFF(HOUR, T.fecha_inicio, T.fecha_fin) = (
      SELECT MIN(TIMESTAMPDIFF(HOUR, T2.fecha_inicio, T2.fecha_fin))
      FROM Trabajo T2
      WHERE YEAR(T2.fecha_inicio) = 2021
        AND T2.fecha_fin IS NOT NULL
        AND MONTH(T2.fecha_inicio) = MONTH(T.fecha_inicio)
  )
GROUP BY MONTH(T.fecha_inicio), T.id_trabajo, T.fecha_inicio, T.fecha_fin
ORDER BY mes;

-- 9. Vehículo con el mayor número de tareas realizadas sobre este

SELECT 
    T.id_trabajo,
    T.fecha_inicio,
    COUNT(DT.id_tarea) AS total_tareas_realizadas
FROM Trabajo T
JOIN Detalle_trabajo DT ON T.id_trabajo = DT.id_trabajo
GROUP BY T.id_trabajo, T.fecha_inicio
ORDER BY total_tareas_realizadas DESC
LIMIT 1;


-- 10. Cantidad de presupuestos aceptados por local por mes, los últimos 5 años

SELECT 
    L.nombreLocal,
    YEAR(P.fecha_emision) AS anio,
    MONTH(P.fecha_emision) AS mes,
    COUNT(P.id_presupuesto) AS total_presupuestos_aceptados
FROM LOCALL L
JOIN Presupuesto P ON L.idLocal = P.id_local
WHERE P.estado_p = 'Aceptado'
  AND P.fecha_emision >= DATE_SUB(NOW(), INTERVAL 5 YEAR)
GROUP BY L.idLocal, L.nombreLocal, YEAR(P.fecha_emision), MONTH(P.fecha_emision)
ORDER BY anio DESC, mes DESC, total_presupuestos_aceptados DESC;