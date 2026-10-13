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

-- =====================================================================
-- 6. Empleado con el mayor sueldo por cargo
-- =====================================================================
WITH SueldoMaxEmpleado AS (
    SELECT
        E.rutEmpleado,
        E.idCargo,
        MAX(S.monto) AS sueldo_max
    FROM Empleado E
    JOIN SUELDO S ON E.rutEmpleado = S.rutEmpleado
    GROUP BY E.rutEmpleado, E.idCargo
),
RankingPorCargo AS (
    SELECT
        rutEmpleado,
        idCargo,
        sueldo_max,
        RANK() OVER (PARTITION BY idCargo ORDER BY sueldo_max DESC) AS posicion
    FROM SueldoMaxEmpleado
)
SELECT
    C.nombreCargo,
    E.nombreEmpleado,
    E.apellidoEmpleado,
    R.sueldo_max AS mayor_sueldo
FROM RankingPorCargo R
JOIN Cargo C    ON R.idCargo = C.idCargo
JOIN Empleado E ON R.rutEmpleado = E.rutEmpleado
WHERE R.posicion = 1
ORDER BY mayor_sueldo DESC, C.nombreCargo;
 
 
-- =====================================================================
-- 7. Presupuesto con más actividades a realizar por mes en los últimos 2 años
-- =====================================================================
WITH PresupuestoMasAct AS (
    SELECT
        YEAR(P.fecha_emision)  AS anno,
        MONTH(P.fecha_emision) AS mes,
        P.id_presupuesto,
        COUNT(DP.id_tarea)     AS total_actividades,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(P.fecha_emision), MONTH(P.fecha_emision)
            ORDER BY COUNT(DP.id_tarea) DESC, P.fecha_emision DESC, P.id_presupuesto DESC
        ) AS posicion
    FROM Presupuesto P
    JOIN Detalle_presupuesto DP ON P.id_presupuesto = DP.id_presupuesto
    WHERE P.fecha_emision >= DATE_SUB(NOW(), INTERVAL 2 YEAR)
    GROUP BY YEAR(P.fecha_emision), MONTH(P.fecha_emision), P.id_presupuesto, P.fecha_emision
)

SELECT
    anno,
    mes,
    id_presupuesto,
    total_actividades
FROM PresupuestoMasAct
WHERE posicion = 1
ORDER BY anno DESC, mes DESC;
 
 
-- =====================================================================
-- 8. Trabajo más rápido finalizado por mes durante el 2021
-- =====================================================================
WITH TrabajosDuracion AS (
    SELECT
        YEAR(T.fecha_fin)  AS anno,
        MONTH(T.fecha_fin) AS mes,
        T.id_trabajo,
        T.id_presupuesto,
        T.id_local,
        T.fecha_inicio,
        T.fecha_fin,
        TIMESTAMPDIFF(MINUTE, T.fecha_inicio, T.fecha_fin) AS duracion_minutos,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(T.fecha_fin), MONTH(T.fecha_fin)
            ORDER BY TIMESTAMPDIFF(MINUTE, T.fecha_inicio, T.fecha_fin) ASC, T.id_trabajo ASC
        ) AS posicion
    FROM Trabajo T
    JOIN Estadot ET ON T.id_estadot = ET.id_estadot
    WHERE ET.nombre_estado = 'Terminado'
      AND T.fecha_fin IS NOT NULL
      AND T.fecha_fin >= '2021-01-01'
      AND T.fecha_fin <  '2022-01-01'
)
SELECT
    anno,
    mes,
    id_trabajo,
    id_presupuesto,
    id_local,
    fecha_inicio,
    fecha_fin,
    duracion_minutos
FROM TrabajosDuracion
WHERE posicion = 1
ORDER BY mes ASC;
 
 
-- =====================================================================
-- 9. Vehículo con el mayor número de tareas realizadas sobre este
-- =====================================================================
WITH TareasPorTrabajo AS (
    SELECT
        T.id_trabajo,
        T.id_presupuesto,
        T.id_local,
        T.fecha_inicio,
        T.fecha_fin,
        COUNT(DT.id_detalle_trabajo) AS total_tareas_realizadas,
        RANK() OVER (ORDER BY COUNT(DT.id_detalle_trabajo) DESC) AS posicion
    FROM Trabajo T
    JOIN Detalle_trabajo DT ON T.id_trabajo = DT.id_trabajo
    JOIN Estadot ED ON DT.id_estadot = ED.id_estadot
    WHERE ED.nombre_estado = 'Terminado'
    GROUP BY T.id_trabajo, T.id_presupuesto, T.id_local, T.fecha_inicio, T.fecha_fin
)
SELECT
    id_trabajo,
    id_presupuesto,
    id_local,
    fecha_inicio,
    fecha_fin,
    total_tareas_realizadas
FROM TareasPorTrabajo
WHERE posicion = 1
ORDER BY id_trabajo;
 
 
-- =====================================================================
-- 10. Cantidad de presupuestos aceptados por local por mes, últimos 5 años
-- =====================================================================
SELECT
    L.idLocal,
    L.nombreLocal,
    YEAR(P.fecha_emision)  AS anio,
    MONTH(P.fecha_emision) AS mes,
    COUNT(P.id_presupuesto) AS total_presupuestos_aceptados
FROM LOCALL L
JOIN Presupuesto P ON L.idLocal = P.id_local
WHERE P.estado_p = 'Aceptado'
  AND P.fecha_emision >= DATE_SUB(NOW(), INTERVAL 5 YEAR)
GROUP BY L.idLocal, L.nombreLocal, YEAR(P.fecha_emision), MONTH(P.fecha_emision)
ORDER BY anio DESC, mes DESC, total_presupuestos_aceptados DESC, L.idLocal;
 
 