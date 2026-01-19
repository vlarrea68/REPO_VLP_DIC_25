/*
 * VAL-02: Unicidad de matrícula y CURP.
 * Objetivo: identificar duplicados dentro del lote y contra inscripciones activas.
 */
WITH params AS (
    SELECT DATE '2025-12-01' AS fecha_inicio,
           DATE '2025-12-31' AS fecha_fin
),
lote_actual AS (
    SELECT ti.uuid,
           ti.id_operacion_origen,
           ti.id_subsistema,
           UPPER(TRIM(ti.curp_actual)) AS curp_norm,
           UPPER(TRIM(ti.matricula_alumno)) AS matricula_norm,
           ti.fecha_actualizacion
    FROM muses_dev.tbae001_inscripcion ti
    CROSS JOIN params p
    WHERE ti.fecha_actualizacion::date BETWEEN p.fecha_inicio AND p.fecha_fin
),
master_curp AS (
    SELECT DISTINCT UPPER(TRIM(pe.curp)) AS curp_norm,
           ins.id_inscripcion,
           ins.id_estatus_inscripcion,
           ins.fcreacion
    FROM muses_dev.tbmu006_inscripcion ins
    JOIN muses_dev.tbmu002_persona pe ON pe.id_persona = ins.id_alumno
    WHERE ins.activo = 'A'
)
SELECT 'DUP_INTERNO' AS tipo,
       a.uuid,
       a.id_operacion_origen,
       a.matricula_norm,
       a.curp_norm,
       a.fecha_actualizacion,
       'Duplicado dentro del mismo lote' AS detalle
FROM lote_actual a
JOIN lote_actual b
  ON a.curp_norm = b.curp_norm
 AND a.uuid <> b.uuid
UNION ALL
SELECT 'DUP_MASTER' AS tipo,
       la.uuid,
       la.id_operacion_origen,
       la.matricula_norm,
       la.curp_norm,
       la.fecha_actualizacion,
       'Curp ya asociada a inscripción activa ' || master_curp.id_inscripcion AS detalle
FROM lote_actual la
JOIN master_curp ON master_curp.curp_norm = la.curp_norm
ORDER BY tipo, fecha_actualizacion;
