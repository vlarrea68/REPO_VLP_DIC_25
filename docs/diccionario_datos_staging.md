# Diccionario de Datos del Área de Staging (TBAE)

## 1. Introducción

Este documento proporciona una descripción detallada y exhaustiva de las tablas y columnas que componen el **área de staging** del esquema `sep_muses`. Este conjunto de tablas, prefijadas con `tbae*`, sirve como área de preparación para la información enviada por los subsistemas de educación superior, antes de su validación y consolidación en las tablas núcleo (`tbmu*`) de la Matrícula Única de Educación Superior (MUSES).

---

## 2. Tablas del Área de Staging

A continuación se detalla la estructura y propósito de cada tabla.

### `tbae001_inscripcion_subsis`

Almacena los registros de inscripciones de alumnos enviados por los subsistemas.

| Columna | Tipo de Dato | Nulo | Descripción |
|---|---|---|---|
| `id_inscripcion` | `bigint` (PK) | No | Identificador único del registro de inscripción. |
| `curp` | `varchar(18)` | No | CURP del alumno. |
| ... | ... | ... | *(Otras columnas según el layout de carga)* |

### `tbae002_bajas_subsis`

Almacena los registros de bajas de alumnos enviados por los subsistemas.

| Columna | Tipo de Dato | Nulo | Descripción |
|---|---|---|---|
| `id_baja` | `bigint` (PK) | No | Identificador único del registro de baja. |
| `curp` | `varchar(18)` | No | CURP del alumno. |
| ... | ... | ... | *Otras columnas...* |

### `tbae009_respuesta_subsis`

Registra el estado de procesamiento de cada operación recibida (inscripción o baja).

| Columna | Tipo de Dato | Nulo | Descripción |
|---|---|---|---|
| `id_respuesta` | `bigint` (PK) | No | Identificador único de la respuesta. |
| `id_operacion_origen` | `varchar` | No | ID polimórfico que apunta a `tbae001` o `tbae002`. |
| `tipo_operacion` | `varchar` | No | Indica si la operación fue 'INSCRIPCION' o 'BAJA'. |
| `estatus_procesamiento` | `varchar` | No | Estado actual del registro (ej. 'RECIBIDO', 'VALIDADO', 'ERROR'). |

### `tbae010_error_subsis`

Almacena los detalles de los errores de validación encontrados durante el procesamiento.

| Columna | Tipo de Dato | Nulo | Descripción |
|---|---|---|---|
| `id_error` | `bigint` (PK) | No | Identificador único del error. |
| `id_respuesta` | `bigint` (FK) | No | Referencia a `tbae009_respuesta_subsis`. |
| `codigo_error` | `varchar` | No | Código del error de validación. |
| `mensaje_error` | `text` | No | Descripción detallada del error. |
