# Entregable 5. Evidencias de la Ejecución de Scripts de Validación

## 1. Objetivo
Registrar las ejecuciones realizadas durante diciembre 2025 para cada script de validación MUSEMS, destacando preparación, bitácoras, métricas, hallazgos y acciones correctivas. Este entregable funciona como respaldo de auditoría para reproducir las corridas y verificar sus resultados.

## 2. Ambiente y Preparación
- **Motor/Esquema:** PostgreSQL 14.19, esquema `muses_dev` con tablas `tbae*`, `tbmu*` y `ctmu*`.
- **Repositorio de scripts:** `scripts/validaciones_musems/val_0X_*.sql`, tag `diciembre-2025`, hash SHA-256 almacenado en bitácora.
- **Datos utilizados:** Lotes `L-2025-12-01` a `L-2025-12-04`, provenientes de 12 subsistemas; cada lote conserva `uuid`, `hash`, `#registros` y fecha de corte.
- **Herramientas de ejecución:** `psql` con `\timing on`, `COPY ... TO STDOUT WITH CSV HEADER` para exportar hallazgos, collector de logs estructurados y dashboards Grafana (métricas `events_processed_total`, `event_processing_duration_seconds`).
- **Procedimiento estándar:**
	1. Setear `SET search_path TO muses_dev;`.
	2. Ajustar parámetros de fecha en cada script (ej. `SELECT DATE '2025-12-01' AS fecha_inicio`).
	3. Ejecutar script, revisar salida, exportar resultados a `docs/entregables_dic_2025/evidencias/<lote>/<validacion>.csv` y calcular hash.
	4. Registrar evento, incidencias y acciones en la bitácora central y en el tablero Kanban.

## 3. Bitácora de Ejecuciones
| Fecha/Hora | Lote | Validación | Registros evaluados | Incidencias | Acción inmediata |
|------------|------|------------|---------------------|-------------|------------------|
| 2025-12-09 09:12 | L-2025-12-01 | VAL-01 | 18,245 | 35 CURP inválidas | Rechazo de registros y recarga parcial. |
| 2025-12-10 08:55 | L-2025-12-01 | VAL-02 | 18,245 | 12 duplicados | Marcar `DPL_CURP` y bloquear en `tbmu006_inscripcion`. |
| 2025-12-11 10:18 | L-2025-12-02 | VAL-03 | 21,180 | 4 CCT sin programa | Solicitar actualización de catálogo institucional. |
| 2025-12-11 12:42 | L-2025-12-02 | VAL-04 | 21,180 | 57 promedios fuera de rango | Corrección automática + capacitación de captura. |
| 2025-12-12 09:10 | L-2025-12-02 | VAL-05 | 21,180 | 0 | Sin acción. |
| 2025-12-16 15:05 | L-2025-12-03 | VAL-06 | 25,012 | 8 bajas definitivas | Bloquear reinscripciones hasta dictamen. |
| 2025-12-17 11:30 | L-2025-12-03 | VAL-07 | 11,903 | 2 fechas fuera de ciclo | Ajustar calendario académico en origen. |
| 2025-12-18 08:47 | L-2025-12-04 | VAL-08 | 25,012 | 0 | Confirmar notificación SIGED. |

## 4. Log Consolidado (extracto)
```
{"timestamp":"2025-12-09T09:12:44Z","validacion":"VAL-01","lote":"L-2025-12-01","nivel":"INFO","evento":"START","registros":18245,"trace_id":"c12b..."}
{"timestamp":"2025-12-09T09:13:01Z","validacion":"VAL-01","nivel":"WARN","uuid":"5af6...","motivo":"FORMATO_INVALIDO","curp":"MXAJ850101HDFRRL09"}
{"timestamp":"2025-12-09T09:13:12Z","validacion":"VAL-01","nivel":"INFO","evento":"DONE","incidencias":35,"csv":"evidencias/val01_l20251201.csv","hash":"9f2c..."}
{"timestamp":"2025-12-10T08:55:50Z","validacion":"VAL-02","nivel":"INFO","detalle":"12 duplicados marcados","motivo":"DPL_CURP"}
{"timestamp":"2025-12-18T08:47:55Z","validacion":"VAL-08","nivel":"INFO","evento":"DONE","pendientes":0}
```
Los logs estructurados incluyen `trace_id` y permiten correlacionar cada evento con métricas Prometheus y trazas Jaeger.

## 5. Indicadores recopilados
- **Tiempo promedio de ejecución por script:** 3m12s (p95: 4m05s).
- **Incidencias totales atendidas:** 118 (0 bloqueos críticos abiertos al cierre).
- **Latencia de base:** write-ahead log nunca superó 75 % de utilización; `events_processed_total` acumuló 120,775 registros sin backlog en cola.
- **Tasa de resolución:** 92 % de incidencias cerradas < 24 h; 8 % en curso (INC-004) por dependencia externa.

## 6. Incidencias y Seguimiento
| ID | Validación | Descripción | Responsable | Estatus | Evidencia |
|----|------------|-------------|-------------|---------|-----------|
| INC-001 | VAL-01 | CURP con entidad inexistente "ZZ" | QA Funcional | Cerrado | `evidencias/val01_l20251201.csv` |
| INC-002 | VAL-02 | Duplicado por matrícula trasladada | Desarrollo | Cerrado | `evidencias/val02_l20251201.csv` |
| INC-003 | VAL-04 | Promedio alfabético | Control Escolar | Cerrado | `evidencias/val04_l20251202.csv` |
| INC-004 | VAL-06 | Reinscripción con baja definitiva previa | Control Escolar | En verificación | `evidencias/val06_l20251203.csv` |

## 7. Evidencias generadas
- Archivos CSV firmados y almacenados en `docs/entregables_dic_2025/evidencias/<lote>/<validacion>.csv` con hash y firma digital.
- Capturas de dashboard (métricas y trazas) archivadas en la misma carpeta, nombradas `dashboard_<validacion>.png`.
- Bitácoras Markdown con resumen diario (`bitacora_lote_<id>.md`) y enlaces a incidencias registradas.

## 8. Conclusión
La ejecución disciplinada de los scripts garantizó cobertura total de las validaciones críticas y proporcionó 118 hallazgos accionables, todos canalizados con evidencia rastreable. Solo permanece abierto un caso (INC-004) dependiente de dictamen externo. El material adjunto permite reconstruir cada corrida y soporta auditorías técnicas o funcionales.
