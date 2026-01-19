# Entregable 5. Evidencias de la Ejecución de Scripts de Validación

## 1. Objetivo
Registrar las ejecuciones realizadas durante diciembre 2025 para cada script de validación del proceso MUSEMS, destacando lotes procesados, hallazgos y acciones correctivas.

## 2. Ambiente y Preparación
- **Motor:** PostgreSQL 14 en ambiente `muses_dev`.
- **Versión de scripts:** commit `diciembre-2025` del repositorio actual. Los scripts se ubican en `scripts/validaciones_musems/`.
- **Datos:** Lotes etiquetados `L-2025-12-01` a `L-2025-12-04`, conformados por inscripciones de 12 subsistemas.
- **Herramientas:** psql + automatización de logging mediante `	iming on` y exportación a CSV para trazabilidad.

## 3. Bitácora de Ejecuciones
| Fecha | Lote | Validación | Registros evaluados | Incidencias detectadas | Estado |
|-------|------|------------|----------------------|------------------------|--------|
| 2025-12-09 | L-2025-12-01 | VAL-01 | 18,245 | 35 (CURP inválida) | Corregido en carga 2 |
| 2025-12-10 | L-2025-12-01 | VAL-02 | 18,245 | 12 (duplicados) | Registros marcados como rechazados |
| 2025-12-11 | L-2025-12-02 | VAL-03 | 21,180 | 4 (CCT sin programa) | Escalado a control escolar |
| 2025-12-11 | L-2025-12-02 | VAL-04 | 21,180 | 57 (promedio fuera de rango) | Corrección automática |
| 2025-12-12 | L-2025-12-02 | VAL-05 | 21,180 | 0 | Aprobado |
| 2025-12-16 | L-2025-12-03 | VAL-06 | 25,012 | 8 (baja definitiva) | Bloqueado hasta aclaración |
| 2025-12-17 | L-2025-12-03 | VAL-07 | 11,903 | 2 (fecha fuera de ciclo) | Ajuste de calendario |
| 2025-12-18 | L-2025-12-04 | VAL-08 | 25,012 | 0 | Confirmado |

## 4. Log Consolidado
```
[2025-12-09 09:12:44] VAL-01 START - Lote L-2025-12-01
[2025-12-09 09:13:01] VAL-01 WARN - CURP MXAJ850101HDFRRL09 formato incorrecto. Registro UUID=5af6...
[2025-12-09 09:13:12] VAL-01 DONE - 35 incidencias. Archivo evidencias: evidencias/val01_l20251201.csv
[2025-12-10 08:55:22] VAL-02 START - Cross-check with tbmu006_inscripcion
[2025-12-10 08:55:50] VAL-02 INFO - 12 duplicados marcados (motivo DPL_CURP)
[2025-12-10 08:55:58] VAL-02 DONE - Resultado exportado a evidencias/val02_l20251201.csv
```

## 5. Incidencias y Seguimiento
| ID | Validación | Descripción | Responsable | Estatus |
|----|------------|-------------|-------------|---------|
| INC-001 | VAL-01 | CURP con entidad inexistente "ZZ" | QA Funcional | Cerrado |
| INC-002 | VAL-02 | Duplicado por matrícula trasladada | Desarrollo | Cerrado |
| INC-003 | VAL-04 | Promedio alfabético | Control Escolar | Cerrado |
| INC-004 | VAL-06 | Reinscripción pese a baja definitiva | Control Escolar | En verificación |

## 6. Evidencias Adjuntas
- CSV con resultados detallados de cada validación (almacenados en `docs/entregables_dic_2025/evidencias/`).
- Capturas de pantalla de dashboards de monitoreo (referencia en [pruebas/resumen-ejecuciones.md](../../pruebas/resumen-ejecuciones.md)).

## 7. Conclusiones
La ejecución de los scripts se realizó conforme al plan y permitió detectar 118 incidencias, todas canalizadas en menos de 48 horas. Se mantiene un único caso pendiente (INC-004) a la espera de confirmación institucional. La disciplina en la bitácora garantiza trazabilidad y facilita auditorías futuras.
