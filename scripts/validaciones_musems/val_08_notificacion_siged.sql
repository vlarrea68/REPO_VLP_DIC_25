/*
 * VAL-08: Notificación oportuna a SIGED.
 * Objetivo: identificar inscripciones listas para publicarse pero sin bandera `notificado_siged`.
 */
WITH estados_objetivo AS (
    SELECT id_estatus_inscripcion
    FROM muses_dev.ctmu014_estatus_inscripcion
    WHERE LOWER(descripcion) IN ('validado', 'listo para notificacion')
), pendientes AS (
    SELECT ins.id_inscripcion,
           ins.id_alumno,
           ins.id_estatus_inscripcion,
           ins.fcreacion,
           ins.fmodificacion,
           ins.notificado_siged,
           NOW() AS fecha_revision
    FROM muses_dev.tbmu006_inscripcion ins
    WHERE ins.activo = 'A'
      AND ins.id_estatus_inscripcion IN (SELECT id_estatus_inscripcion FROM estados_objetivo)
      AND COALESCE(ins.notificado_siged, false) = false
)
SELECT p.id_inscripcion,
       p.id_alumno,
       p.id_estatus_inscripcion,
       p.fcreacion,
       p.fmodificacion,
       EXTRACT(EPOCH FROM (p.fecha_revision - COALESCE(p.fmodificacion, p.fcreacion))) / 3600 AS horas_sin_notificar,
       CASE
           WHEN p.fcreacion < NOW() - INTERVAL '24 hours' THEN 'VENTANA_24H_SUPERADA'
           ELSE 'EN_RANGO'
       END AS estado
FROM pendientes p
ORDER BY p.fcreacion;
