
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
 