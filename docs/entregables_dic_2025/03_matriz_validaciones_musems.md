# Entregable 3. Matriz de Validaciones del Proceso MUSEMS

## 1. Introducción
La presente matriz concentra las validaciones funcionales y de calidad de datos aplicadas al flujo MUSEMS. Cada regla incluye su objetivo, tablas involucradas, severidad y script asociado. El inventario sirve como punto de referencia para QA, desarrollo y control escolar.

## 2. Tabla Maestra de Validaciones
| ID | Nombre de la validación | Objetivo | Tablas / vistas | Regla de negocio | Severidad | Script asociado |
|----|-------------------------|----------|------------------|------------------|-----------|-----------------|
| VAL-01 | Integridad y formato de CURP | Garantizar que cada registro tenga CURP válida antes de insertarse en `tbmu006_inscripcion`. | `tbae001_inscripcion`, `ctmu003_sexo`, `ctmu013_entidad_federativa` | La CURP debe cumplir regex oficial y los caracteres de sexo/entidad deben existir en catálogos activos. | Alta | `scripts/validaciones_musems/val_01_curp_formato.sql` |
| VAL-02 | Unicidad de matrícula y CURP | Evitar duplicidades entre cargas consecutivas. | `tbae001_inscripcion`, `tbmu006_inscripcion` | No debe existir más de un registro activo con misma combinación `matricula_alumno` + `curp_actual`. | Alta | `scripts/validaciones_musems/val_02_matricula_unica.sql` |
| VAL-03 | Existencia de CCT y programa académico | Validar que la combinación CCT-programa sea autorizada. | `tbae001_inscripcion`, `tbmu006_inscripcion`, catálogos de programas | Cada CCT debe tener programa registrado y vigente en el catálogo institucional. | Alta | `scripts/validaciones_musems/val_03_cct_programa.sql` |
| VAL-04 | Consistencia de certificados de origen | Confirmar folio y promedio de certificado. | `tbae001_inscripcion`, `ctmu008_motivo_error` | Cuando exista `folio_certificado`, el valor no puede ser nulo y el promedio debe ser numérico entre 6 y 10. | Media | `scripts/validaciones_musems/val_04_certificados_origen.sql` |
| VAL-05 | Asignación de turnos válidos | Revisar que el turno asignado pertenezca al catálogo vigente. | `tbmu006_inscripcion`, `ctmu001_tipo_periodo`, `ctmu011_estatus_procesamiento` | `id_turno` debe encontrarse activo en el catálogo y estar alineado con el tipo de periodo indicado. | Media | `scripts/validaciones_musems/val_05_turnos_validos.sql` |
| VAL-06 | Seguimiento de bajas vs inscripciones | Evitar reinscripciones con baja definitiva activa. | `tbae001_inscripcion`, `tbae002_bajas` | Si existe baja definitiva sin reactivación, bloquear nueva inscripción. | Alta | `scripts/validaciones_musems/val_06_bajas_vs_inscripciones.sql` |
| VAL-07 | Registro de asistencias | Verificar que asignaturas reportadas existan en catálogo y fechas sean válidas. | `tbae005_asistencias` | `fecha_asistencia` debe estar dentro del ciclo escolar vigente y la asignatura existe en catálogos. | Media | `scripts/validaciones_musems/val_07_asistencias.sql` |
| VAL-08 | Evidencia de notificación SIGED | Confirmar que registros consolidados fueron notificados. | `tbmu006_inscripcion` | Todos los registros con estatus "listo" deben tener `notificado_siged = true` en < 24h. | Alta | `scripts/validaciones_musems/val_08_notificacion_siged.sql` |

## 3. Trazabilidad
- Cada validación está alineada con los requerimientos descritos en [docs/matriz_trazabilidad_requerimientos.md](../matriz_trazabilidad_requerimientos.md).
- Las correcciones derivadas se documentan en la bitácora descrita en el Entregable 5.

## 4. Gestión de Cambios
- Las validaciones nuevas o modificadas deben registrarse en la columna de versión del script y notificarse en la minuta semanal.
- Las reglas de severidad Alta requieren aprobación de Control Escolar antes de entrar a producción.

## 5. Conclusión
La matriz provee una visión completa de las salvaguardas activas en MUSEMS. Su mantenimiento continuo garantiza coherencia entre datos, procesos y documentación, simplificando auditorías y facilitando la detección temprana de desviaciones.
