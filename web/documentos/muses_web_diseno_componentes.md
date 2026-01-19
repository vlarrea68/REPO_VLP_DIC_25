# Diseño de componentes Angular para MUSES

## 1. Lineamientos generales
- **Convenciones**: componentes _standalone_ con prefijo `muses-` y estilo BEM para clases CSS. Las vistas recientes de carga masiva utilizan clases específicas (`carga-masiva__*`) ya aplanadas para garantizar compatibilidad entre entornos.
- **Reutilización**: formularios, tablas y asistentes de carga se construyen a partir de componentes básicos (`muses-form-field`, `muses-select-cat`, `muses-error-panel`) y utilidades compartidas (pipes de progreso, badges, modal accesible).
- **Accesibilidad**: uso de roles ARIA, navegación con teclado y mensajes de validación legibles. Los nuevos botones de acción incluyen iconos SVG acompañados de textos descriptivos y `aria-label`.
- **Internacionalización**: `@ngx-translate/core` para soportar traducciones a futuro; los textos actuales se agrupan en archivos de constantes para facilitar la migración.
- **Estado reactivo**: Angular signals encapsulan progreso, filtros y banderas de UI; los componentes exponen _inputs_ mínimos y delegan la sincronización al servicio correspondiente.
- **Mapa visual**: el diagrama de componentes en la **[Arquitectura Detallada del Frontend](../../docs/arquitectura_detallada_frontend.md)** (sección 3) muestra cómo se relacionan los módulos y servicios descritos en este documento.

## 2. Catálogo de componentes transversales
| Componente | Propósito | Inputs | Outputs | Notas |
| --- | --- | --- | --- | --- |
| `muses-form-field` | Encapsula `FormControl` con label, hint y mensaje de error. | `control`, `labelKey`, `hintKey`, `mask`. | `focus`, `blur`. | Integrar máscaras basadas en layout (CURP, fechas).【F:bd/layout_V01.md†L8-L12】【F:bd/layout_V01.md†L45-L55】 |
| `muses-select-cat` | Selector conectado a catálogos (países, entidades, carreras). | `catalogo`, `placeholderKey`, `multiple`. | `selectionChange`. | Consume `CatalogoService` y cache local. |
| `muses-error-panel` | Lista validaciones fallidas por campo/fila. | `errores` (array). | `goTo(field)`. | Compatible con carga masiva. |
| `muses-stepper` | Flujo multi-paso para asistentes (importación CSV, certificación). | `steps`, `currentStep`. | `stepChange`. | Basado en Angular Material `mat-stepper`. |
| `muses-upload` | Subida de archivos CSV/ZIP con validación de estructura. | `accept`, `maxSize`, `processType`. | `fileSelected`, `clear`. | Usa web workers y expone metadatos del archivo (nombre, tamaño, filas estimadas). |
| `muses-table` | Tablas con paginación, filtros, exportación. | `columns`, `data`, `actions`. | `action`, `sortChange`. | Integra paginación local, filtros por texto y badges de estado. |
| `muses-modal` | Contenedor accesible para ayudas contextuales. | `title`, `open`, `size`. | `closed`. | Utilizado por el flujo "Antes de comenzar" de carga masiva. |

## 3. Componentes por módulo funcional

### 3.1 Inscripciones
- `inscripcion-form-container`: orquesta formulario, validadores contextuales y barra de progreso; distribuye los 53 campos definidos en el layout conforme a los grupos del diccionario de datos.【F:web/documentos/inscripcion_diccionario_campos.md†L1-L101】
- `inscripcion-datos-personales`: captura flujo, ciclo, datos de identidad, CURP/segmento raíz, contacto y nacionalidad. Usa catálogos de sexo y nacionalidad, y valida máscaras de CURP y fechas de nacimiento.【F:bd/layout_V01.md†L3-L13】
- `inscripcion-domicilio`: gestiona país/entidad de nacimiento y residencia, dirección completa, procedencia y sincronización de catálogos territoriales.【F:bd/layout_V01.md†L14-L31】
- `inscripcion-datos-academicos`: recoge lenguas, necesidades, identificadores institucionales, modalidad/opción educativa, créditos, matrícula y situación académica.【F:bd/layout_V01.md†L32-L51】
- `inscripcion-baja-detalle`: visible solo si el flujo es baja; solicita tipo y motivo según el catálogo oficial y oculta los campos cuando no aplican.【F:bd/layout_V01.md†L3-L3】【F:bd/layout_V01.md†L57-L58】
- `inscripcion-resumen`: muestra payload, reglas cumplidas y genera acuse.
- `inscripcion-importar`: asistente de tres pasos (subir archivo, previsualizar, confirmar). Usa `muses-upload`, `muses-table` y `muses-error-panel`.

### 3.2 Carga masiva de inscripciones
- `carga-masiva`: vista principal con panel descriptivo, botones centrados para ayudas y descarga de plantilla, barra de progreso, filtros, paginación y tabla de resultados.
- `carga-masiva-modal-encabezados`: modal accesible que detalla requisitos de encabezados y recomendaciones previas.
- `carga-masiva-tabla`: tabla con columnas compactas (#, folio, flujo, ciclo escolar, CURP, apellidos, nombre) y acción de lupa accesible.
- `carga-masiva-botones-accion`: wrapper para los botones "Antes de comenzar" y "Descargar plantilla" con iconografía consistente.
- `carga-masiva-detalle`: componente dedicado para visualizar todos los campos del registro seleccionado; recibe datos desde el servicio y se integra con breadcrumbs sencillos.
- `carga-masiva-service`: coordina lectura progresiva, almacenamiento en `localStorage`, filtros, cancelación y mensajes de progreso.
### 3.3 Bajas
- `bajas-form-container`: reutiliza `inscripcion-datos-personales` en modo solo lectura y captura motivo/fecha respetando las reglas del layout para flujo `Baja`.【F:bd/layout_V01.md†L3-L3】【F:bd/layout_V01.md†L57-L58】
- `bajas-confirm-dialog`: confirma operaciones definitivas y solicita evidencia.
- `bajas-historial`: tabla con bajas previas, filtros por motivo y fecha.

### 3.4 Evaluaciones
- `evaluaciones-selector-periodo`: selecciona ciclo, periodo y módulo reutilizando las mismas claves que el layout define para inscripción.【F:bd/layout_V01.md†L42-L45】
- `evaluaciones-captura`: formulario dinámico para calificaciones, permite importación desde plantillas.
- `evaluaciones-rubrica`: configuración de ponderaciones y reglas de acreditación.
- `evaluaciones-bitacora`: historial de envíos y errores devueltos por SIGED.

### 3.5 Certificación
- `certificacion-form`: registra folios, tipo de documento y valida duplicidad.【F:docs/diagnostico_siged.md†L43-L68】
- `certificacion-vista-previa`: renderiza certificado digital (PDF/HTML) antes de emitir.
- `certificacion-tracking`: seguimiento de UUID y sellos de tiempo devueltos por gateway nacional.【F:docs/casos_de_uso_siged.md†L16-L33】

### 3.6 Catálogos
- `catalogos-editar`: formulario genérico para altas/bajas de registros con control de versiones.
- `catalogos-importar`: carga masiva de catálogos, compatibilidad con archivos maestros de la SEP.

### 3.7 Administración
- `usuarios-gestion`: administra roles, API keys y accesos.

## 4. Servicios y utilidades asociadas
- `FormFactoryService`: construye `FormGroup` dinámicos según diccionario de campos y reglas.
- `ValidacionLayoutService`: centraliza reglas del layout y traduce mensajes para UI.【F:web/documentos/inscripcion_reglas_validacion.md†L1-L43】
- `CatalogoService`: obtiene catálogos, maneja versionamiento y caché.
- `CargaMasivaService`: administra lectura progresiva, encabezados requeridos, almacenamiento en `localStorage`, filtros y navegación a detalle.
- `AcusesService`: almacena acuses firmados, permite descarga y reenvío.
- `NotificacionService`: emite toasts, banners y notificaciones asincrónicas.

## 5. Estrategia de pruebas de componentes
- **Pruebas unitarias**: `Jest`/`Karma` para validar componentes y servicios aislados.
- **Pruebas de integración**: Harness de Angular Material y pruebas de formularios completos.
- **Pruebas E2E**: Playwright cubriendo flujos críticos (inscripción manual, carga CSV, emisión de certificado).
- **Accesibilidad**: auditorías automatizadas con `axe-core` para componentes críticos y validación manual de modales y atajos de teclado en carga masiva.

## 6. Guía de actualización
- Mantener un _changelog_ por módulo en `feature/*/CHANGELOG.md`.
- Documentar nuevos componentes o cambios en este archivo añadiendo subsecciones.
- Automatizar la generación de documentación con Storybook y vincularlo a la CI.
