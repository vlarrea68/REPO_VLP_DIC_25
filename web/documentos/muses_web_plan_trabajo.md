# Plan de trabajo Scrum para el front-end Angular de MUSES

## 1. Marco metodológico
... (Contenido sin cambios) ...

## 5. Product Backlog inicial
| ID | Épica | Historia / PBI | Criterios de aceptación clave |
| --- | --- | --- | --- |
| PBI-02 | Inscripciones | Como capturista, quiero registrar una inscripción manual validando catálogos y reglas para obtener un acuse exitoso.【F:bd/layout_V01.md†L1-L58】 | Validación de campos obligatorios, generación de folio, mensajes de error contextualizados. |
| PBI-03 | Inscripciones | Como capturista, deseo cargar inscripciones masivas mediante CSV y descargar reporte de errores. | **Entregado parcialmente**: validación de encabezados, barra de progreso, tabla filtrable, persistencia local y detalle por registro. Pendiente: integración con back-end y reporte descargable. |
| PBI-04 | Bajas | Como responsable académico, quiero reportar una baja con motivo y evidencia para mantener la trazabilidad. | Formulario condicional, acuse con sello de tiempo. |
| PBI-05 | Evaluaciones | Como docente, necesito capturar calificaciones por periodo y enviar al SIGED sin errores de estructura.【F:docs/diagnostico_siged.md†L41-L68】 | Validación de periodos, confirmación de envío. |
| PBI-06 | Certificación | Como área de control escolar, requiero emitir certificados digitales con UUID y seguimiento de estatus.【F:docs/casos_de_uso_siged.md†L16-L33】 | Validar duplicidad de folios, descarga del certificado. |
| PBI-08 | Auditoría | Como auditor, necesito consultar bitácoras de operaciones para validar cumplimiento normativo. | Filtros por fecha, exportación CSV. |

## 6. Plan de sprints

### Sprint 0 (Setup - 2 semanas)
... (Contenido sin cambios) ...
### Sprint 1
... (Contenido sin cambios) ...
### Sprint 2
... (Contenido sin cambios) ...
### Sprint 3
- Historias: PBI-04, PBI-05.
- QA: pruebas de regresión sobre inscripciones, pruebas funcionales de bajas/evaluaciones.
- DoD: bajas con acuse, evaluaciones con sincronización por periodo.

### Sprint 4
- Historias: PBI-06, PBI-08.
- QA: validación de certificados digitales, auditoría de bitácoras.
- DoD: módulo de certificación con seguimiento, visor de bitácoras de auditoría.

### Sprint 5 (Endurecimiento)
... (Contenido sin cambios) ...

## 7. Gestión de riesgos y mitigaciones
... (Contenido sin cambios) ...
