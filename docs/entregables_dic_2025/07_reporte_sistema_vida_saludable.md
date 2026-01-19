# Entregable 7. Reporte Técnico del Sistema Vida Saludable (Ciclo 2)

Este reporte consolida la evidencia técnica disponible en el directorio **vida-saludable** para cerrar la entrega de diciembre de 2025. Se amplía la documentación con los insumos de [vida-saludable/docs](vida-saludable/docs), cubriendo visión de producto, arquitectura, casos de uso, modelos de datos, riesgos, métricas y backlog operativo.

## 1. Propósito y Alcance
- Documentar la solución de carga de tamizajes escolares ciclo 2 alineada al Plan Maestro RUP v1.1.
- Describir la operación end-to-end (preparación de CSV, validación, inserción en PostgreSQL y verificación).
- Inventariar scripts auxiliares, evidencias, configuraciones y documentación formal.
- Integrar riesgos, métricas, KPIs y plan de trabajo inmediato.

## 2. Inventario Detallado del Repositorio
| Categoría | Contenido | Referencia |
|-----------|-----------|------------|
| Plan Maestro y anexos | Cronograma, métricas, herramientas y lineamientos RUP. | [vida-saludable/docs/00_PLAN_MAESTRO_RUP.md](vida-saludable/docs/00_PLAN_MAESTRO_RUP.md) |
| Visión y alcance | Objetivos, beneficios, criterios de éxito y límites. | [vida-saludable/docs/01_VISION.md](vida-saludable/docs/01_VISION.md) |
| Arquitectura y diagramas | Vistas lógicas, manejo de errores, despliegue y procesos. | [vida-saludable/docs/01_ARQUITECTURA_SOFTWARE.md](vida-saludable/docs/01_ARQUITECTURA_SOFTWARE.md) |
| Modelo de datos | ERD, DDL, diccionario y reglas de integridad. | [vida-saludable/docs/02_MODELO_DATOS.md](vida-saludable/docs/02_MODELO_DATOS.md) |
| Stakeholders | Roles, matriz RACI y responsables. | [vida-saludable/docs/02_STAKEHOLDERS.md](vida-saludable/docs/02_STAKEHOLDERS.md) |
| Casos de uso | UC detallados, escenarios de prueba y reglas. | [vida-saludable/docs/03_CASOS_USO.md](vida-saludable/docs/03_CASOS_USO.md) |
| Riesgos | Matriz extendida con mitigaciones y dueños. | [vida-saludable/docs/04_ANALISIS_RIESGOS.md](vida-saludable/docs/04_ANALISIS_RIESGOS.md) |
| Plan de tareas | Lista secuencial para agente IA/Dev. | [vida-saludable/docs/04_TAREAS_IMPLEMENTACION.md](vida-saludable/docs/04_TAREAS_IMPLEMENTACION.md) |
| Código operativo | Loader validado y scripts de soporte CLI. | [vida-saludable/load_tamizajes.py](vida-saludable/load_tamizajes.py), [vida-saludable/scripts](vida-saludable/scripts) |
| Datos, DDL y evidencias | CSV de ejemplo, salidas, logs y SQL. | [vida-saludable/data](vida-saludable/data), [vida-saludable/db](vida-saludable/db), [vida-saludable/logs](vida-saludable/logs) |

## 3. Evidencias de Datos, Esquemas y Reportes
- **Datasets sanitizados:** el directorio [vida-saludable/data](vida-saludable/data) conserva archivos curados por ciclo (`clean_CICLO_1.csv`, `clean_CICLO_2.csv`, `filtered_CICLO_1.csv`) más un `data.example.csv` con los encabezados oficiales `CVE_CURP`, `CVE_ESCUELA`, `ID_TURNO`, `REF_TELEFONO`, `REF_CORREO_RESPONSABLE`, `ID_CICLO_ESCOLAR`, `ESTATUS_REPORTE`. Ejemplos en [vida-saludable/data/data.example.csv](vida-saludable/data/data.example.csv) muestran registros sin datos sensibles y permiten validar la CLI en modo `dry-run` antes de apuntar a archivos masivos.
- **Esquemas físicos:** además del DDL genérico `ddl_tamizados.sql`, el archivo [vida-saludable/db/ddl_menor_evaluado.sql](vida-saludable/db/ddl_menor_evaluado.sql) fija la PK compuesta `cve_curp + cve_escuela + id_ciclo_escolar` y exige `id_turno` y `id_ciclo_escolar` como NOT NULL; esto confirma que las migraciones recientes mantienen granularidad por ciclo aun cuando el loader tolere CSV mínimos.
- **Reportes comparativos:** [vida-saludable/reportes/comparison_summary.md](vida-saludable/reportes/comparison_summary.md) documenta la reconciliación `tamizados_con_sin_reporte` vs `tamizados_con_sin_reporte_c2` con 3.90M vs 3.77M CURP, intersección de 3.76M (overlap 96.36% contra A y 99.76% contra B) y diferencias materializadas en `a_not_b_full.csv` / `b_not_a_full.csv`.
- **Métricas y conteos tabulares:** [vida-saludable/reportes/totales.csv](vida-saludable/reportes/totales.csv) resume los registros por tabla (3,900,159 en `tamizados_con_sin_reporte`, 3,767,575 en `tamizados_con_sin_reporte_c2`), mientras [vida-saludable/reportes/comparison_metrics.csv](vida-saludable/reportes/comparison_metrics.csv) captura las cifras de intersección, diferencias y duplicados (0 en ambos casos), sirviendo como insumo directo para reconciliaciones automáticas.

  **Resumen de totales (extracto del CSV):**
  | Tabla | Total de registros |
  |-------|--------------------|
  | `tamizados_con_sin_reporte_c2` | 3,767,575 |
  | `tamizados_con_sin_reporte` | 3,900,159 |

  **Métricas de comparación (extracto del CSV):**
  | Métrica | Valor |
  |---------|-------|
  | Total A (`tamizados_con_sin_reporte`) | 3,900,159 |
  | Total B (`tamizados_con_sin_reporte_c2`) | 3,767,575 |
  | Distinct A | 3,900,159 |
  | Distinct B | 3,767,575 |
  | Intersección | 3,758,384 |
  | A \ B | 141,775 |
  | B \ A | 9,191 |
  | Duplicados en A | 0 |
  | Duplicados en B | 0 |
- **Estadísticas operativas:** los reportes `estadisticas_basicas.txt`, `estadisticas_utf8.txt` y `estados_por_ciclo.txt` en [vida-saludable/reportes](vida-saludable/reportes) se derivan de `scripts/stats_rapido.py` y cuantifican 6,295,949 registros totales (63% ciclo 1, 37% ciclo 2), distribución por turnos (84% matutino), estatus (73% con descarga), top escuelas y cobertura de datos de contacto (>99.9%). El análisis por entidad destaca concentraciones en Estado de México, Veracruz, Chiapas y Puebla para ambos ciclos.
- **Monitoreo puntual:** scripts como [vida-saludable/scripts/db_counts.py](vida-saludable/scripts/db_counts.py) y [vida-saludable/scripts/copy_csv_to_table.py](vida-saludable/scripts/copy_csv_to_table.py) facilitan validaciones rápidas (conteos, COPY controlado con delimitador configurable), mientras [vida-saludable/scripts/stats_rapido.py](vida-saludable/scripts/stats_rapido.py) genera versiones reproducibles de los reportes anteriores.

## 4. Contexto del Plan Maestro
- **Versión y fecha:** 1.1, 6 de noviembre de 2025, enfocada a un MVP de ejecución única. Se registran cambios respecto a la v1.0 para reconocer el script ya operativo y ajustar objetivos cortos.
- **Estado:** “Planificación / MVP entregado”. El objetivo inmediato es formalizar documentación, asegurar operación trazable y dejar backlog claro para evoluciones futuras.
- **Entregables vigentes:** `load_tamizajes.py`, documentación técnica (arquitectura, modelo, casos de uso, riesgos), `README.md`, `requirements.txt`, `db/ddl_tamizados.sql` y evidencias de ejecución.
- **Criterios de aceptación iniciales:** corrida exitosa en entorno de pruebas, coincidencia de registros insertados vs válidos, ausencia de datos sensibles y reporte final archivado.
- **Backlog estratégico:** modularizar el loader, habilitar flags no interactivos (`--dry-run`, `--yes`), logging estructurado, tabla de auditoría y pruebas unitarias/integración.

## 5. Visión y Beneficios del Producto
- **Propósito del sistema:** automatizar la ingestión de tamizajes mediante una CLI que reduce tiempos operativos, minimiza errores y garantiza trazabilidad, según [vida-saludable/docs/01_VISION.md](vida-saludable/docs/01_VISION.md).
- **Alcance incluido:** lectura/validación de CSV, inserción transaccional en PostgreSQL 14, gestión de credenciales vía `.env`, logging y pruebas básicas.
- **Fuera de alcance inicial:** GUI, API pública y reportes visuales avanzados (planeados para iteraciones posteriores).
- **Beneficios clave:** reducción de esfuerzo manual, validación previa del 100% de registros, cumplimiento de políticas de seguridad y generación de evidencia de carga.
- **Criterios de éxito:** soportar hasta 100k registros en <5 minutos, cobertura de pruebas ≥ 80% para código crítico y cero datos sensibles en el repositorio.

## 6. Flujo Operativo End-to-End
1. **Preparar entorno**: clonar repo, crear `venv`, instalar `requirements.txt`, copiar `.env.sample` a `.env` y llenar credenciales (ver instrucciones de README y tareas 1.1–1.4 del plan).
2. **Ejecución estándar**: `python load_tamizajes.py data/archivo.csv --delimiter '^' --target-table menor_evaluado`.
3. **Lectura y saneamiento**: detección automática de delimitador, estandarización de encabezados y relleno de columnas faltantes con `NULL` cuando se usa el modo mínimo.
4. **Validaciones**: estructura (columnas mínimas), CURP, correo, teléfono, turnos y estatus por fila. Se registra cada fallo con detalle.
5. **Inserción**: lotes configurables (BATCH_SIZE, default 1000) mediante `psycopg2.extras.execute_batch`, con transacciones y rollback en caso de error.
6. **Post-operación**: ejecución opcional de `scripts/post_load_check.py` para reconciliar CURPs, generación de estadísticas con `scripts/generate_statistics.py` y resguardo de `logs/` y `salida_*.txt`.
7. **Modo alterno**: `scripts/load_raw_no_validation.py` habilita COPY FROM STDIN para cargas DBA sin validaciones (requiere respaldo y documentación adicional).

## 7. Arquitectura y Componentes
- **CLI monolítica documentada**: [vida-saludable/docs/01_ARQUITECTURA_SOFTWARE.md](vida-saludable/docs/01_ARQUITECTURA_SOFTWARE.md) detalla vistas lógicas, diagramas de flujo y manejo de errores (incluye tablas ASCII para estrategias de retry y despliegue en entornos Python + PostgreSQL).
- **Principios arquitectónicos**: simplicidad, seguridad (sin credenciales en código), confiabilidad (transacciones con rollback), rendimiento (batch insert/COPY) y observabilidad mínima (reportes en consola + logs).
- **Despliegue**: CLI ejecutada en entorno Python 3.10+ con dependencias mínimas (`pandas`, `psycopg2-binary`, `python-dotenv`). DB objetivo: PostgreSQL 14, puerto 5432.
- **Futuras separaciones**: plan para extraer `config.py`, `validators.py`, `db.py` y `cli.py` conforme crezca la complejidad.

## 8. Configuración y Parámetros Operativos
- **Variables de entorno** (plantilla en `.env.sample`): host, puerto, DB, usuario, contraseña, `BATCH_SIZE`, `DUPLICATE_MODE`, `MAX_INVALID_PERCENTAGE`, `DB_CONNECTION_TIMEOUT`.
- **Flags CLI clave**: `--dry-run`, `--yes`, `--no-utf-icons`, `--delimiter`, `--target-table`, `--no-validate`.
- **Delimitadores soportados**: autodetección entre `,`, `|`, `;`, `\t`, `^`; default caret.
- **Modos de validación**: estándar (valida todo), `--no-validate` (solo normaliza), `--dry-run` (no escribe en BD), `DUPLICATE_MODE` (`skip` o `fail`).
- **Estrategia de interacción**: confirmaciones interactivas cuando el error rate supera `MAX_INVALID_PERCENTAGE` (default 10%).

## 9. Modelo de Datos y Esquemas
- **Estructura física**: tablas `tamizados_con_sin_reporte_c2` (PK `cve_curp`, columnas opcionales) y `menor_evaluado` (PK compuesta `cve_curp + cve_escuela`, turno y ciclo obligatorios) descritas en [vida-saludable/docs/02_MODELO_DATOS.md](vida-saludable/docs/02_MODELO_DATOS.md).
- **DDL**: [vida-saludable/db/ddl_tamizados.sql](vida-saludable/db/ddl_tamizados.sql) incluye constraints (regex de CURP, emails válidos, turnos `1-5`, estatus permitidos) e índices (`idx_tamizados_escuela`, `idx_tamizados_estatus`, índices compuestos por escuela/estatus).
- **Diccionario de datos**: detalla tipo, longitud, obligatoriedad, ejemplos y reglas por columna (CURP en mayúsculas, normalización de correos, tolerancia para teléfonos con separadores, estatus `REPORTE DESCARGADO` / `SIN REPORTE`).
- **Soporte a CSV mínimos**: loader acepta archivos con `CVE_CURP`, `REF_CORREO_RESPONSABLE`, `REF_TELEFONO` y completa el resto con `NULL`, gracias a que el modelo actual flexibiliza la PK.

## 10. Stakeholders y Gobernanza
- **Roles principales** (ver [vida-saludable/docs/02_STAKEHOLDERS.md](vida-saludable/docs/02_STAKEHOLDERS.md)):
  - Product Owner (prioriza y acepta). Implicación alta.
  - Equipo de Salud/Operadores (suministran CSV, validan resultados). Implicación media.
  - Arquitecto/Desarrollador Python (diseño y mantenimiento). Implicación alta.
  - DBA (ejecuta DDL, vigila integridad). Implicación media-alta.
  - QA/Testers (casos de prueba, defectos). Implicación alta en construcción.
  - DevOps (entornos, CI/CD). Implicación media.
  - Seguridad/Compliance (revisión de controles). Implicación media.
- **Interesados secundarios**: administradores de sistemas y usuarios institucionales que recibirán reportes derivados.
- **Matriz RACI**: PO y Desarrollador comparten responsabilidades (R/A); DBA, QA y Seguridad actúan como consultores; DevOps informado y de apoyo.

## 11. Casos de Uso y Escenarios de Prueba
- **Casos principales**: UC-01 carga CSV, UC-02 validación de estructura, UC-03 validación de registros, UC-04 inserción, UC-05 manejo de errores/rollback, UC-06 reporte de carga (ver [vida-saludable/docs/03_CASOS_USO.md](vida-saludable/docs/03_CASOS_USO.md)).
- **Casos secundarios**: UC-07 configuración (.env), UC-08 consulta de logs.
- **Flujos alternos relevantes**: errores por duplicado (`IntegrityError`), `CheckViolation`, reconexión ante `OperationalError`, timeouts y manejo de porcentajes de error.
- **Escenarios de prueba recomendados**: carga exitosa, CSV sin columnas clave, registros parcialmente inválidos, duplicados, desconexión de BD durante carga (incluye criterios de aceptación y métricas esperadas en cada escenario).
- **Trazabilidad**: matriz que vincula requisitos (REQ-001..008) con cada caso de uso.

## 12. Scripts de Soporte Destacados
| Script | Función principal |
|--------|------------------|
| [vida-saludable/scripts/load_raw_no_validation.py](vida-saludable/scripts/load_raw_no_validation.py) | Inserción masiva con COPY FROM STDIN, detección automática de delimitadores y selección de tabla según encabezado. |
| [vida-saludable/scripts/post_load_check.py](vida-saludable/scripts/post_load_check.py) | Reconciliación post-carga: compara CURPs del CSV vs tabla y escribe evidencia en `logs/post_load_check.txt`. |
| [vida-saludable/scripts/generate_statistics.py](vida-saludable/scripts/generate_statistics.py) | Genera métricas (totales, distribución por ciclo/turno/estatus, top escuelas, duplicados, calidad de contacto, estados CURP). |
| [vida-saludable/scripts/check_table_pk.py](vida-saludable/scripts/check_table_pk.py) / [vida-saludable/scripts/modify_pk_menor_evaluado.py](vida-saludable/scripts/modify_pk_menor_evaluado.py) | Verifica y ajusta la PK de `menor_evaluado` durante migraciones. |
| [vida-saludable/scripts/filter_wellformed_csv.py](vida-saludable/scripts/filter_wellformed_csv.py) & [vida-saludable/scripts/clean_csv_for_loader.py](vida-saludable/scripts/clean_csv_for_loader.py) | Limpian CSV antes de la carga (normalizan delimitadores, corrigen encabezados, filtran registros). |
| [vida-saludable/scripts/generate_full_comparison_reports.py](vida-saludable/scripts/generate_full_comparison_reports.py) | Compara padrones entre ciclos y genera reportes de diferencias en `reportes/`. |

## 13. Calidad de Datos y Validaciones
- **Validación de estructura**: se exige el trío mínimo (`CVE_CURP`, `REF_CORREO_RESPONSABLE`, `REF_TELEFONO`). Para `menor_evaluado` se requieren además `CVE_ESCUELA`, `ID_TURNO`, `ID_CICLO_ESCOLAR`.
- **Validación por fila**: `validar_fila()` devuelve mensajes detallados; los registros inválidos se agregan a un listado que alimenta reportes.
- **Tolerancia configurable**: `MAX_INVALID_PERCENTAGE` controla si el sistema continúa con registros válidos o solicita confirmación.
- **Modo dry-run**: cuantifica calidad y desempeño sin afectar la BD.
- **Checks en BD**: constraints de formato (CURP, email, turno, estatus) garantizan integridad aun si se omiten validaciones en la CLI.

## 14. Operación por Escenarios
| Escenario | Recomendación |
|-----------|---------------|
| **Carga confiable** | Ejecutar `load_tamizajes.py` con validaciones activas hacia `menor_evaluado`; conservar salida y logs. |
| **Validación previa** | `--dry-run` + delimitador explícito para verificar columnas, tamaños y tiempos antes de producción. |
| **Migración masiva (DBA)** | `load_raw_no_validation.py` + respaldo previo + conteos antes/después documentados. |
| **Reprocesos / limpieza** | Scripts `truncate_menor.py`, `modify_pk_menor_evaluado.py` bajo supervisión DBA y bitácora formal. |
| **Monitoreo post-carga** | `post_load_check.py`, reportes en `reportes/` y métricas de `generate_statistics.py` para actas de cierre. |

## 15. Análisis y Reportes
- `generate_statistics.py` se complementa con `db_counts.py`, `analisis_estados_por_ciclo.py`, `analisis_avanzado.py` para evaluar distribución geográfica, duplicados y calidad de contacto.
- `generate_comparison_reports.py` / `generate_full_comparison_reports.py` proveen diferenciales entre ciclos, útiles para auditorías y conciliación.
- Evidencias de ejecución (`salida_carga_ciclo2.txt`, archivos en `logs/` y `reportes/`) deben acompañar cada acta de carga.

## 16. Riesgos y Controles
| ID | Riesgo | Probabilidad | Impacto | Control actual | Mejora sugerida |
|----|--------|--------------|---------|----------------|-----------------|
| R01 | Exposición de datos sensibles | Media | Crítico | `.gitignore`, `.env.sample`, lineamientos en README. | Secret scanning automático en CI y revisión previa a merge. |
| R02 | Credenciales hardcodeadas | Baja | Alto | Uso de `python-dotenv`, revisión de PR. | Gestionar secretos en Vault/CI y rotar credenciales tras cada intervención. |
| R03 | CSV mal formado | Alta | Medio | Validadores robustos, modo `dry-run`, plantillas. | Checklist operativo y plantillas firmadas por operadores. |
| R04 | Caída de conexión | Media | Alto | Transacciones, rollback y reintentos manuales. | Reintentos automáticos por lote y checkpoints. |
| R05 | Rendimiento insuficiente | Media | Medio | Batch configurable y scripts COPY. | Benchmarks >100k registros y ajuste dinámico de `BATCH_SIZE`. |
| R06 | Duplicados | Media | Alto | PK, validaciones de CURP, scripts de comparación. | Tabla de auditoría y alertas automáticas de duplicados recientes. |
| R07 | Pérdida de datos | Baja | Crítico | Respaldos previos y verificaciones post-carga. | Procedimientos documentados de restauración y pruebas rutinarias. |
| R09 | Vulnerabilidades en dependencias | Baja | Alto | `requirements.txt` versionado, recomendación de `pip-audit`. | Escaneo semanal en CI y alertas al PO. |

## 17. Backlog Inmediato (Plan de Tareas)
Referenciado en [vida-saludable/docs/04_TAREAS_IMPLEMENTACION.md](vida-saludable/docs/04_TAREAS_IMPLEMENTACION.md):
1. **Configurar estructura y gobernanza**: carpetas mínimas (`db/`, `data/`, `tests/`, `docs/`), `.gitignore`, `.env.sample`, `requirements.txt`, README con guía paso a paso.
2. **Modularización**: creación de `config.py`, `db.py`, `validators.py`, `cli.py` siguiendo los objetivos de la fase 2.
3. **Validaciones y pruebas**: suites `pytest`, cobertura ≥ 80%, fixtures e integración con PostgreSQL (Docker opcional).
4. **Calidad y CI**: agregar `black`, `flake8`, `pylint`, pipeline GitHub Actions que ejecute lint + pruebas.
5. **Logging y auditoría**: logging estructurado (JSON) y tabla `operaciones_carga` con hash de archivo y timestamps.

## 18. Métricas, KPIs y Herramientas
- **Calidad de código**: cobertura ≥ 80%, complejidad ≤ 10 por función, cumplimiento PEP8, cero vulnerabilidades.
- **Rendimiento**: tiempo < 30 s por cada 10k registros, memoria < 500 MB para archivos de 100k, tasa de éxito ≥ 99%.
- **Proceso**: velocidad por iteración, defectos encontrados/resueltos, tiempo de resolución y adherencia al cronograma.
- **Herramientas clave**: Python 3.10+, VS Code, `pandas`, `psycopg2-binary`, `python-dotenv`, `pytest`, `black`, GitHub Actions, Docker (PostgreSQL local), PlantUML. Documentadas en la sección 7 del Plan Maestro.

## 19. Recomendaciones Operativas
1. Validar siempre con `data/data.example.csv` antes de usar datos reales; preservar `salida*.txt` y `logs/post_load_check.txt` como evidencia.
2. Registrar en `reportes/` los conteos antes/después cuando se use COPY o scripts de truncado; adjuntar estos archivos a los cierres mensuales.
3. Proteger `.env` con permisos mínimos y gestionar credenciales definitivas en un vault institucional.
4. Ejecutar revisiones quincenales del backlog para priorizar mejoras de seguridad y automatización.
5. Activar escaneo de dependencias (`pip-audit`, `safety`) y secret scanning en CI para anticipar riesgos.

---
**Conclusión.** El subproyecto **vida-saludable** dispone de artefactos completos para operar, auditar y evolucionar la carga de tamizajes ciclo 2. La combinación de documentación RUP, scripts de ingesta/validación, reportes estadísticos, métricas y controles de riesgo garantiza trazabilidad y habilita el siguiente ciclo de mejoras sin dependencias externas.
