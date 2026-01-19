/*
 * VAL-01: Integridad y formato de CURP.
 * Objetivo: detectar registros con CURP nula, formato inválido o inconsistencias en sexo/entidad.
 * Modo de uso: ajustar las fechas en el CTE `params` según el lote a evaluar.
 */
WITH params AS (
    SELECT DATE '2025-12-01' AS fecha_inicio,
           DATE '2025-12-31' AS fecha_fin
), registros AS (
    SELECT ti.uuid,
           ti.id_operacion_origen,
           ti.id_subsistema,
           UPPER(TRIM(ti.curp_actual)) AS curp_norm,
           ti.fecha_actualizacion,
           ti.matricula_alumno
    FROM muses_dev.tbae001_inscripcion ti
    CROSS JOIN params p
    WHERE ti.fecha_actualizacion::date BETWEEN p.fecha_inicio AND p.fecha_fin
)
SELECT r.uuid,
       r.id_operacion_origen,
       r.id_subsistema,
       r.curp_norm AS curp_actual,
       CASE
           WHEN r.curp_norm IS NULL OR r.curp_norm = '' THEN 'CURP_VACIA'
           WHEN r.curp_norm !~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$' THEN 'FORMATO_INVALIDO'
           WHEN sx.id_sexo IS NULL THEN 'SEXO_NO_CATALOGADO'
           WHEN ef.id_entidad_federativa IS NULL THEN 'ENTIDAD_NO_CATALOGADA'
           ELSE 'DESCONOCIDO'
       END AS motivo,
       r.fecha_actualizacion
FROM registros r
LEFT JOIN muses_dev.ctmu003_sexo sx
       ON sx.clave = SUBSTRING(r.curp_norm FROM 11 FOR 1)
       AND sx.activo = 'A'
LEFT JOIN muses_dev.ctmu013_entidad_federativa ef
       ON ef.clave = SUBSTRING(r.curp_norm FROM 12 FOR 2)
       AND ef.activo = 'A'
WHERE r.curp_norm IS NULL
   OR r.curp_norm = ''
   OR r.curp_norm !~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$'
   OR sx.id_sexo IS NULL
   OR ef.id_entidad_federativa IS NULL
ORDER BY r.fecha_actualizacion DESC;
