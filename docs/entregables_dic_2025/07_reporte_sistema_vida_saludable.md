# Entregable 7. Reporte Técnico del Sistema Vida Saludable (Ciclo 2)

Este reporte consolida toda la información disponible en el directorio **vida-saludable** para cerrar la entrega mensual de diciembre de 2025. Se profundiza en arquitectura, operación, gobernanza, herramientas de análisis y riesgos, tomando como fuente los artefactos funcionales y documentales que ya están versionados en el repositorio.

## 1. Propósito y Alcance
- Documentar la solución de carga de tamizajes escolares ciclo 2, alineada a los entregables RUP vigentes.
- Describir la operación end-to-end (preparación de CSV, validación, inserción en PostgreSQL y verificación posterior).
- Inventariar scripts auxiliares, documentación funcional y evidencia de ejecución.
- Identificar riesgos, métricas y backlog inmediato para el siguiente ciclo.

## 2. Inventario Detallado del Repositorio
| Categoría | Contenido | Referencia |
|-----------|-----------|------------|
| Documentación RUP | Plan Maestro, Arquitectura, Visión, Stakeholders, Modelo de Datos, Casos de Uso, Análisis de Riesgos y Tareas de Implementación. | [vida-saludable/docs](vida-saludable/docs) |
| Código principal | Loader validado `load_tamizajes.py`, dependencias definidas y scripts CLI. | [vida-saludable/load_tamizajes.py](vida-saludable/load_tamizajes.py) |
| Scripts de soporte | 25 utilidades (COPY masivo, verificaciones post-carga, análisis de catálogos, fixes de markdown, estadísticas, truncados, etc.). | [vida-saludable/scripts](vida-saludable/scripts) |
| Esquemas y DDL | Definiciones SQL para `tamizados_con_sin_reporte_c2`, `menor_evaluado` y scripts de alteraciones. | [vida-saludable/db](vida-saludable/db) |
| Datos / logs de ejemplo | CSV de prueba, salidas de ejecución (`salida*.txt`), reportes en `logs/` y `reportes/`. | [vida-saludable/data](vida-saludable/data), [vida-saludable/logs](vida-saludable/logs), [vida-saludable/reportes](vida-saludable/reportes) |
| Configuración | Plantillas `.env`, requerimientos de Python y ajustes de VS Code. | [vida-saludable/.env.sample](vida-saludable/.env.sample), [vida-saludable/requirements.txt](vida-saludable/requirements.txt), [vida-saludable/.vscode](vida-saludable/.vscode) |

## 3. Contexto del Plan Maestro (docs/00_PLAN_MAESTRO_RUP.md)
- **Metodología:** RUP versión 1.1 enfocada en un MVP de ejecución puntual ya entregado.
- **Alcance incluido:** script `load_tamizajes.py`, documentación técnica básica, DDL y guías operativas.
- **Fuera de alcance inmediato:** modularización avanzada, logging estructurado persistente, CI/CD y UI.
- **Criterios de aceptación:** corrida exitosa en entorno controlado, coincidencia de conteos, ausencia de datos sensibles y reporte final archivado.
- **Backlog:** separación por módulos (`config.py`, `validators.py`, `db.py`), flags no interactivos, tabla de auditoría, pruebas automatizadas y pipelines de calidad.

## 4. Flujo Operativo End-to-End
1. **Preparación del entorno**
  - Clonar repositorio, crear venv y cargar dependencias (`pandas`, `psycopg2-binary`, `python-dotenv`, toolchain de QA).
  - Configurar `.env` a partir de `.env.sample`, declarando credenciales PostgreSQL, `BATCH_SIZE`, `DUPLICATE_MODE` y parámetros opcionales.
2. **Ingesta controlada** (loader validado)
  - Ejecución `python load_tamizajes.py data/archivo.csv --delimiter '^' --target-table menor_evaluado`.
  - Lectura adaptativa de CSV: detección de delimitador, normalización de encabezados y completado de columnas faltantes con `NULL` para el modo mínimo.
  - Validaciones: CURP (regex con entidad + fecha), correo, teléfono, turno, estatus y campos obligatorios condicionados al target.
  - Batch insert configurable (`execute_batch`, tamaño 1000 por defecto). Commit único con rollback ante errores de `psycopg2`.
3. **Ingesta sin validaciones** (modo DBA)
  - `scripts/load_raw_no_validation.py` habilita COPY FROM STDIN, detección automática de delimitador y columnas, y selección de tabla destino según cabecera.
4. **Post-operación**
  - `scripts/post_load_check.py` compara CURPs del CSV contra la tabla destino y escribe evidencias en `logs/post_load_check.txt`.
  - Scripts analíticos (`generate_statistics.py`, `db_counts.py`, `analisis_estados_por_ciclo.py`) generan métricas de completitud y distribución para cierre del ciclo.

## 5. Arquitectura Lógica y Componentes
- **CLI Monolítica:** `load_tamizajes.py` concentra parsers, validadores y conexión DB, pero mantiene secciones claras para evolucionar hacia módulos separados.
- **Configuración externalizada:** Uso de `dotenv` y `.env.sample` garantiza que no existan credenciales en el código.
- **Persistencia:** PostgreSQL 14 con tablas `tamizados_con_sin_reporte_c2` (PK `cve_curp`) y `menor_evaluado` (PK compuesta, versión extendida). DDL base en [vida-saludable/db/ddl_tamizados.sql](vida-saludable/db/ddl_tamizados.sql).
- **Procesamiento:** Pandas maneja la lectura/normalización, mientras `psycopg2.extras.execute_batch` ejecuta inserciones en lotes con control transaccional.
- **Observabilidad mínima:** Reporte resumen en consola (conteos, tasa de éxito, velocidad) y archivos de salida manuales.

## 6. Configuración y Parámetros Operativos
- Argumentos clave del loader: `--dry-run`, `--yes`, `--no-utf-icons`, `--delimiter`, `--target-table`, `--no-validate`.
- Iconografía configurable (ASCII vs UTF-8) para soportar consolas Windows (`--no-utf-icons`).
- Detección automática de delimitador y fallback a `,`, `|`, `;`, `\t` o `^`.
- Modo `--no-validate`: limpia y normaliza campos sin ejecutar validadores, útil para cargas controladas en ambientes confiables.
- Selección de tabla: `menor_evaluado` (default) exige `cve_escuela`, `id_turno`, `id_ciclo_escolar`; `tamizados_con_sin_reporte_c2` opera con columnas mínimas.

## 7. Modelo de Datos y Esquemas
- **`tamizados_con_sin_reporte_c2`:** PK en `cve_curp`, columnas opcionales para escuela, turno, correo, teléfono y estatus. DDL en [vida-saludable/db/ddl_tamizados.sql](vida-saludable/db/ddl_tamizados.sql).
- **`menor_evaluado`:** versión extendida con PK compuesta y campos obligatorios adicionales (ciclo escolar). La documentación en [vida-saludable/docs/02_MODELO_DATOS.md](vida-saludable/docs/02_MODELO_DATOS.md) incluye ERD, diccionario y reglas de validación.
- **Validaciones de negocio:** Regex CURP con entidades federativas válidas, catálogo de turnos (`1`-`5`), estatus (`REPORTE DESCARGADO`, `SIN REPORTE`) y límites de longitud para datos de contacto.
- **Índices:** se recomienda mantener índices por escuela y estatus para acelerar conciliaciones y monitoreo.

## 8. Scripts de Soporte Destacados
| Script | Función principal |
|--------|------------------|
| [scripts/load_raw_no_validation.py](vida-saludable/scripts/load_raw_no_validation.py) | Inserción masiva vía COPY (sin validaciones) con detección automática de delimitador/columnas y conteo antes-después. |
| [scripts/post_load_check.py](vida-saludable/scripts/post_load_check.py) | Verificación post-carga: valida conteo, presencia de CURPs y genera reporte en `logs/`. |
| [scripts/generate_statistics.py](vida-saludable/scripts/generate_statistics.py) | Reporte estadístico (totales, distribución por ciclo/turno/estatus, top escuelas, calidad de contacto, duplicados, estados CURP). |
| [scripts/check_table_pk.py](vida-saludable/scripts/check_table_pk.py) / [scripts/modify_pk_menor_evaluado.py](vida-saludable/scripts/modify_pk_menor_evaluado.py) | Diagnóstico y ajuste del PK para `menor_evaluado` cuando se requiere migrar desde `cve_curp + cve_escuela`. |
| [scripts/filter_wellformed_csv.py](vida-saludable/scripts/filter_wellformed_csv.py) y [scripts/clean_csv_for_loader.py](vida-saludable/scripts/clean_csv_for_loader.py) | Limpieza previa de CSV: normalizan delimitadores, corrigen encabezados y filtran registros bien formados. |
| [scripts/generate_full_comparison_reports.py](vida-saludable/scripts/generate_full_comparison_reports.py) | Compara padrones entre ciclos y genera reportes de diferencias en `reportes/`. |

## 9. Calidad de Datos y Validaciones
- **Validación de estructura:** mínimo requerido (`cve_curp`, `ref_correo_responsable`, `ref_telefono`) y validaciones estrictas adicionales cuando el destino es `menor_evaluado`.
- **Validación por fila:** `validar_fila()` centraliza reglas y devuelve mensajes detallados para bitácora, reduciendo el tiempo de diagnóstico.
- **Tolerancia configurable:** si el porcentaje de errores supera 10% se solicita confirmación manual antes de continuar con los registros válidos.
- **Soporte para `dry-run`:** permite medir calidad y tiempo sin tocar la base de datos; útil para escenarios UAT.

## 10. Operación por Escenarios
| Escenario | Recomendación |
|-----------|---------------|
| **Carga estándar confiable** | Ejecutar `load_tamizajes.py` con validaciones activas y tabla `menor_evaluado`. Guarda reporte final y salida de consola. |
| **Pruebas de conectividad o estructura** | Usar `--dry-run` + `--delimiter` para validar que el archivo es legible y que el pipeline funcionará cuando se habilite el commit. |
| **Migraciones masivas** | Utilizar `load_raw_no_validation.py` (COPY). Previo a producción ejecutar backup y documentar conteos antes/después. |
| **Reprocesos o limpieza** | Scripts como `truncate_menor.py` o `modify_pk_menor_evaluado.py` permiten resetear tablas o ajustar PK previo a reintentos, siempre bajo control del DBA. |
| **Monitoreo posterior** | `post_load_check.py` y reportes en `reportes/` facilitan la emisión de actas de cierre para operadores y PO. |

## 11. Análisis y Reportes
- `generate_statistics.py` brinda métricas clave (totales, top escuelas, duplicados, distribución de turnos/estatus y calidad de contacto) para respaldar decisiones de negocio y auditorías.
- `analisis_estados_por_ciclo.py` y `analisis_avanzado.py` permiten filtrar padrones por entidad federativa o ciclo escolar y detectar outliers.
- Los scripts `generate_comparison_reports.py` y `generate_full_comparison_reports.py` contrastan archivos de distintos ciclos, entregando CSV de diferencias y resúmenes listos para supervisión.

## 12. Riesgos y Controles
| ID | Riesgo | Control actual | Mejora sugerida |
|----|--------|----------------|-----------------|
| R01 | Datos sensibles en repo | `.gitignore`, plantilla `.env.sample`, lineamientos en README. | Añadir secret-scanning automático en CI y revisión previa a merge. |
| R03 | CSV mal formados | Validadores exhaustivos, scripts de limpieza y modo `dry-run`. | Publicar checklist para operadores + plantillas firmadas. |
| R04 | Caídas de conexión | Manejo de excepciones `psycopg2`, rollback y reintentos manuales. | Implementar reintentos automáticos y checkpoints por lote. |
| R05 | Rendimiento insuficiente | COPY masivo y batch size configurable. | Medir tiempos en archivos >100k registros y ajustar `BATCH_SIZE` dinámicamente. |
| R06 | Duplicados o inconsistencias | PK en `cve_curp`, validaciones de CURP y scripts de comparación. | Tabla de auditoría y reportes automáticos de duplicados recientes. |
| R09 | Vulnerabilidades en dependencias | `requirements.txt` versionado y sugerencia de `pip-audit`. | Automatizar escaneo semanal y alerts al PO. |

## 13. Backlog Inmediato (docs/04_TAREAS_IMPLEMENTACION.md)
1. **Modularización del loader:** extraer `config`, `db`, `validators` y `cli` para facilitar pruebas unitarias.
2. **Logging estructurado:** enviar salidas a JSON en `logs/` y/ó tabla `operaciones_carga` con timestamps, usuario y hash de archivo.
3. **Pruebas automatizadas:** cubrir validadores (CURP, email, turnos) y flujos `dry-run`/`no-validate` con `pytest`.
4. **CI liviano:** job que ejecute lint + pruebas sobre pull requests del subproyecto.
5. **Reportería consolidada:** empaquetar métricas (`generate_statistics.py`) en dashboards y adjuntar a `reportes/` por corrida.

## 14. Recomendaciones Operativas
1. Usar siempre archivos de prueba (`data/data.example.csv`) para validar las rutas antes de ejecutar datos reales.
2. Conservar los archivos `salida*.txt` y `logs/post_load_check.txt` como evidencia de cada corrida.
3. Documentar en `reportes/` los conteos previos/posteriores cuando se utilice el modo COPY o scripts de truncado.
4. Blindar el `.env` con permisos mínimos y almacenar las credenciales definitivas en Vault / gestor institucional.
5. Planificar revisiones quincenales del backlog para mantener priorizadas las mejoras de seguridad y automatización.

---
**Conclusión.** El directorio **vida-saludable** integra todos los artefactos necesarios para operar, auditar y evolucionar la carga de tamizajes ciclo 2. La combinación de documentación RUP, scripts de ingesta/validación, reportes estadísticos y controles de riesgo permite entregar trazabilidad completa y habilita el siguiente ciclo de mejoras sin depender de fuentes externas.
