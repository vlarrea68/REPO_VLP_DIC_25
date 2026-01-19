/*
 * VAL-04: Consistencia de certificados de origen y promedios.
 * Objetivo: validar folio, promedio y datos de procedencia.
 */
WITH params AS (
    SELECT DATE '2025-12-01' AS fecha_inicio,
           DATE '2025-12-31' AS fecha_fin
), lote_actual AS (
    SELECT ti.uuid,
           ti.id_operacion_origen,
           ti.matricula_alumno,
           ti.folio_certificado,
           ti.promedio_certificado,
           ti.cct_procedencia,
           ti.tipo_documento,
           ti.fecha_actualizacion
    FROM muses_dev.tbae001_inscripcion ti
    CROSS JOIN params p
    WHERE ti.fecha_actualizacion::date BETWEEN p.fecha_inicio AND p.fecha_fin
)
SELECT la.uuid,
       la.id_operacion_origen,
       la.matricula_alumno,
       la.folio_certificado,
       la.promedio_certificado,
       la.cct_procedencia,
       CASE
           WHEN la.folio_certificado IS NULL OR la.folio_certificado = '' THEN 'FOLIO_VACIO'
           WHEN la.cct_procedencia IS NULL OR la.cct_procedencia = '' THEN 'CCT_PROCEDENCIA_VACIO'
           WHEN la.promedio_certificado !~ '^[0-9]+(\.[0-9]+)?$' THEN 'PROMEDIO_NO_NUMERICO'
           WHEN la.promedio_certificado::numeric < 6 OR la.promedio_certificado::numeric > 10 THEN 'PROMEDIO_FUERA_RANGO'
           ELSE 'DESCONOCIDO'
       END AS motivo
FROM lote_actual la
WHERE (la.folio_certificado IS NOT NULL AND la.folio_certificado <> '')
  AND (
          la.cct_procedencia IS NULL
       OR la.cct_procedencia = ''
       OR la.promedio_certificado IS NULL
       OR la.promedio_certificado = ''
       OR la.promedio_certificado !~ '^[0-9]+(\.[0-9]+)?$'
       OR la.promedio_certificado::numeric < 6
       OR la.promedio_certificado::numeric > 10
      );
