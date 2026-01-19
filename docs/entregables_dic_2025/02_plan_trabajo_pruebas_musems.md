# Entregable 2. Planes de Trabajo para Pruebas de Funcionamiento MUSEMS

## 1. Objetivo
Definir el plan integral de pruebas funcionales y técnicas del proceso MUSEMS, alineado con las necesidades de control escolar y las ventanas operativas de diciembre de 2025. El plan cubre preparación, ejecución y cierre, junto con criterios de aceptación, responsables y métricas de salida.

## 2. Alcance
- Pruebas funcionales end-to-end sobre el flujo descrito en el Entregable 1.
- Validación de APIs, colas de ingestión, normalizaciones y generación de reportes.
- Cobertura de escenarios nominales, alternos y de error controlado.
- No incluye pruebas de UX ni performance del front, cubiertas por [pruebas/reporte_pruebas_estres.md](../../pruebas/reporte_pruebas_estres.md).

## 3. Estrategia de Pruebas
| Dimensión | Descripción |
|-----------|-------------|
| Tipo | Funcionales, integración, validación de datos y smoke post despliegues. |
| Técnicas | Uso de datasets sintéticos controlados y datos reales anonimizados. |
| Criterios de Entrada | Lotes aprobados por control escolar, scripts SQL actualizados y ambientes disponibles. |
| Criterios de Salida | 0 defectos críticos abiertos, cobertura de reglas severidad alta al 100 % y acta de conformidad firmada. |

## 4. Calendario Operativo (Diciembre 2025)
| Semana | Actividades clave |
|--------|------------------|
| 1 (2-6 dic) | Revisión de alcance, refresco de ambientes, smoke inicial de ingestión. |
| 2 (9-13 dic) | Ejecución de escenarios nominales y alternos, generación de incidencias. |
| 3 (16-20 dic) | Reejecución tras correcciones, validaciones de scripts VAL-01 a VAL-08. |
| 4 (23-27 dic) | Cierre, consolidación de evidencias y presentación de resultados a control escolar. |

## 5. Plan Detallado por Fase
### Preparación
- Actualización de catálogos y plantillas de datos.
- Configuración de jobs automatizados descritos en [docs/estrategia_ci_cd.md](../estrategia_ci_cd.md).
- Elaboración de bitácora de datos de prueba con hash y procedencia.

### Ejecución
- Secuenciación diaria de casos; cada lote se etiqueta con ID único para trazarlo en `tbae001_inscripcion`.
- Registro de resultados en la bitácora central (ver sección 7).
- Seguimiento de defectos mediante tablero Kanban compartido.

### Cierre
- Validación cruzada de métricas vs. indicadores comprometidos.
- Sesión de retrospectiva y acuerdos para enero 2026.

## 6. Roles y RACI
| Actividad | Responsable | Apoyo | Consultado | Informado |
|-----------|-------------|-------|------------|-----------|
| Preparar datasets | QA Funcional | DBA | Control Escolar | PMO |
| Ejecutar pruebas | QA Funcional | Desarrollo | Control Escolar | PMO |
| Revisar hallazgos | Desarrollo | QA | Control Escolar | PMO |
| Firmar salida | Control Escolar | QA | PMO | Dirección |

## 7. Bitácora y Evidencias
- **Formato base:** incluye ID de caso, lote, script asociado, resultado, log y responsable.
- **Repositorio:** carpeta `docs/entregables_dic_2025` con plantilla en formato Markdown.
- **Automatización:** scripts en [scripts/generate_comments.js](../../scripts/generate_comments.js) se reutilizaron para consolidar comentarios de pruebas.

## 8. Indicadores de Éxito
- Cobertura de escenarios comprometidos: ≥ 95 %.
- Tiempo promedio de ejecución por lote: ≤ 4 min en ambiente de pruebas.
- Índice de reincidencia: ≤ 5 %.
- Tiempo de cierre de defectos críticos: ≤ 24 h.

## 9. Riesgos y Planes de Mitigación
| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Ambientes inestables | Alto | Ventanas de mantenimiento nocturnas y respaldos previos.
| Datos faltantes de instituciones | Medio | Uso de datasets sintéticos y simuladores de carga. |
| Cambios de alcance | Medio | Congelar alcance después de la semana 2 y documentar solicitudes en [docs/minuta_seguimiento.md](../minuta_seguimiento.md). |

## 10. Conclusión
El plan de pruebas proporciona claridad operativa y asegura que los entregables generados (scripts, matrices y evidencias) respondan a criterios verificables. La ejecución disciplinada de este plan habilita la detección temprana de desvíos y la emisión de reportes confiables a las autoridades educativas.
