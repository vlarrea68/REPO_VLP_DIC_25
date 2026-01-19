# Entregable 2. Planes de Trabajo para Pruebas de Funcionamiento MUSEMS

## 1. Objetivo
Definir el plan integral de pruebas funcionales y técnicas del proceso MUSEMS para el ciclo de diciembre 2025. Se detallan estrategias, cronogramas, recursos, escenarios, bitácoras y métricas de salida que aseguran la trazabilidad del aseguramiento de calidad.

## 2. Alcance Detallado
- **Cobertura funcional end-to-end:** Inscripciones, bajas, evaluaciones, certificaciones, titulación y catálogos, replicando los escenarios sintetizados en la guía oficial (CURP válidas, CCT inactivos, duplicidades, firmas digitales, etc.).
- **Capa técnica completa:** API Gateway (validaciones de layout y API Key), servicios de colas, workers de procesamiento/ETL, base PostgreSQL (`tbae*`, `tbmu*`, `ctmu*`) y capa `muses-web` para consulta.
- **Tipologías de prueba:** unitarias, integración, sistema/API, aceptación, rendimiento, carga, estrés, seguridad y auditoría.
- **Fuera de alcance:** infraestructura de redes externas y sistemas estatales; únicamente se simulan a través de datos sintéticos controlados.

## 3. Estrategia de Pruebas
| Dimensión | Descripción ampliada |
|-----------|---------------------|
| Tipos | - **Unitarias:** Jest/Karma para controladores API y componentes Angular.<br>- **Integración:** validación de flujos API→Cola→Worker→BD usando Postman + workers instrumentados.<br>- **Sistema (API E2E):** ejecución de lotes CSV completas y consultas GraphQL reales.<br>- **Aceptación:** usuarios de control escolar navegando `muses-web` con rol OIDC asignado.<br>- **No funcionales:** carga, estrés, seguridad, disponibilidad y trazabilidad (UUID por evento). |
| Técnicas | Datasets sintéticos versionados + datos anonimizados; mocks de RENAPO/CCT; automatización CI/CD para despliegues transitorios; instrumentación con Prometheus/Grafana/Jaeger. |
| Criterios de Entrada | Código desplegado en QA, unitarias ≥ 95 % críticas, catálogos actualizados, ambientes estables, credenciales OIDC vigentes. |
| Criterios de Salida | 0 defectos críticos abiertos, cobertura ≥ 95 % de escenarios críticos, métricas de rendimiento < 3 s promedio, bitácoras completas y acta de conformidad firmada. |

## 4. Calendario Operativo (Diciembre 2025)
| Semana | Actividades clave | Entregables |
|--------|------------------|-------------|
| 1 (2-6 dic) | Kick-off, repaso de alcance, refresco de ambientes, smoke de ingestión, ejecución de casos CP-008/CP-017. | Acta inicio + checklist de ambientes. |
| 2 (9-13 dic) | Escenarios nominales/alternos de inscripciones y bajas (Escenarios 1-3 de los módulos en la guía). Gestión de defectos BUG-101..103. | Reporte diario de avance + tablero Kanban. |
| 3 (16-20 dic) | Reejecución tras correcciones, validaciones VAL-01 a VAL-08, pruebas de seguridad básica y regresión parcial. | Logs firmados + CSV de incidencias. |
| 4 (23-27 dic) | Consolidación de evidencias, sesión de cierre, retrospectiva y planificación enero 2026. | Informe final + minuta AC-2401..2403. |

## 5. Plan por Fase y Módulo
### Preparación
- Actualizar catálogos, layouts y scripts CI/CD; parametrizar pipelines para publicar mensajes en cola y clonar entornos.
- Construir datasets por módulo reutilizando la tabla de escenarios (CURP válidas, CCT inactivos, motivos de baja, evaluaciones duplicadas, etc.).
- Generar hash SHA-256 y registrar procedencia por lote.

### Ejecución
- Etiquetar cada lote (ej. `L-2025-12-01`) y mapearlo contra `tbae001_inscripcion` para trazabilidad.
- Secuenciar casos diarios por módulo: recepciones API, processing worker, consulta, catálogos.
- Registrar resultados y métricas (duración, incidencias) inmediatamente en la bitácora central.

### Cierre
- Consolidar KPI vs metas; revisar que cada requerimiento RF-001..RF-014 tenga al menos un caso ejecutado exitoso.
- Celebrar retrospectiva: qué funcionó, qué mejorar, acuerdos AC-2401..AC-2403 con responsables y fechas.

### Detalle por Módulo (extracto del plan por componente)
| Módulo | Pruebas clave | Criterio |
|--------|---------------|----------|
| Recepción (API) | Validar layout CSV, publicar en cola, cargar 500 req/s por 5 min. | Respuesta < 500 ms, error < 0.1 %. |
| Procesamiento (Workers) | Validar CURP con mock RENAPO, transformar datos, registrar errores en `tbae010_error`. | Registro conforme a resultado, cobertura ≥ 85 %. |
| Consulta / Front | Formularios de búsqueda, guardas de rol, E2E login→consulta. | Usuario completa tarea < 2 min. |

## 6. Roles y RACI
| Actividad | Responsable | Apoyo | Consultado | Informado |
|-----------|-------------|-------|------------|-----------|
| Preparar datasets y ambientes | QA Funcional | DBA, DevOps | Control Escolar | PMO |
| Ejecutar casos funcionales | QA Funcional | Desarrollo | Control Escolar | PMO |
| Automatizar/regresión | Desarrollo | QA | Control Escolar | PMO |
| Revisar hallazgos y aprobar salida | Control Escolar | QA, Desarrollo | PMO | Dirección |

## 7. Bitácora y Evidencias
- **Formato único:**

| Campo | Descripción |
|-------|-------------|
| `id_caso` | Clave CP/RF (ej. CP-008). |
| `lote` | Identificador operativo (L-2025-12-02). |
| `validacion/script` | VAL-XX o script asociado. |
| `resultado` | OK / WARN / FAIL. |
| `incidencias` | Lista de IDs registrados (INC-001, BUG-101). |
| `evidencia` | Ruta al CSV/log firmado, hash y enlace a dashboard. |
| `responsable` | Ejecutor y revisor. |

- **Automatización:** se emplean utilidades internas (scripts `generate_comments` y plantillas Markdown) para consolidar comentarios y logs estructurados.
- **Almacenamiento:** carpeta `docs/entregables_dic_2025/evidencias/` con estructura `/<lote>/<validacion>.csv` y firmas digitales.

## 8. Indicadores de Éxito
- Cobertura ≥ 95 % de escenarios críticos y 100 % de RF-001..RF-014.
- Tiempo promedio de ejecución por lote ≤ 4 minutos; total campaña ≤ 16 h.
- Reincidencia de defectos ≤ 5 %; cierre de críticos ≤ 24 h.
- Métricas de rendimiento del Gateway: latencia p95 < 3 s; disponibilidad ≥ 99.8 % durante pruebas.

## 9. Riesgos y Mitigaciones
| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Ambientes inestables | Alto | Ventanas nocturnas, snapshots previos y playbook de restauración. |
| Datos faltantes de instituciones | Medio | Uso de datasets sintéticos por módulo + simuladores de cola. |
| Cambios de alcance tardíos | Medio | Congelar backlog al cierre de semana 2; cualquier cambio requiere acta con impacto en cronograma y capacidad. |
| Dependencia de servicios externos (RENAPO/SIGED) | Medio | Mocks versionados y registro de latencias para comparar contra ambiente real. |

## 10. Conclusión
El plan operacionaliza la estrategia de pruebas de MUSEMS y deja una guía ejecutable para QA, desarrollo y control escolar. Conecta requerimientos, escenarios, cronograma, bitácoras y métricas para asegurar que cada hallazgo cuente con evidencia rastreable y que el proceso pueda auditarse o repetirse sin pérdida de información.
