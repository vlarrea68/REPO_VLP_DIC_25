/*
 * VAL-06: Reinscripciones con baja definitiva activa.
 * Objetivo: bloquear registros con historial de baja definitiva sin reactivación documentada.
 */
WITH params AS (
    SELECT DATE '2025-12-01' AS fecha_inicio,
           DATE '2025-12-31' AS fecha_fin
), lote_actual AS (
    SELECT ti.uuid,
           ti.id_operacion_origen,
           ti.id_subsistema,
           UPPER(TRIM(ti.matricula_alumno)) AS matricula_norm,
           UPPER(TRIM(ti.curp_actual)) AS curp_norm,
           ti.fecha_inscripcion,
           ti.fecha_actualizacion
    FROM muses_dev.tbae001_inscripcion ti
    CROSS JOIN params p
    WHERE ti.fecha_actualizacion::date BETWEEN p.fecha_inicio AND p.fecha_fin
)
SELECT la.uuid,
       la.id_operacion_origen,
       la.id_subsistema,
       la.matricula_norm,
       la.curp_norm,
       la.fecha_inscripcion,
       bajas.tipo_baja,
       bajas.fecha_baja,
       'BAJA_DEFINITIVA_ACTIVA' AS motivo
FROM lote_actual la
JOIN muses_dev.tbae002_bajas bajas
  ON bajas.id_subsistema = la.id_subsistema
 AND UPPER(TRIM(bajas.matricula_alumno)) = la.matricula_norm
WHERE LOWER(TRIM(bajas.tipo_baja)) = 'baja definitiva'
  AND (bajas.fecha_baja IS NULL OR bajas.fecha_baja <= COALESCE(la.fecha_inscripcion, la.fecha_actualizacion))
  AND (bajas.id_estatus_procesamiento IS NULL OR bajas.id_estatus_procesamiento <> 3);
