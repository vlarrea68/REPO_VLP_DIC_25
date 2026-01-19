# Entregable 7. Reporte Técnico del Sistema Vida Saludable (Ciclo 2)

## 1. Objetivo y Alcance
Este reporte documenta exhaustivamente el estado del repositorio **vida-saludable** integrado al portafolio del mes de diciembre de 2025. El objetivo es consolidar, en un único entregable, la información crítica del sistema de carga de tamizajes (ciclo 2) que incluye scripts operativos, artefactos de diseño bajo metodología RUP y lineamientos para ejecución segura. El alcance cubre siete dimensiones: contexto del proyecto, arquitectura, modelo de datos, stakeholders, casos de uso, riesgos y plan de implementación.

## 2. Inventario del Repositorio Vida Saludable
| Elemento | Descripción | Referencia |
|----------|-------------|------------|
| README general | Guía de instalación, prerrequisitos, estructura y modos de carga (`load_tamizajes.py`, `scripts/load_raw_no_validation.py`, banderas `--target-table`, `--no-validate`, `--dry-run`). | `vida-saludable/README.md` |
| Scripts principales | `load_tamizajes.py` (loader validado) y auxiliares en `scripts/` para verificaciones e inserciones masivas. | `vida-saludable/load_tamizajes.py`, `vida-saludable/scripts/` |
| Documentación | Carpeta `docs/` con Plan Maestro, Arquitectura, Visión, Stakeholders, Modelo de Datos, Casos de Uso, Análisis de Riesgos y Tareas de implementación. | `vida-saludable/docs/*.md` |
| Datos y evidencias | Directorios `data/`, `logs/`, salidas de ejecución (`salida_carga_ciclo2.txt`, etc.) y DDL en `db/`. | `vida-saludable/data/`, `vida-saludable/db/` |
| Dependencias | `requirements.txt` con pandas, psycopg2-binary, python-dotenv y toolchain opcional para pruebas (pytest, black, flake8, pylint). | `vida-saludable/requirements.txt` |

## 3. Contexto y Plan Maestro (docs/00_PLAN_MAESTRO_RUP.md)
- **Metodología:** RUP, versión 1.1, orientada a un MVP de ejecución única que ya cuenta con el script operativo.
- **Propósito:** Formalizar la entrega, registrar decisiones y mantener backlog para mejoras (modularización, CI, logging persistente, tabla de auditoría).
- **Entregables vigentes:** `load_tamizajes.py`, documentación técnica (arquitectura, modelo, casos de uso, riesgos), `README.md`, `requirements.txt`, `db/ddl_tamizados.sql`.
- **Criterios de aceptación:** corrida exitosa en entorno de pruebas, coincidencia entre registros insertados y filas válidas, ausencia de datos sensibles en el repo y resguardo de reporte final.
- **Backlog prioritario:** flags `--dry-run`/`--yes`, separación en módulos (`config.py`, `db.py`, `validators.py`), logging estructurado y suite de pruebas.

## 4. Arquitectura de Software (docs/01_ARQUITECTURA_SOFTWARE.md)
- **Vista general:** Proceso CLI monolítico que lee CSV, ejecuta validaciones y persiste en PostgreSQL mediante transacciones. Componentes clave: loader, configuración `.env`, DB PostgreSQL 14 y scripts auxiliares.
- **Flujo de ejecución:** (1) cargar configuración, (2) leer CSV con pandas, (3) validar estructura y cada fila, (4) conectar a BD, (5) insertar por lotes, (6) consolidar reporte y cerrar recursos.
- **Objetivos arquitectónicos:** simplicidad, seguridad (sin credenciales en código), confiabilidad (rollback automático), rendimiento (batch configurable) y observabilidad básica.
- **Despliegue:** entorno Python 3.10+, dependencias mínimas, ejecución en Windows/Linux/macOS; BD administrada por DBA. Se contemplan diagramas de error handling, despliegue y vistas lógicas que documentan la responsabilidad de cada módulo previsto.

## 5. Modelo de Datos (docs/02_MODELO_DATOS.md)
- **Nota estratégica:** los scripts aceptan CSV delimitados por `^` pero admiten anulación vía `--delimiter`. Se toleran archivos "mínimos" (solo `CVE_CURP`, `REF_CORREO_RESPONSABLE`, `REF_TELEFONO`) y el loader completa columnas faltantes con `NULL`.
- **Tabla foco (`tamizados_con_sin_reporte_c2` / `menor_evaluado`):**
  - PK centrada en `cve_curp` (versión reciente) con campos opcionales para escuela y turno.
  - Checks para CURP (`^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$`), turnos (`1-5`) y estatus (VALOR enumerado). Correos con regex y teléfonos normalizados.
  - Índices dedicados (`idx_tamizados_escuela`, `idx_tamizados_estatus`, `idx_tamizados_escuela_estatus`) y políticas de permisos restringidas.
- **Diccionario de datos:** especifica tipo, obligatoriedad, ejemplo y reglas de cada campo, reforzando validaciones implementadas en el loader.

## 6. Stakeholders y Gobernanza (docs/02_STAKEHOLDERS.md)
| Rol | Responsabilidad | Nivel de involucramiento |
|-----|-----------------|--------------------------|
| Product Owner | Prioriza requisitos y acepta entregables. | Alta |
| Equipo de Salud / Operadores | Suministran CSV y validan resultados. | Media |
| Arquitecto / Desarrollador Python | Diseña y mantiene el loader. | Alta |
| DBA | Revisa modelo, ejecuta DDL y asegura integridad. | Media-Alta |
| Tester / QA | Define casos de prueba e informa defectos. | Alta durante construcción |
| DevOps | Prepara entornos, CI/CD y scripts de despliegue. | Media |
| Analista de Seguridad | Audita controles sobre datos sensibles. | Media |

## 7. Casos de Uso (docs/03_CASOS_USO.md)
- **UC-01 Cargar Datos desde CSV:** flujo de punta a punta desde la ejecución del comando hasta la confirmación de la transacción y generación del reporte.
- **UC-02 Validar Estructura:** garantiza presencia de columnas mínimas y reporta diferencias contra el esquema esperado.
- **UC-03 Validar Registros:** aplica reglas por campo (CURP, correo, turno, estatus) y soporta modos configurables ante duplicados.
- **UC-04 Insertar Datos en BD:** inserciones por lotes con transacciones y métricas de rendimiento.
- **UC-05 Manejar Errores / Rollback:** detalla acciones frente a `IntegrityError`, `CheckViolation`, pérdida de conexión o timeouts.
- **UC-06 Generar Reporte de Carga:** consolida métricas (registros totales, válidos, inválidos, rendimiento, estatus) y, cuando aplica, crea archivos de rechazo.
- Casos secundarios incluyen la configuración vía `.env`, ejecución en modo rápido (`--no-validate`) y validaciones post-carga.

## 8. Riesgos y Mitigaciones (docs/04_ANALISIS_RIESGOS.md y resumen del Plan Maestro)
| ID | Riesgo | Prob. | Impacto | Mitigación principal | Contingencia |
|----|--------|-------|---------|----------------------|--------------|
| R01 | Exposición de datos sensibles en commits. | Media | Crítico | `.gitignore`, pre-commit y revisiones. | Limpieza de historial y rotación de credenciales. |
| R03 | CSV mal formados o inconsistentes. | Alta | Medio | Validaciones previas, modo `--dry-run`, plantillas de ejemplo. | Rechazar carga y entregar reporte detallado al operador. |
| R04 | Caída de conexión a BD durante la carga. | Media | Alto | Transacciones por lote, reintentos y pruebas de estrés. | Rollback automático y reintento desde último checkpoint. |
| R05 | Rendimiento insuficiente con archivos masivos. | Media | Medio | Inserción por lotes, opción COPY sin validaciones, pruebas de performance. | Particionar archivos o ejecutar en ventanas nocturnas. |
| R06 | Duplicación de registros. | Media | Alto | Constraints PK/unique y deduplicación previa. | Scripts de limpieza y restauración desde backup. |
| R09 | Vulnerabilidades en dependencias. | Baja | Alto | `requirements.txt` versionado y escáneres (safety/pip-audit). | Actualización urgente de dependencias y comunicación a DevSecOps. |

## 9. Plan de Implementación y Backlog (docs/04_TAREAS_IMPLEMENTACION.md)
- **Fase 1 (Configuración):** creación de estructura mínima (`db/`, `data/`, `tests/`, `docs/`), `.gitignore`, `.env.sample`, `requirements.txt` y README enriquecido con guías de uso.
- **Fase 2 (Módulos core):** diseño de `config.py`, `validators.py`, `db.py`, `cli.py`, separación de responsabilidades y definición de excepciones custom.
- **Fase 3 (Validaciones y pruebas):** implementación de suites pytest, cobertura deseada ≥ 80%, construcción de fixtures y pruebas de integración con PostgreSQL (Docker opcional).
- **Fase 4 (Operación y CI/CD):** scripts de despliegue, GitHub Actions, logging estructurado, tablero de métricas y mantenimiento de documentación.
- Cada tarea incorpora objetivos, comandos sugeridos y criterios de aceptación, lo que facilita la ejecución asistida por agentes IA o nuevos integrantes.

## 10. Recomendaciones Operativas
1. **Ejecución controlada:** utilizar `.env.sample` como plantilla, validar credenciales y ejecutar en entorno de pruebas antes de producción.
2. **Monitoreo:** registrar cada corrida (logs, archivos `salida_*.txt`) y conservarlos en `reportes/` para trazabilidad.
3. **Data Governance:** nunca subir CSV reales; usar `data.example.csv` para pruebas y modo `--dry-run` para validar estructuras.
4. **Estrategia dual de carga:** elegir entre `load_tamizajes.py` (con validaciones) y `scripts/load_raw_no_validation.py` (modo DBA) según el objetivo operativo, registrando siempre la decisión y la evidencia resultante.
5. **Seguimiento del backlog:** planificar la modularización del script, habilitar flags no interactivos y formalizar CI básico como parte del próximo ciclo de mejora.

---
**Conclusión:** El directorio **vida-saludable** cuenta con artefactos completos para ejecutar, documentar y mejorar el proceso de carga de tamizajes. Este entregable integra la trazabilidad requerida y habilita la extensión del sistema en próximos meses sin depender de información externa al repositorio.
