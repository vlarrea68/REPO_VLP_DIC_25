/*
 * VAL-05: Turnos válidos en inscripciones consolidadas.
 * Objetivo: garantizar que toda inscripción activa haga referencia a un turno vigente.
 */
SELECT ins.id_inscripcion,
       ins.id_alumno,
       ins.id_turno,
       ins.id_ciclo_escolar,
       ins.id_tipo_periodo,
       ins.fcreacion,
       COALESCE(tr.descripcion, 'SIN_REGISTRO') AS descripcion_turno,
         CASE
           WHEN tr.id_turno IS NULL THEN 'TURNO_SIN_CATALOGO'
           WHEN tr.activo <> 'A' THEN 'TURNO_INACTIVO'
           WHEN ins.id_tipo_periodo NOT IN (SELECT id_tipo_periodo FROM muses_dev.ctmu001_tipo_periodo WHERE activo = 'A') THEN 'PERIODO_NO_ACTIVO'
           ELSE 'DESCONOCIDO'
       END AS motivo
FROM muses_dev.tbmu006_inscripcion ins
LEFT JOIN muses_dev.ctmu031_turno tr ON tr.id_turno = ins.id_turno
WHERE ins.activo = 'A'
  AND (
          tr.id_turno IS NULL
       OR tr.activo <> 'A'
       OR ins.id_tipo_periodo NOT IN (SELECT id_tipo_periodo FROM muses_dev.ctmu001_tipo_periodo WHERE activo = 'A')
      )
ORDER BY ins.fcreacion DESC;
