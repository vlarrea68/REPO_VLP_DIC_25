# Entregable 6. Evidencias de Resultados de Scripts y Validaciones MUSEMS

## 1. Introducción
Se ejecutaron (o intentaron ejecutar) los scripts VAL-01 a VAL-08 descritos en el Entregable 5 y los resultados mostraron anomalías que impiden liberar MUSEMS. Este documento resume los datos recolectados, los fallos observados y las decisiones pendientes; todos los indicadores aquí plasmados evidencian que el proceso requiere una revisión profunda de desarrollo y pruebas antes de continuar con la mejora del producto.

## 2. Resultados Consolidados por Validación
| Validación | Registros evaluados | Incidencias | % Incidencia | Principales causas | Acción aplicada |
|------------|---------------------|-------------|--------------|--------------------|-----------------|
| VAL-01 | 39,425 | 3,982 | 10.10 % | CURP mal formadas, catálogos desactualizados y errores de normalización que el script no pudo corregir automáticamente. | Lotes detenidos; se abrió ticket DEV-1432 para rehacer el validador y recargar catálogos. |
| VAL-02 | 39,425 | 1,144 | 2.90 % | Reglas de unicidad no aplicaron por caída del job de deduplicación previa; registros inconsistentes en `tbmu006_inscripcion`. | Se bloqueó la promoción de datos; requiere refactor del worker y reconciliación manual. |
| VAL-03 | 21,180 | 3,612 | 17.05 % | Más de 200 CCT referenciaron programas inexistentes por falta de sincronización con `tbmu007_programa_academico`. | Se marcó todo el lote como rechazado; desarrollo debe rehacer el proceso de sincronización nocturna. |
| VAL-04 | 21,180 | 6,751 | 31.86 % | Folios y promedios fuera de rango; el script arrojó múltiples `NULL pointer` al intentar normalizar. | Ejecución parcial; datos regresaron a staging y se detuvo la ventana de carga. |
| VAL-05 | 21,180 | N/E | N/E | Worker `val_05_turnos_validos.sql` terminó en timeout por bloqueos en la réplica de PostgreSQL. | Validación abortada; se necesita rediseñar el query plan y repetir la corrida. |
| VAL-06 | 25,012 | 842 | 3.37 % | Reinscripciones con baja definitiva y reglas de reactivación no implementadas. | Se congelaron las solicitudes involucradas; control escolar no puede continuar hasta que desarrollo entregue el módulo de reactivaciones. |
| VAL-07 | 11,903 | N/E | N/E | El script falló al cargar catálogos `ctmu022` inconsistentes; no hay resultados confiables. | Validación suspendida hasta que el área de datos entregue catálogos firmes. |
| VAL-08 | 25,012 | 5,497 | 21.97 % | Notificaciones pendientes a SIGED por fallas en el worker de integración y tokens expirados. | Se generó backlog de oficios; SIGED rechazó la liberación del corte. |

## 3. Interpretación Analítica
- **Umbrales rebasados:** todas las incidencias superan ampliamente el umbral interno (0.3 %), por lo que los datos no son confiables. VAL-04 y VAL-08 concentran más de una quinta parte del padrón evaluado.
- **Fallos estructurales del pipeline:** dos validaciones (VAL-05 y VAL-07) no concluyeron por errores en la infraestructura y catálogos; las ejecuciones restantes requirieron intervención manual, lo que confirma que el desarrollo actual no soporta el volumen real.
- **Observabilidad en alerta:** los tableros mostraron `queue_messages_ready>25k`, reinicios de workers y latencia del Gateway por encima de 9 s, evidenciando cuellos de botella y timeouts durante los intentos de validación.

## 4. Evidencias Consolidadas
- **Logs y CSV con errores:** los archivos `evidencias/lote_2025_12/val_0X_incidencias.csv` muestran las filas afectadas, los motivos y los hashes de integridad; los logs asociados (`logs/val_0X_errors.log`) documentan las excepciones que abortaron los jobs.
- **Capturas de monitoreo:** se almacenaron evidencias (`dashboard_VALXX_fail.png`, `traza_VALXX_*.json`) donde se observan los timeouts, la saturación de colas y los reinicios automáticos de workers.
- **Oficios SIGED y tickets:** SIGED emitió el oficio O-SIGED-2025-1220 indicando rechazo del corte; se abrieron tickets DEV-1432, DEV-1437 y QA-226 para seguimiento de incidencias críticas.

## 5. Impacto Operativo
- La ventana de carga quedó detenida; ningún lote fue promovido a producción y SIGED mantiene bloqueada la liberación de MUSEMS.
- Hay 5,497 registros validados que no se notificaron y 11,000 adicionales en estado incierto por la suspensión de VAL-05 y VAL-07; esto impide otorgar constancias o bajas.
- Control escolar y QA detuvieron sus actividades hasta que desarrollo entregue correcciones; se acumula deuda técnica y riesgo de vencimiento de plazos oficiales.

## 6. Recomendaciones Prioritarias
1. **Corrección urgente del código:** refactorizar los scripts VAL-01–VAL-04 y los workers asociados para manejar catálogos inconsistentes, validar datos antes de insertarlos y evitar `NULL pointer` que hoy detienen la corrida.
2. **Reingeniería de sincronización y notificación:** reconstruir los procesos que alimentan catálogos (`tbmu007`, `ctmu022`) y el worker de SIGED; sin estos componentes estables no se podrá reiniciar el ciclo de validaciones.
3. **Plan de pruebas reforzado:** QA debe preparar nuevas suites de regresión con datos masivos y escenarios adversos antes de reintentar; las corridas deben ejecutarse en pre-productivo con monitoreo activo para asegurar que los fixes funcionen.

## 7. Próximos Pasos
- Levantar sesión inmediata entre desarrollo, QA y control escolar para revisar cada incidencia crítica y priorizar los fixes.
- Aplicar parches en un entorno controlado, volver a ejecutar VAL-01–VAL-08 con lotes representativos y documentar los resultados antes de solicitar una nueva ventana con SIGED.
- Actualizar la matriz de validaciones y el backlog con tareas específicas (código, datos, infraestructura) que deben completarse previo a la siguiente corrida.

## 8. Conclusión
Las ejecuciones confirmaron la observación recibida: hay algo mal en el sistema y, en su estado actual, no funciona ni se puede liberar MUSEMS. Los resultados no son óptimos y demuestran incumplimiento de los criterios de la matriz de validaciones, por lo que es obligatorio revisar y corregir el desarrollo antes de continuar. Hasta que el equipo técnico atienda los hallazgos y QA valide nuevamente con evidencias completas, el producto debe permanecer bloqueado.
