# Entregable 3. Matriz de Validaciones del Proceso MUSEMS

## 1. Introducción
Este entregable consolida las validaciones funcionales y de calidad de datos que gobiernan el flujo de MUSEMS. Cada regla incluye objetivo, contexto, tablas y columnas auditadas (según el diccionario de datos), requerimientos cubiertos y artefactos asociados (scripts SQL y bitácoras).

## 2. Tabla Maestra de Validaciones
| ID | Objetivo | Tablas/Columnas inspeccionadas | Reglas de negocio y requerimientos | Severidad | Script |
|----|----------|--------------------------------|------------------------------------|-----------|--------|
| VAL-01 | Validar integridad y formato de CURP previo a insertar en `tbmu006_inscripcion`. | `tbae001_inscripcion.curp_actual`, `ctmu003_sexo.clave`, `ctmu013_entidad_federativa.clave`, `tbmu005_curp_historica.curp`. | - Regex oficial `^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$`.<br>- Sexo y entidad deben existir y estar activos (RF-008).<br>- Registrar motivo en `tbae010_error`. | Alta | `scripts/validaciones_musems/val_01_curp_formato.sql` |
| VAL-02 | Asegurar unicidad matrícula+CURP entre staging y núcleo. | `tbae001_inscripcion.matricula_alumno`, `tbmu006_inscripcion.id_alumno`, `tbmu002_persona.curp`. | - No puede haber dos registros activos con misma combinación (RF-004, RF-010, RF-011).<br>- Rechazar duplicados con motivo `DPL_CURP`. | Alta | `.../val_02_matricula_unica.sql` |
| VAL-03 | Confirmar existencia y vigencia del programa académico asociado al CCT. | `tbae001_inscripcion.cct`, `tbae001_inscripcion.cve_programa_academico`, `tbmu007_programa_academico.cve_programa_academico`, `tbmu009_programa_institucion.id_programa_institucion`. | - Longitud CCT 9-10.<br>- Programa debe estar activo y ligado a institución (RF-009, RF-011).<br>- Registrar causa `PROGRAMA_NO_ENCONTRADO`. | Alta | `.../val_03_cct_programa.sql` |
| VAL-04 | Validar folio y promedio de certificado de procedencia. | `tbae001_inscripcion.folio_certificado`, `tbae001_inscripcion.promedio_certificado`, `tbae001_inscripcion.cct_procedencia`, catálogos `ctmu028_tipo_documento`. | - Si existe folio, promedio debe ser numérico entre 6 y 10 (dos decimales).<br>- CCT de procedencia obligatorio y activo (RF-007). | Media | `.../val_04_certificados_origen.sql` |
| VAL-05 | Verificar que los turnos asignados existan y estén activos. | `tbmu006_inscripcion.id_turno`, `ctmu031_turno.descripcion`, `ctmu001_tipo_periodo.id_tipo_periodo`. | - Turno obligatorio, activo y alineado al periodo (RF-011).<br>- Marcar `TURNO_INACTIVO` o `PERIODO_NO_ACTIVO`. | Media | `.../val_05_turnos_validos.sql` |
| VAL-06 | Bloquear reinscripciones con baja definitiva sin reactivación. | `tbae001_inscripcion.matricula_alumno`, `tbae002_bajas.tipo_baja`, `tbmu013_bajas.tipo_baja`. | - Si existe baja definitiva vigente (sin reactivación), inscripción debe quedar rechazada (RF-005). | Alta | `.../val_06_bajas_vs_inscripciones.sql` |
| VAL-07 | Revisar asistencias y asignaturas contra catálogos vigentes. | `tbae005_asistencias.fecha_asistencia`, `tbae005_asistencias.cve_asignatura`, `tbmu010_asignaturas.cve_asignatura`, `ctmu022_ciclo_escolar`. | - Fechas dentro del ciclo activo (26-AGO-2025 / 15-JUL-2026).<br>- Asignatura existente y activa (RF-006). | Media | `.../val_07_asistencias.sql` |
| VAL-08 | Garantizar que registros listos fueron notificados a SIGED. | `tbmu006_inscripcion.id_estatus_inscripcion`, `tbmu006_inscripcion.notificado_siged`, `ctmu014_estatus_inscripcion.descripcion`. | - Registros con estatus "validado"/"listo" deben tener `notificado_siged=true` < 24h (RF-013, RF-014). | Alta | `.../val_08_notificacion_siged.sql` |

## 3. Catálogos y Columnas Clave
- **`tbae001_inscripcion`** (staging): contiene `uuid`, `id_operacion_origen`, `id_subsistema`, `curp_actual`, `cct`, `folio_certificado`, `promedio_certificado`, etc., que alimentan VAL-01–VAL-04.
- **`tbmu006_inscripcion`** (núcleo): concentra `id_inscripcion`, `id_alumno`, `id_programa_institucion`, `id_turno`, `notificado_siged`, `id_estatus_inscripcion`; fuente para VAL-02, VAL-05 y VAL-08.
- **Catálogos `ctmu*`**: tipos de periodo, sexo, entidad federativa, turnos, estatus de inscripción; todos mantienen `activo` y marcas de tiempo para validar vigencias.
- **Tablas de error y trazabilidad**: `tbae009_respuesta` y `tbae010_error` registran la salida de cada validación con `id_motivo_error` enlazado a `ctmu008_motivo_error`.

## 4. Trazabilidad con Requerimientos
| Validación | Requerimientos cubiertos | Casos de prueba asociados |
|------------|-------------------------|---------------------------|
| VAL-01 | RF-004, RF-007, RF-008 | CP-008, CP-009, CP-013, CP-014 |
| VAL-02 | RF-004, RF-010, RF-011 | CP-008, CP-017, CP-018 |
| VAL-03 | RF-009, RF-011 | CP-015, CP-016 |
| VAL-04 | RF-007 | CP-012 |
| VAL-05 | RF-011 | CP-018 |
| VAL-06 | RF-005 | CP-010 |
| VAL-07 | RF-006 | CP-011 |
| VAL-08 | RF-012, RF-013, RF-014 | CP-020, CP-022, CP-023 |

## 5. Gestión y Mantenimiento
- Cada script tiene versión y hash registrado en la bitácora; cualquier cambio requiere revisión del comité QA + Control Escolar.
- Las validaciones de severidad Alta deben ejecutarse en cada lote y antes de promover datos a producción; las de severidad Media se ejecutan por lote o al cierre semanal.
- Nuevas reglas siguen el flujo: definición → prototipo SQL → revisión técnica → actualización de matriz con objetivo, tablas, requerimientos y severidad → comunicación en la minuta semanal con responsables.

## 6. Conclusión
Con la información disponible, el sistema desarrollado no cumple todavía con las pruebas definidas en esta matriz: las corridas de VAL-01–VAL-08 no se han completado ni documentado y tampoco existen resultados para las validaciones planificadas (VAL-09 en adelante). Además de este incumplimiento, el área de desarrollo debe automatizar las reglas pendientes, cerrar los planes de remediación ante fallas y asegurar la instrumentación en CI/CD; el equipo de pruebas debe generar las evidencias faltantes, formalizar los criterios de aceptación por subsistema y calendarizar ejecuciones integrales antes de liberar nuevos lotes. Mientras estos compromisos sigan abiertos, la matriz refleja el alcance deseado pero el flujo MUSEMS no puede considerarse validado ni listo para operación estable.
