
-- Empleado con el mayor sueldo por cargo
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

-- Presupuesto con más actividades a realizar por mes en los últimos 2 años

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

-- Trabajo más rápido finalizado por mes durante el 2021

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

-- Vehículo con el mayor número de tareas realizadas sobre este

SELECT 
    T.id_trabajo,
    T.fecha_inicio,
    COUNT(DT.id_tarea) AS total_tareas_realizadas
FROM Trabajo T
JOIN Detalle_trabajo DT ON T.id_trabajo = DT.id_trabajo
GROUP BY T.id_trabajo, T.fecha_inicio
ORDER BY total_tareas_realizadas DESC
LIMIT 1;


-- Cantidad de presupuestos aceptados por local por mes, los últimos 5 años

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