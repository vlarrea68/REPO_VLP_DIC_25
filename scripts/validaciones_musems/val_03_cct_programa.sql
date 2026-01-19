/*
 * VAL-03: Existencia y vigencia de CCT + programa académico.
 * Objetivo: asegurar que el CCT informado sea válido y que el programa exista en el catálogo activo.
 */
WITH params AS (
    SELECT DATE '2025-12-01' AS fecha_inicio,
           DATE '2025-12-31' AS fecha_fin
), lote_actual AS (
    SELECT ti.uuid,
           ti.id_operacion_origen,
           ti.cct,
           TRIM(ti.cve_programa_academico) AS cve_programa,
           ti.desc_prog_academico,
           ti.fecha_actualizacion
    FROM muses_dev.tbae001_inscripcion ti
    CROSS JOIN params p
    WHERE ti.fecha_actualizacion::date BETWEEN p.fecha_inicio AND p.fecha_fin
)
SELECT la.uuid,
       la.id_operacion_origen,
       la.cct,
       la.cve_programa,
       la.desc_prog_academico,
       CASE
           WHEN la.cct IS NULL OR la.cct = '' THEN 'CCT_VACIO'
           WHEN LENGTH(la.cct) NOT IN (9, 10) THEN 'CCT_LONGITUD_INVALIDA'
           WHEN prog.id_programa_academico IS NULL THEN 'PROGRAMA_NO_ENCONTRADO'
           WHEN prog.activo <> 'A' THEN 'PROGRAMA_INACTIVO'
           ELSE 'DESCONOCIDO'
       END AS motivo
FROM lote_actual la
LEFT JOIN muses_dev.tbmu007_programa_academico prog
       ON UPPER(prog.cve_programa_academico) = UPPER(la.cve_programa)
WHERE la.cct IS NULL
   OR la.cct = ''
   OR LENGTH(la.cct) NOT IN (9, 10)
   OR prog.id_programa_academico IS NULL
   OR prog.activo <> 'A';
