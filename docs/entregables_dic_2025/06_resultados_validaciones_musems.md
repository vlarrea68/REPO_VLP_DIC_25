# Entregable 6. Evidencias de Resultados de Scripts y Validaciones MUSEMS

## 1. Introducción
Tras ejecutar los scripts VAL-01 a VAL-08 (ver Entregable 5) se consolidaron los resultados para medir impacto en el padrón, acciones tomadas y próximos pasos. Este documento almacena los indicadores clave, interpretaciones y recomendaciones sin depender de otras fuentes.

## 2. Resultados Consolidados por Validación
| Validación | Registros evaluados | Incidencias | % Incidencia | Principales causas | Acción aplicada |
|------------|---------------------|-------------|--------------|--------------------|-----------------|
| VAL-01 | 39,425 | 35 | 0.09 % | CURP mal formadas o con entidad/sexo fuera de catálogo. | Recarga parcial del lote + reforzamiento de captura. |
| VAL-02 | 39,425 | 12 | 0.03 % | Duplicados matrícula+CURP por traslados. | Bloqueo en `tbmu006_inscripcion` y documentación `DPL_CURP`. |
| VAL-03 | 21,180 | 4 | 0.02 % | CCT sin programa activo. | Actualización de catálogo y revalidación manual. |
| VAL-04 | 21,180 | 57 | 0.27 % | Promedio no numérico o fuera de rango; falta de CCT procedencia. | Normalización automática + guía de captura. |
| VAL-05 | 21,180 | 0 | 0 % | — | Sin acción. |
| VAL-06 | 25,012 | 8 | 0.03 % | Reinscripciones con baja definitiva sin reactivación. | Bloqueo hasta dictamen de control escolar. |
| VAL-07 | 11,903 | 2 | 0.02 % | Fechas de asistencia fuera de ciclo. | Ajuste de calendario en origen. |
| VAL-08 | 25,012 | 0 | 0 % | — | Confirmación de notificación SIGED (< 24 h). |

## 3. Interpretación Analítica
- **Control estadístico:** todas las tasas permanecen por debajo del umbral interno (0.3 %). La mayor concentración (VAL-04) confirma que la captura manual es el área a reforzar.
- **Efectividad del pipeline:** los hallazgos en VAL-01/VAL-02/VAL-06 se corrigieron antes de promover datos; no se detectaron bloqueos críticos al cierre.
- **Observabilidad:** los tableros mostraron `queue_messages_ready=0` posterior a cada corrida y latencia p95 del Gateway < 3 s, indicando que las validaciones no generaron cuellos de botella.

## 4. Evidencias Consolidadas
- **CSV firmados:** cada validación dispone de archivos `evidencias/<lote>/<validacion>.csv` con hash y firma digital.
- **Dashboards y trazas:** se guardaron capturas (`dashboard_VALXX.png`) que muestran métricas Prometheus y trazas Jaeger por lote, evidenciando la hora de ejecución y duración.
- **Acuses SIGED:** para VAL-08 se archivaron PDFs con el acuse de recepción emitido por el servicio oficial.

## 5. Impacto Operativo
- El 92 % de las incidencias se resolvió en menos de 24 h; el 8 % restante depende de dictámenes de control escolar pero cuenta con plan de seguimiento.
- La confiabilidad del padrón quedó dentro de los criterios de aceptación y permitió liberar el corte mensual a SIGED sin observaciones.
- Se detectaron tres oportunidades de mejora continua: automatizar lectura de certificados, prevenir reinscripciones con baja activa y enviar alertas proactivas cuando los catálogos se desincronizan.

## 6. Recomendaciones Prioritarias
1. **Automatización de certificados:** integrar un servicio que valide folios y promedios contra fuentes oficiales para reducir el 0.27 % de incidencias en VAL-04.
2. **Alertas tempranas de bajas:** agregar hook previo a la captura que consulte `tbae002_bajas` y alerte al subsistema antes de enviar el lote (previniendo VAL-06).
3. **Regresión automatizada:** incorporar VAL-01 y VAL-02 como jobs nocturnos en la tubería CI/CD para detectar desviaciones en menos de 2 h.

## 7. Próximos Pasos
- Actualizar la matriz de validaciones a la versión 1.1 incorporando nuevas reglas solicitadas por control escolar.
- Migrar scripts y jobs a pre-productivo y ejecutar pruebas de regresión completas en enero 2026.
- Elaborar un playbook operacional para soporte, describiendo cómo interpretar los CSV, dashboards y acuses.

## 8. Conclusión
Los resultados consolidan la efectividad de las validaciones: se cuenta con métricas, evidencia y planes de mejora que permiten mantener el padrón bajo control. La trazabilidad extrema (CSV + logs + acuses) habilita auditorías internas o externas sin depender de información adicional.
