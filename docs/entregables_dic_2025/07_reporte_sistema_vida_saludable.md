# Entregable 7. Reporte Técnico del Sistema Vida Saludable (Ciclo 2)

Este documento concentra, en un solo lugar, toda la información relevante del subproyecto **vida-saludable**. Aquí se describen la visión del sistema, su arquitectura, la configuración operativa, el modelo de datos, los scripts disponibles, los riesgos, las métricas y el plan de trabajo inmediato sin depender de referencias externas.

## 1. Propósito y Alcance
- Documentar de forma íntegra la solución de carga de tamizajes escolares ciclo 2, tomando como base el Plan Maestro RUP versión 1.1.
- Explicar el flujo operativo completo: preparación de insumos, validación, inserción en PostgreSQL, verificación y reportería.
- Inventariar y describir los activos técnicos (scripts, datos, DDL, estadísticas, reportes y configuraciones) incluidos en el repositorio.
- Consolidar riesgos, métricas, KPIs y backlog para facilitar la continuidad operativa y la evolución del sistema.

## 2. Inventario Detallado del Repositorio
- **Plan Maestro y anexos:** resumen ejecutivo del proyecto, lineamientos metodológicos, criterios de aceptación, registro de riesgos, métricas esperadas y cronograma del MVP.
- **Visión y alcance:** declaración del propósito del sistema, beneficios esperados, supuestos y criterios de éxito (tiempos de carga, cobertura de pruebas, cero datos sensibles en el repositorio).
- **Arquitectura y diagramas:** descripciones de la vista lógica, procesos, manejo de errores, despliegue en entornos Python + PostgreSQL y principios de diseño (simplicidad, seguridad, confiabilidad, rendimiento, observabilidad).
- **Modelo de datos:** ERD, DDL para `tamizados_con_sin_reporte_c2` y `menor_evaluado`, reglas de integridad, diccionario de datos y notas sobre la aceptación de CSV mínimos.
- **Stakeholders:** roles principales (PO, operadores, desarrollador, DBA, QA, DevOps, seguridad) con nivel de involucramiento y matriz RACI.
- **Casos de uso:** ocho UC detallados que abarcan carga de CSV, validaciones, inserción, manejo de errores, reportería, configuración y consulta de logs.
- **Análisis de riesgos:** matriz con probabilidad, impacto, mitigación y contingencia para doce riesgos (exposición de datos, caídas de conexión, duplicados, rendimiento, vulnerabilidades, etc.).
- **Plan de tareas:** lista secuencial orientada a agentes IA con instrucciones para estructurar el proyecto, modularizar el código, instrumentar pruebas, habilitar CI y reforzar logging/auditoría.
- **Código operativo:** `load_tamizajes.py` como CLI principal y un conjunto de scripts auxiliares agrupados en `scripts/` (carga sin validación, comparativos, limpieza de CSV, verificación post-carga, estadísticas, etc.).
- **Datos y evidencias:** CSV sanitizados por ciclo, plantillas de ejemplo, DDLs en `db/`, reportes textuales y CSV con métricas de conteos, comparaciones y distribución estadística.

## 3. Evidencias de Datos, Esquemas y Reportes
- **Datasets sanitizados:** existen archivos `clean_CICLO_1.csv`, `clean_CICLO_2.csv`, `filtered_CICLO_1.csv` y una plantilla `data.example.csv` con los encabezados oficiales `CVE_CURP`, `CVE_ESCUELA`, `ID_TURNO`, `REF_TELEFONO`, `REF_CORREO_RESPONSABLE`, `ID_CICLO_ESCOLAR`, `ESTATUS_REPORTE`. Estos archivos permiten validar la CLI en modo `dry-run` sin exponer información sensible.
- **Esquemas físicos:** los DDL `ddl_tamizados.sql` y `ddl_menor_evaluado.sql` definen claves primarias (`cve_curp` y `cve_curp + cve_escuela + id_ciclo_escolar` respectivamente), campos obligatorios (`id_turno`, `id_ciclo_escolar`) y restricciones de formato (regex de CURP, correos válidos, turnos `1-5`, estatus permitidos). También se instalan índices por escuela y estatus para agilizar consultas.
- **Reportes comparativos:** los estudios de reconciliación entre `tamizados_con_sin_reporte` y `tamizados_con_sin_reporte_c2` muestran 3,900,159 CURP vs 3,767,575 CURP, con una intersección de 3,758,384 registros (96.36% respecto al padrón histórico y 99.76% respecto al padrón del ciclo 2). Los conjuntos `a_not_b_full.csv` y `b_not_a_full.csv` contienen los casos fuera de intersección.
- **Métricas y conteos tabulares:**

  | Tabla | Total de registros |
  |-------|--------------------|
  | `tamizados_con_sin_reporte_c2` | 3,767,575 |
  | `tamizados_con_sin_reporte` | 3,900,159 |

  | Métrica | Valor |
  |---------|-------|
  | Total A (histórico) | 3,900,159 |
  | Total B (ciclo 2) | 3,767,575 |
  | Distinct A | 3,900,159 |
  | Distinct B | 3,767,575 |
  | Intersección | 3,758,384 |
  | A minus B | 141,775 |
  | B minus A | 9,191 |
  | Duplicados en A | 0 |
  | Duplicados en B | 0 |

- **Estadísticas operativas:** los reportes `estadisticas_basicas.txt`, `estadisticas_utf8.txt` y `estados_por_ciclo.txt` cuantifican 6,295,949 registros totales (63% ciclo 1 y 37% ciclo 2), distribución por turno (84% turno 1, 15% turno 2, restante en turnos 3-5), estatus (73% con reporte descargado) y cobertura de datos de contacto (>99.9% con correo y teléfono). El análisis por entidad federativa destaca concentraciones en Estado de México, Veracruz, Chiapas, Puebla, Ciudad de México y Guanajuato.
- **Monitoreo puntual:** `db_counts.py` ofrece conteos rápidos por tabla, `copy_csv_to_table.py` ejecuta COPY FROM STDIN con delimitador configurable y `stats_rapido.py` reproduce las estadísticas anteriores con salida en texto plano.

## 4. Contexto del Plan Maestro
- **Versión y estado:** Plan Maestro RUP v1.1 (6 de noviembre de 2025), marcado como “Planificación / MVP entregado”, pues ya existe un script funcional y se busca formalizar la entrega y las mejoras futuras.
- **Alcance vigente:** incluye el loader `load_tamizajes.py`, la documentación técnica (arquitectura, modelo, casos de uso, riesgos), los artefactos operativos (`README`, `requirements`, DDL) y la evidencia de ejecución.
- **Criterios de aceptación:** corrida exitosa en entorno controlado, coincidencia entre registros insertados y filas válidas, ausencia de datos sensibles en el repositorio y archivo del reporte final.
- **Backlog estratégico:** modularización del loader, implementación de flags no interactivos, logging estructurado, tabla de auditoría, separación por capas (configuración, validadores, DB, CLI) y suites de pruebas automatizadas.

## 5. Visión y Beneficios del Producto
- **Propósito:** ofrecer una herramienta de línea de comandos que automatice la lectura, validación y carga de CSV con tamizajes hacia PostgreSQL 14, reduciendo tiempos operativos y riesgos por errores manuales.
- **Beneficios clave:** validación previa del 100% de registros, trazabilidad completa mediante logs y reportes, manejo seguro de credenciales con `.env`, reducción de reprocesos y evidencia de cada corrida.
- **Alcance inicial:** CLI, validaciones, inserción transaccional y reportería básica. Quedan fuera (en esta fase) una GUI y reportes visuales avanzados, aunque existen scripts que facilitan la construcción de dashboards.
- **Metas cuantitativas:** archivos de hasta 100,000 registros en menos de 5 minutos, cobertura de pruebas ≥ 80% en componentes críticos, cero credenciales ni datos sensibles en el repositorio y tiempo de respuesta aceptable para lotes de 10,000 registros (<30 segundos).

## 6. Flujo Operativo End-to-End
1. **Preparación del entorno:** clonar el repositorio, crear entorno virtual, instalar dependencias, copiar `.env.sample` a `.env`, definir credenciales y parámetros (host, puerto, DB, usuario, contraseña, `BATCH_SIZE`, `DUPLICATE_MODE`, `MAX_INVALID_PERCENTAGE`, `DB_CONNECTION_TIMEOUT`).
2. **Selección del modo de carga:** ejecutar `load_tamizajes.py` para cargas con validaciones o `load_raw_no_validation.py`/`copy_csv_to_table.py` para cargas controladas por DBA mediante COPY.
3. **Lectura y saneamiento:** auto-detección del delimitador (`^`, `,`, `|`, `;`, `\t`), estandarización de encabezados, rellenado de columnas faltantes con `NULL` en el modo mínimo y conversión a mayúsculas donde aplica.
4. **Validaciones:** comprobación de estructura mínima, CURP conforme a regex oficial, correos, teléfonos, turnos (`1-5`), estatus, duplicados y umbral de errores permitido (`MAX_INVALID_PERCENTAGE`).
5. **Inserción en PostgreSQL:** uso de `psycopg2.extras.execute_batch` con tamaño configurable (default 1000) y transacciones con rollback automático ante fallos.
6. **Post-operación:** ejecución de `post_load_check.py` para reconciliar CURPs entre CSV y tabla, generación de estadísticas (`generate_statistics.py`, `stats_rapido.py`), exportación de reportes y archivo de la evidencia (`logs/`, `reportes/`, `salida_*.txt`).
7. **Modos alternos:** `--dry-run` para validar sin insertar, `--no-validate` para normalizar sin reglas de negocio, `--yes` para ejecuciones no interactivas y `--no-utf-icons` para consolas que requieren ASCII puro.

## 7. Arquitectura y Componentes
- **CLI monolítica organizada en secciones:** imports, constantes, validadores, funciones utilitarias y `main()`; preparada para separarse en módulos (`config`, `db`, `validators`, `cli`) según lo dicta el plan de modularización.
- **Principios arquitectónicos:** simplicidad (script único), seguridad (credenciales fuera del código), confiabilidad (transacciones con rollback, manejo de `IntegrityError` y `OperationalError`), rendimiento (batch insert y COPY) y observabilidad básica (resúmenes en consola, archivos de salida, logs).
- **Despliegue objetivo:** entornos Windows/Linux/macOS con Python 3.10+, PostgreSQL 14 en puerto 5432, dependencias mínimas (`pandas`, `psycopg2-binary`, `python-dotenv`) y herramientas de desarrollo (`pytest`, `black`, `flake8`, `pylint`) para las fases de mejora.
- **Manejo de errores:** estrategias definidas para archivos inexistentes, CSV mal formados, fallos de conexión, errores de inserción y validaciones, con acciones específicas (logs, exit codes, reintentos, rollback, reportes detallados).

## 8. Configuración y Parámetros Operativos
- **Variables de entorno:** credenciales de DB, `BATCH_SIZE` (1-10,000), `DUPLICATE_MODE` (`skip` o `fail`), `MAX_INVALID_PERCENTAGE` (0-100) y `DB_CONNECTION_TIMEOUT` (segundos).
- **Flags del CLI:** `--dry-run`, `--yes`, `--no-utf-icons`, `--delimiter`, `--target-table`, `--no-validate`, `--batch-size`, `--duplicate-mode`.
- **Delimitadores soportados:** `^` (default), coma, barra vertical, punto y coma y tabulador; se detecta automáticamente y puede forzarse con `--delimiter`.
- **Estrategia de interacción:** si los registros inválidos superan el porcentaje permitido, el sistema solicita confirmación antes de continuar; el modo `--yes` omite la confirmación para orquestaciones automatizadas.

## 9. Modelo de Datos y Esquemas
- **`tamizados_con_sin_reporte_c2`:** tabla simplificada con PK en `cve_curp`, columnas opcionales (`cve_escuela`, `id_turno`, `ref_correo`, `ref_telefono`, `estatus_reporte`) e índices por escuela y estatus. Pensada para ingestiones rápidas con datos mínimos.
- **`menor_evaluado`:** tabla extendida con PK compuesta (`cve_curp`, `cve_escuela`, `id_ciclo_escolar`), campos obligatorios (`id_turno`, `id_ciclo_escolar`) y controles de dominio (CURP, correo, turno, estatus). Es el destino principal del loader con validaciones activas.
- **Reglas clave:** CURP en mayúsculas y con regex oficial, correos con formato válido, turnos limitados a `1-5`, estatus `REPORTE DESCARGADO` o `SIN REPORTE`, teléfonos depurados a dígitos y separadores permitidos.
- **Soporte a CSV mínimos:** si únicamente llegan `CVE_CURP`, `REF_CORREO_RESPONSABLE` y `REF_TELEFONO`, el loader rellena con `NULL` las columnas faltantes, lo cual es coherente con haber hecho de `cve_escuela` un campo opcional en la tabla simplificada.

## 10. Stakeholders y Gobernanza
- **Product Owner:** prioriza requisitos y valida entregables; participación alta en cada hito.
- **Equipo de Salud / Operadores:** provee CSV, valida resultados, documenta incidencias; involucramiento medio.
- **Arquitecto / Desarrollador Python:** diseña, implementa y da soporte al loader; responsabilidad alta.
- **DBA:** ejecuta DDL, vigila integridad y rendimiento, gestiona respaldos; involucramiento medio-alto.
- **QA / Tester:** diseña y ejecuta pruebas unitarias, de integración y UAT; rol intensivo durante construcción y transición.
- **DevOps:** configura entornos, contenedores opcionales y pipelines de CI/CD; participación media.
- **Seguridad / Cumplimiento:** revisa controles de datos sensibles y políticas de acceso; participación media.
- **Interesados secundarios:** administradores de sistemas y usuarios institucionales que reciben reportes derivados.

## 11. Casos de Uso y Escenarios de Prueba
- **UC-01 Cargar datos desde CSV:** flujo completo desde la ejecución del comando hasta la confirmación de la transacción y la emisión del reporte.
- **UC-02 Validar estructura:** comparación de encabezados con el esquema mínimo y reacción inmediata ante discrepancias.
- **UC-03 Validar registros:** reglas por campo (CURP, correo, teléfono, turno, estatus) con bitácora de errores detallados.
- **UC-04 Insertar datos:** inserciones por lotes con control transaccional, métricas de rendimiento y configuraciones para duplicados (`skip`/`fail`).
- **UC-05 Manejar errores / rollback:** acciones frente a `IntegrityError`, `CheckViolation`, pérdida de conexión o timeouts, siempre con rollback y registro.
- **UC-06 Generar reporte de carga:** estadísticas (totales, válidos, inválidos, duplicados, rendimiento) y, cuando aplica, archivos de rechazo.
- **UC-07 Configurar sistema:** uso de `.env` y parámetros CLI para adecuar el entorno.
- **UC-08 Consultar logs:** revisión de archivos `logs/` y reportes para diagnóstico post-mortem.
- **Escenarios de prueba recomendados:** carga exitosa de 1,000 registros, CSV sin columnas clave, registros parcialmente inválidos, duplicados, desconexión de BD, ejecución de `--dry-run` y `--no-validate`.

## 12. Scripts de Soporte Destacados
- `load_raw_no_validation.py`: inserción masiva con COPY FROM STDIN, detección automática de delimitador y selección de tabla según encabezado.
- `post_load_check.py`: compara CURPs del CSV contra la tabla destino y registra los hallazgos en `logs/post_load_check.txt`.
- `generate_statistics.py`: calcula totales, distribución por turno/ciclo/estatus, top escuelas, duplicados y calidad de datos de contacto.
- `check_table_pk.py` y `modify_pk_menor_evaluado.py`: verifican y ajustan la clave primaria de `menor_evaluado` durante migraciones.
- `filter_wellformed_csv.py` y `clean_csv_for_loader.py`: normalizan delimitadores, corrigen encabezados y filtran registros válidos antes de la carga.
- `generate_full_comparison_reports.py`: compara padrones entre ciclos y genera CSV con diferencias y métricas resumidas.
- `db_counts.py`, `copy_csv_to_table.py`, `stats_rapido.py`: herramientas rápidas para conteos, ejecuciones COPY controladas y reportes estadísticos en consola.
- Scripts adicionales (`analisis_avanzado.py`, `analisis_estados_por_ciclo.py`, `truncate_menor.py`, `prepare_env.ps1`, `markdownlint_local.py`, etc.) complementan el ecosistema con tareas de análisis, mantenimiento y estandarización documental.

## 13. Calidad de Datos y Validaciones
- **Estructura mínima:** `CVE_CURP`, `REF_CORREO_RESPONSABLE`, `REF_TELEFONO`. Para la tabla extendida se requieren `CVE_ESCUELA`, `ID_TURNO`, `ID_CICLO_ESCOLAR`.
- **Validación por fila:** la función `validar_fila()` devuelve mensajes explicativos; los registros rechazados se guardan para seguimiento.
- **Umbral de errores:** configurable mediante `MAX_INVALID_PERCENTAGE`; si se excede, el operador decide si continúa solo con registros válidos.
- **Modos preventivos:** `--dry-run` para medir calidad y tiempo sin tocar la base, `--no-validate` para contextos controlados y `--yes` para automatizar decisiones.
- **Respaldo de BD:** constraints de formato y clave aseguran que, aun si se omiten validaciones, la base rechace datos incorrectos.

## 14. Operación por Escenarios
| Escenario | Recomendación |
|-----------|---------------|
| Operación estándar | Ejecutar `load_tamizajes.py` con validaciones completas y conservar la salida de consola y los archivos `salida*.txt`. |
| Validación previa | Usar `--dry-run` y un CSV de ejemplo para comprobar columnas, delimitador y tiempos antes de la corrida oficial. |
| Migración masiva | Emplear `load_raw_no_validation.py` o `copy_csv_to_table.py` con respaldo previo y conteos antes/después firmados por el DBA. |
| Reprocesos / limpieza | Aplicar `truncate_menor.py` y `modify_pk_menor_evaluado.py` bajo bitácora formal y permisos del DBA. |
| Monitoreo post-carga | Ejecutar `post_load_check.py`, `generate_statistics.py` y conservar los reportes en la carpeta `reportes/`. |

## 15. Análisis y Reportes
- `generate_statistics.py`, `stats_rapido.py` y `db_counts.py` entregan resúmenes inmediatos para las actas de cierre.
- `analisis_estados_por_ciclo.py` y `analisis_avanzado.py` profundizan en distribución geográfica, duplicados y variaciones inter-ciclos.
- `generate_comparison_reports.py` y `generate_full_comparison_reports.py` generan CSV con diferencias, métricas y totales para auditorías.
- Los archivos `salida_carga_ciclo2.txt`, `estadisticas_basicas.txt`, `estadisticas_utf8.txt`, `estados_por_ciclo.txt`, `comparison_summary.md`, `comparison_metrics.csv`, `totales.csv` sirven como evidencia cuantitativa del proceso.

## 16. Riesgos y Controles
| ID | Riesgo | Prob. | Impacto | Control actual | Mejora sugerida |
|----|--------|-------|---------|----------------|-----------------|
| R01 | Exposición de datos sensibles | Media | Crítico | `.gitignore`, `.env.sample`, políticas de commit | Secret scanning en CI y revisión forense si ocurre incidente |
| R02 | Credenciales hardcodeadas | Baja | Alto | Variables de entorno y `python-dotenv` | Gestionar secretos en Vault/CI y rotar credenciales tras cada entrega |
| R03 | CSV mal formados | Alta | Medio | Validadores robustos, plantillas y `--dry-run` | Checklist firmado por operadores antes de ejecutar |
| R04 | Caída de conexión | Media | Alto | Transacciones + rollback, reintentos manuales | Automatizar reintentos con backoff y checkpoints por lote |
| R05 | Rendimiento insuficiente | Media | Medio | Batch configurable y scripts COPY | Benchmarks periódicos (>100k registros) y ajuste dinámico de `BATCH_SIZE` |
| R06 | Duplicados | Media | Alto | PK únicas, validación de CURP, reportes comparativos | Tabla de auditoría y alertas automáticas sobre duplicados recientes |
| R07 | Pérdida de datos | Baja | Crítico | Respaldos previos, verificación post-carga | Procedimientos documentados de restauración y pruebas trimestrales |
| R08 | Falta de logging persistente | Media | Medio | Reportes en consola y archivos manuales | Logging estructurado (JSON) y tabla `operaciones_carga` |
| R09 | Vulnerabilidades en dependencias | Baja | Alto | Versionado en `requirements` y recomendaciones de `pip-audit` | Escaneo semanal automatizado y alertas al PO |
| R10 | Script interactivo bloquea automatización | Media | Medio | Flags `--dry-run`, `--no-validate`, `--yes` en backlog | Implementar modos no interactivos y documentación para CI |

## 17. Backlog Inmediato
1. **Estructura y gobernanza:** asegurar carpetas mínimas (`db`, `data`, `tests`, `docs`), `.gitignore`, `.env.sample`, `requirements`, README ampliado y políticas de secreto.
2. **Modularización:** extraer módulos `config.py`, `db.py`, `validators.py`, `cli.py` para mejorar mantenibilidad y facilitar pruebas unitarias.
3. **Validaciones y pruebas:** implementar suites `pytest`, cobertura ≥ 80%, fixtures de CSV y pruebas de integración con PostgreSQL (Docker opcional).
4. **Calidad y CI:** habilitar `black`, `flake8`, `pylint`, pipelines de GitHub Actions que ejecuten lint + pruebas en cada PR.
5. **Logging y auditoría:** generar logs estructurados (JSON), almacenar hash del archivo cargado, timestamps, usuario y tabla `operaciones_carga`.
6. **Observabilidad avanzada:** crear dashboards con los CSV de estadísticas y comparaciones para compartir con stakeholders.

## 18. Métricas, KPIs y Herramientas
- **Calidad de código:** cobertura ≥ 80%, complejidad ≤ 10 por función, cumplimiento PEP8, cero vulnerabilidades críticas.
- **Rendimiento:** <30 s por cada 10k registros, memoria <500 MB para archivos de 100k, tasa de éxito ≥ 99%.
- **Proceso:** velocidad por iteración (story points), defectos abiertos vs resueltos, tiempo medio de resolución, adherencia al cronograma.
- **Herramientas:** Python 3.10+, VS Code, `pandas`, `psycopg2-binary`, `python-dotenv`, `pytest`, `black`, `flake8`, `pylint`, GitHub Actions, Docker para PostgreSQL local, PlantUML para diagramas y markdownlint para estandarizar documentación.

## 19. Recomendaciones Operativas
1. Utilizar siempre `data/data.example.csv` para validar el pipeline antes de usar datos reales y conservar todos los archivos `salida*.txt` y `logs/post_load_check.txt` como evidencia.
2. Registrar los conteos antes/después en `reportes/` cuando se recurra a COPY o scripts de truncado y anexar esos registros al acta mensual.
3. Proteger `.env` con permisos mínimos y gestionar las credenciales definitivas mediante un gestor seguro (Vault o equivalente institucional).
4. Revisar el backlog de manera quincenal para mantener priorizadas las mejoras de seguridad, automatización y observabilidad.
5. Activar escaneo de dependencias (`pip-audit`, `safety`) y secret scanning en CI para detectar riesgos de manera temprana.

## 20. Anexo Estadístico Detallado
### 20.1 Distribución por Entidad Federativa
Los siguientes valores provienen del procesamiento del 13 de noviembre de 2025 (totales: ciclo 1 = 3,936,812; ciclo 2 = 2,353,038; global = 6,289,850). Se listan las 20 entidades con mayor volumen y una fila adicional que agrupa al resto de los estados y códigos especiales.

| Estado | Ciclo 1 | % Ciclo 1 | Ciclo 2 | % Ciclo 2 | Total | % Global |
|--------|---------|-----------|---------|-----------|-------|----------|
| Estado de México | 553,282 | 14.05% | 274,544 | 11.67% | 827,826 | 13.16% |
| Veracruz | 317,891 | 8.07% | 250,852 | 10.66% | 568,743 | 9.04% |
| Chiapas | 391,413 | 9.94% | 141,095 | 6.00% | 532,508 | 8.47% |
| Puebla | 346,112 | 8.79% | 150,589 | 6.40% | 496,701 | 7.90% |
| Ciudad de México | 208,125 | 5.29% | 180,741 | 7.68% | 388,866 | 6.18% |
| Guanajuato | 167,291 | 4.25% | 177,563 | 7.55% | 344,854 | 5.48% |
| Nuevo León | 174,608 | 4.44% | 133,391 | 5.67% | 307,999 | 4.90% |
| Jalisco | 207,146 | 5.26% | 97,925 | 4.16% | 305,071 | 4.85% |
| Tamaulipas | 109,477 | 2.78% | 68,844 | 2.93% | 178,321 | 2.84% |
| Coahuila | 109,520 | 2.78% | 33,889 | 1.44% | 143,409 | 2.28% |
| Tabasco | 78,190 | 1.99% | 66,822 | 2.84% | 145,012 | 2.31% |
| Michoacán | 65,199 | 1.66% | 69,960 | 2.97% | 135,159 | 2.15% |
| Chihuahua | 76,973 | 1.96% | 49,729 | 2.11% | 126,702 | 2.01% |
| Sinaloa | 75,128 | 1.91% | 44,786 | 1.90% | 119,914 | 1.91% |
| Sonora | 60,612 | 1.54% | 45,680 | 1.94% | 106,292 | 1.69% |
| Morelos | 62,149 | 1.58% | 40,796 | 1.73% | 102,945 | 1.64% |
| Aguascalientes | 63,158 | 1.60% | 39,724 | 1.69% | 102,882 | 1.64% |
| Tlaxcala | 61,767 | 1.57% | 37,648 | 1.60% | 99,415 | 1.58% |
| Guerrero | 63,736 | 1.62% | 35,041 | 1.49% | 98,777 | 1.57% |
| Querétaro | 52,295 | 1.33% | 46,474 | 1.98% | 98,769 | 1.57% |
| Otros estados y códigos especiales | 793,478 | 20.16% | 448,282 | 19.05% | 1,241,760 | 19.75% |

### 20.2 Top de Escuelas y Cobertura de Contacto

| Posición | CCT | Registros |
|----------|-----|-----------|
| 1 | 10EPR0480A | 2,201 |
| 2 | 21EPR0010P | 1,595 |
| 3 | 21EPR0416F | 1,535 |
| 4 | 21EPR0419C | 1,479 |
| 5 | 21EPR0515F | 1,459 |

| Indicador | Valor |
|-----------|-------|
| Registros con correo del responsable | 6,289,389 (99.9%) |
| Registros con teléfono del responsable | 6,287,520 (99.9%) |
| Registros con estatus `CON_DESCARGA` | 4,569,700 (72.6%) |
| Registros con estatus `SIN_DESCARGA` | 1,726,249 (27.4%) |

### 20.3 Variación por Ciclo
- Entidades con mayor incremento relativo en el ciclo 2: Michoacán (+7.3%), Guanajuato (+6.1%).
- Entidades con mayor decremento relativo: Baja California Sur (-70.2%), Durango (-79.7%), junto con códigos especiales que representan registros residuales.
- Los patrones muestran concentración en las mismas entidades líderes, pero con participación proporcional mayor en Veracruz, Guanajuato y Ciudad de México durante el ciclo 2.

---
**Conclusión.** El subproyecto **vida-saludable** cuenta con todos los artefactos necesarios para ejecutar, auditar y evolucionar la carga de tamizajes del ciclo 2. La integración de scripts de ingesta y verificación, documentación metodológica, estadísticas operativas, métricas y planes de mitigación garantiza trazabilidad completa y prepara el terreno para mejoras continuas sin recurrir a documentación externa.
