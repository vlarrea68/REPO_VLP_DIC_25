/*
 * VAL-07: Asistencias con fechas fuera de ciclo o asignaturas inexistentes.
 * Objetivo: validar registros antes de consolidar métricas académicas.
 */
WITH params AS (
    SELECT DATE '2025-08-26' AS ciclo_inicio,
           DATE '2026-07-15' AS ciclo_fin
)
SELECT ta.uuid,
       ta.id_operacion_origen,
       ta.id_subsistema,
       ta.matricula_alumno,
       ta.cve_asignatura,
       ta.asignatura,
       ta.fecha_asistencia,
       CASE
           WHEN ta.fecha_asistencia::date NOT BETWEEN params.ciclo_inicio AND params.ciclo_fin THEN 'FECHA_FUERA_DE_CICLO'
           WHEN asi.id_asignatura IS NULL THEN 'ASIGNATURA_NO_CATALOGADA'
           WHEN asi.activo <> 'A' THEN 'ASIGNATURA_INACTIVA'
           ELSE 'DESCONOCIDO'
       END AS motivo
FROM muses_dev.tbae005_asistencias ta
CROSS JOIN params
LEFT JOIN muses_dev.tbmu010_asignaturas asi
       ON UPPER(asi.cve_asignatura) = UPPER(ta.cve_asignatura)
WHERE ta.fecha_asistencia IS NULL
   OR ta.fecha_asistencia::date NOT BETWEEN params.ciclo_inicio AND params.ciclo_fin
   OR asi.id_asignatura IS NULL
   OR asi.activo <> 'A'
ORDER BY ta.fecha_asistencia DESC NULLS LAST;
