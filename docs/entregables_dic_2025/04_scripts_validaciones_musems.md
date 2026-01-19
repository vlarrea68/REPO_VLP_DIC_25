# Entregable 4. Scripts de Validación del Proceso MUSEMS

## 1. Propósito
Este entregable describe los ocho scripts SQL que automatizan las validaciones críticas del flujo MUSEMS. Para cada script se documenta objetivo, tablas involucradas, parámetros, forma de ejecución y mecanismos de versionamiento, de modo que cualquier equipo pueda implementarlos sin consultar fuentes adicionales.

## 2. Inventario de Scripts
| ID | Archivo | Objetivo | Tablas clave | Resultado |
|----|---------|----------|--------------|-----------|
| VAL-01 | `scripts/validaciones_musems/val_01_curp_formato.sql` | Validar formato e integridad de CURP antes de consolidar en `tbmu006_inscripcion`. | `tbae001_inscripcion`, `ctmu003_sexo`, `ctmu013_entidad_federativa`, `tbmu005_curp_historica` | Lista de registros con motivo `FORMATO_INVALIDO`, `SEXO_NO_CATALOGADO`, etc. |
| VAL-02 | `scripts/validaciones_musems/val_02_matricula_unica.sql` | Detectar duplicados matrícula+CURP en staging y núcleo. | `tbae001_inscripcion`, `tbmu006_inscripcion`, `tbmu002_persona` | Registros etiquetados como `DUP_INTERNO` o `DUP_MASTER`. |
| VAL-03 | `scripts/validaciones_musems/val_03_cct_programa.sql` | Verificar existencia y vigencia de CCT/programa académico. | `tbae001_inscripcion`, `tbmu007_programa_academico`, `tbmu009_programa_institucion` | Registros con motivos `CCT_VACIO`, `PROGRAMA_NO_ENCONTRADO`, etc. |
| VAL-04 | `scripts/validaciones_musems/val_04_certificados_origen.sql` | Validar folio, promedio y CCT de procedencia. | `tbae001_inscripcion`, catálogos de documentos | Registros con `PROMEDIO_FUERA_RANGO`, `FOLIO_VACIO`, etc. |
| VAL-05 | `scripts/validaciones_musems/val_05_turnos_validos.sql` | Confirmar que inscripciones activas tengan turno y periodo vigentes. | `tbmu006_inscripcion`, `ctmu031_turno`, `ctmu001_tipo_periodo` | Lista de inscripciones con `TURNO_SIN_CATALOGO`, `TURNO_INACTIVO`, `PERIODO_NO_ACTIVO`. |
| VAL-06 | `scripts/validaciones_musems/val_06_bajas_vs_inscripciones.sql` | Bloquear reinscripciones con baja definitiva sin reactivación. | `tbae001_inscripcion`, `tbae002_bajas`, `tbmu013_bajas` | Registros con motivo `BAJA_DEFINITIVA_ACTIVA`. |
| VAL-07 | `scripts/validaciones_musems/val_07_asistencias.sql` | Validar asignaturas y fechas de asistencia contra catálogos vigentes. | `tbae005_asistencias`, `tbmu010_asignaturas`, `ctmu022_ciclo_escolar` | Resultados `FECHA_FUERA_DE_CICLO`, `ASIGNATURA_NO_CATALOGADA`, etc. |
| VAL-08 | `scripts/validaciones_musems/val_08_notificacion_siged.sql` | Confirmar notificación oportuna a SIGED para inscripciones listas. | `tbmu006_inscripcion`, `ctmu014_estatus_inscripcion` | Registros con `VENTANA_24H_SUPERADA`. |

## 3. Parámetros y Configuración
Todos los scripts siguen un patrón común:
- **CTE `params`:** define `fecha_inicio` y `fecha_fin` (o límites del ciclo). Ajustar estos valores para delimitar el lote a evaluar.
- **Esquema:** se asume `SET search_path TO muses_dev;` para evitar prefijos redundantes.
- **Filtros:** los scripts filtran por `fecha_actualizacion`, `fecha_inscripcion` o campos equivalentes, por lo que es indispensable conocer la ventana real del lote.
- **Exportación:** utilizar `COPY (<consulta>) TO 'ruta\archivo.csv' WITH CSV HEADER` o `
\copy` para generar la evidencia.

## 4. Procedimiento de Ejecución Recomendado
1. **Preparar ambiente:**
   - Refrescar catálogos `ctmu*` y respaldar tablas involucradas.
   - Verificar conectividad y permisos en el esquema `muses_dev`.
2. **Ejecutar script:**
   ```sql
   \timing on
   SET search_path TO muses_dev;
   \i scripts/validaciones_musems/val_01_curp_formato.sql;
   ```
   Ajustar el archivo deseado y los parámetros dentro del script.
3. **Exportar resultados:**
   ```sql
   COPY (
       -- repetir la consulta principal o usar una vista temporal
   ) TO 'c:/VLP/GitHub/REPO_VLP_DIC_25/docs/entregables_dic_2025/evidencias/L-2025-12-01/val_01.csv'
   WITH CSV HEADER;
   ```
4. **Registrar evidencias:** documentar lote, hash del CSV, incidencias y acciones en la bitácora operacional.

## 5. Versionamiento y Control de Cambios
- Cada script incluye encabezado con objetivo y notas de uso. Al modificarlo, incrementar el sufijo de versión (p.ej. `val_01_curp_formato_v1_1.sql`) o registrar el hash en la bitácora.
- Cambios deben pasar por revisión conjunta de Desarrollo + QA + Control Escolar. Actualizar simultáneamente la matriz de validaciones (Entregable 3) para mantener la trazabilidad.
- Se recomienda mantener una carpeta `scripts/validaciones_musems/historico/` con versiones anteriores y un archivo `CHANGELOG.md` que describa ajustes, razones y fecha.

## 6. Automatización
- Integrar los scripts a jobs programados (cron o CI/CD) que ejecuten las validaciones tras cada ventana de carga.
- Incluir alertas automáticas cuando los CSV resultantes tengan filas > 0 o cuando VAL-08 detecte `VENTANA_24H_SUPERADA`.
- Para ambientes productivos, encapsular los scripts en procedimientos almacenados o tareas programadas (pg_cron) que inserten resultados en tablas de auditoría.

## 7. Consideraciones de Seguridad
- Ejecutar en conexiones cifradas (TLS) y con roles con permisos mínimos.
- Evitar exponer CURP completas en logs; anonimizar cuando sea necesario.
- Al compartir evidencias, firmar los archivos CSV y limitar su acceso a personal autorizado.

## 8. Conclusión
Este inventario centraliza la información necesaria para ejecutar y mantener los scripts de validación de MUSEMS. Al seguir los pasos descritos se garantiza coherencia con los planes de prueba, la matriz de validaciones y las evidencias recopiladas durante el ciclo de diciembre 2025.
