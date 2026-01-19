# Entregable 1. Análisis del Flujo del Proceso MUSEMS

## 1. Propósito y Alcance
Este documento resume el análisis detallado del flujo operativo de **MUSEMS (Matrícula Única de Educación Media Superior)** correspondiente al ciclo de trabajo de diciembre de 2025. Se cubren todas las etapas desde la captura inicial de expedientes hasta la notificación de resultados al SIGED. El enfoque prioriza la trazabilidad de datos, la interacción entre áreas y la identificación de puntos de control críticos que aseguran la confiabilidad del padrón.

## 2. Metodología Aplicada
- **Revisión documental:** Se contrastó la documentación de arquitectura ([docs/arquitectura_componentes.md](../arquitectura_componentes.md)) con los procesos vigentes, y se actualizaron los diagramas BPMN de referencia.
- **Talleres colaborativos:** Se realizaron tres sesiones con desarrolladores, QA y responsables de negocio para validar actividades, sistemas involucrados y responsables.
- **Shadowing operativo:** Se observaron dos corridas reales durante la ventana de inscripción para registrar variaciones y tiempos reales de respuesta.
- **Mapeo SIPOC:** Se construyó un SIPOC extendido para alinear entradas, salidas y stakeholders clave.

## 3. Descripción del Flujo Macrofase por Macrofase
1. **Captura y Preparación**
   - Origen: Instituciones públicas y privadas mediante plantillas y API abierta descritas en [api/README.md.txt](../../api/README.md.txt).
   - Validaciones inmediatas: estructura del archivo, obligatoriedad de la CURP y consistencia de catálogos básicos (sexo, estado civil, tipo de periodo).
   - Salida: lote empaquetado con metadatos y hash.
2. **Ingesta y Normalización**
   - Ingesta vía colas asíncronas; transformación inicial en la tabla de staging `muses_dev.tbae001_inscripcion`.
   - Normalización de texto, fechas y catálogos; registro de estatus en `ctmu011_estatus_procesamiento`.
3. **Validación de Reglas de Negocio**
   - Reglas automáticas ejecutadas mediante scripts SQL (ver Entregable 4) antes de promover datos a tablas maestras (`tbmu006_inscripcion`).
   - Identificación de duplicidades por CURP/matrícula, verificación de certificados y correspondencia CCT-programa.
4. **Consolidación y Retroalimentación**
   - Cruce con catálogos maestros y con `tbae002_bajas` para detectar inconsistencias.
   - Generación de evidencias y envío de estatus a instituciones vía API.
5. **Cierre y Notificación**
   - Emisión de reportes de control escolar, actualización de indicadores y notificación a SIGED.
   - Archiving controlado de bitácoras y datos sensibles según [docs/diseno_seguridad.md](../diseno_seguridad.md).

## 4. Actores y Responsabilidades
| Actor | Rol dentro del flujo | Responsabilidades clave |
|------|----------------------|--------------------------|
| Equipo de Desarrollo | Custodios del backend y pipelines | Mantenimiento de colas, jobs y scripts de validación. |
| QA Funcional | Supervisión de calidad | Definición y ejecución de planes de prueba, análisis de hallazgos. |
| Control Escolar | Dueños del proceso | Validar reglas de negocio, aprobar excepciones y emitir dictámenes. |
| DBA | Operación base de datos | Garantizar integridad de datos, monitorear desempeño y respaldos. |
| Operación SIGED | Integración externa | Recibir padrones consolidados y confirmar carga exitosa. |

## 5. Puntos de Control Críticos
| ID | Descripción | Momento del flujo | Responsable | Evidencia |
|----|-------------|-------------------|-------------|-----------|
| PC-01 | Validación estructural de lotes | Captura | QA técnico | Log de ingestión y checksum. |
| PC-02 | Normalización de catálogos | Ingesta | DBA | Job `normalize_catalogs` documentado en [docs/diccionario_datos.md](../diccionario_datos.md). |
| PC-03 | Reglas con severidad Alta | Validación | Desarrollo | Resultados de scripts VAL-01 a VAL-05. |
| PC-04 | Cierre de ventana de incidencias | Consolidación | Control Escolar | Acta de conformidad (ver [docs/minuta_seguimiento.md](../minuta_seguimiento.md)). |
| PC-05 | Notificación SIGED | Cierre | Operación SIGED | Acuse de recibo en `tbmu006_inscripcion.notificado_siged`. |

## 6. Riesgos Identificados y Acciones
- **Dependencias externas de catálogos**: se documentó procedimiento de verificación diaria y fallback para trabajar con última versión conocida.
- **Diferencias en CURP/CCT**: se ejecutan reglas de conciliación y se habilitó canal con RENAPO para resolver casos especiales.
- **Sobrecarga en horarios pico**: se habilitó escala horizontal para colas de ingestión y se monitoriza con dashboards descritos en [docs/diseno_observabilidad.md](../diseno_observabilidad.md).

## 7. Conclusiones
El flujo MUSEMS quedó documentado con suficiente granularidad para operar y auditar el proceso. Los puntos de control identificados permiten detener la carga ante anomalías y facilitan la toma de decisiones. Este entregable se enlaza directamente con los posteriores (planes de prueba, validaciones, scripts y evidencias) para mantener coherencia de punta a punta.
