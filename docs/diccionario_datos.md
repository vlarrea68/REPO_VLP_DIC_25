# Diccionario de Datos - Base de Datos Central SEP-MUSES

## 1. Introducción

Este documento proporciona un diccionario de datos detallado para la base de datos central `sep_muses`, esquema `muses_dev`. El diccionario se ha generado a partir del DDL (`ddl_sep_muses_v01.sql`) y sirve como una referencia técnica para todas las entidades de datos del sistema.

Cada tabla se presenta con una lista de sus columnas, incluyendo el nombre de la columna, su tipo de dato, si es una clave primaria (PK) o foránea (FK), y una descripción funcional.

El diccionario está organizado en las siguientes secciones:
- **Tablas de Staging (`tbae*`)**: Reciben los datos crudos de los eventos de interoperabilidad.
- **Tablas del Modelo Núcleo (`tbmu*`)**: Conforman el modelo de datos central, procesado y validado.
- **Tablas de Catálogo (`ctmu*`)**: Contienen datos de referencia y valores estandarizados.

---

## 2. Tablas de Staging (`tbae*`)

Estas tablas actúan como un área de preparación (staging) dentro de la base de datos consolidada. Reciben los datos desnormalizados directamente de las cargas masivas o de las APIs, antes de ser transformados y movidos a las tablas del modelo núcleo (`tbmu*`).

---

### **tbae001_inscripcion**
Tabla de staging para los eventos de inscripción.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `uuid` | `varchar(36)` | PK | Pk de Sincronización para inscripción |
| `id_operacion_origen` | `varchar(50)` | | ID de la transacción en el sistema de origen |
| `id_subsistema` | `integer` | FK | Clave del subsistema del alumno |
| `matricula_alumno` | `varchar(50)` | | Identificador único del alumno en el subsistema |
| `cct` | `varchar(10)` | | Clave Única del Centro de Trabajo (escuela) del Alumno |
| `curp_actual` | `varchar(18)` | | CURP del alumno |
| `id_estatus_procesamiento` | `integer` | FK | Clave de estatus del procesamiento |

---

### **tbae002_bajas**
Tabla de staging para los eventos de baja.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `uuid` | `varchar(36)` | PK | Pk de Sincronización para bajas |
| `id_operacion_origen` | `varchar(50)` | | ID de la transacción en el sistema de origen |
| `id_subsistema` | `integer` | FK | Clave del subsistema del alumno |
| `matricula_alumno` | `varchar(50)` | | Identificador único del alumno en el subsistema |
| `curp` | `varchar(18)` | | CURP del alumno |
| `id_estatus_procesamiento` | `integer` | FK | Clave de estatus del procesamiento |

---

### **tbae009_respuesta**
Registra la respuesta general a una transacción procesada desde las tablas de staging.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_respuesta` | `integer` | PK | ID único de la respuesta |
| `uuid` | `varchar(36)` | FK | UUID de la transacción en la tabla de staging correspondiente |
| `id_estatus_procesamiento` | `integer` | FK | Estado final del procesamiento |
| `fecha_respuesta` | `timestamp(6)` | | Fecha en que se generó la respuesta |

---

### **tbae010_error**
Registra los errores específicos encontrados durante la validación de una transacción.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_error` | `integer` | PK | ID único del error |
| `id_respuesta` | `integer` | FK | FK a `tbae009_respuesta` |
| `id_motivo_error` | `integer` | FK | FK a `ctmu008_motivo_error` |

---

## 3. Tablas de Catálogo (`ctmu*`)

Estas tablas contienen información descriptiva y de clasificación que es utilizada a través de todo el sistema para asegurar la consistencia de los datos.

---

### **ctmu001_tipo_periodo**
Catálogo para los tipos de periodo escolar (semestral, anual, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_periodo` | `integer` | PK | pk del tipo de periodo |
| `descricion` | `varchar(150)` | | Descripción del tipo de periodo |
| `activo` | `char(1)` | | Indica si está activo el tipo_periodo |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el tipo_periodo |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el tipo_periodo |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el tipo_periodo |

---

### **ctmu002_tipo_telefono**
Catálogo para los tipos de teléfono (casa, móvil, trabajo).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_telefono` | `integer` | PK | Pk del tipo de teléfono |
| `descripcion` | `varchar(150)` | | Descripción del tipo de teléfono |
| `activo` | `char(1)` | | Indica si está activo el tipo_telefono |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el tipo_telefono |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el tipo_telefono |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el tipo_telefono |

---

### **ctmu003_sexo**
Catálogo para el sexo de las personas.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_sexo` | `integer` | PK | Pk del sexo |
| `descripcion` | `varchar(20)` | | Descripción del sexo |
| `clave` | `varchar(1)` | | Clave del sexo |
| `activo` | `char(1)` | | Indica si está activo el registro de sexo |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de sexo |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de sexo |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de sexo |

---

### **ctmu004_discapacidad**
Catálogo para los tipos de discapacidad.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_discapacidad` | `integer` | PK | Pk de la discapacidad |
| `descripcion` | `varchar(150)` | | Descripción de la discapacidad |
| `clave` | `varchar(10)` | | Clave de la discapacidad |
| `activo` | `char(1)` | | Indica si está activo el registro de la discapacidad |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la discapacidad |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la discapacidad |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la discapacidad |

---

### **ctmu006_estado_civil**
Catálogo para el estado civil de las personas.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_estado_civil` | `integer` | PK | Pk del estado civil |
| `descripcion` | `varchar(20)` | | Descripción del estado civil |
| `activo` | `char(1)` | | Indica si está activo el registro del estado_civil |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del estado_civil |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del estado_civil |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del estado_civil |

---

### **ctmu007_tipo_correo**
Catálogo para los tipos de correo electrónico (personal, académico).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_correo` | `integer` | PK | Pk del tipo de correo electrónico |
| `descripcion` | `varchar(150)` | | Descripción del tipo de correo electrónico |
| `activo` | `char(1)` | | Indica si está activo el registro del tipo_correo |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del tipo_correo |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del tipo_correo |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del tipo_correo |

---

### **ctmu009_subsistema**
Catálogo de los subsistemas de Educación Media Superior.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_subsistema` | `integer` | PK | Pk del subsistema de Educación Media Superior |
| `descripcion` | `varchar(150)` | | Descripción del subsistema |
| `id_tipo_subsistema` | `integer` | FK | fk del tipo de subsistema |
| `activo` | `char(1)` | | Indica si está activo el registro del subsistema |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del subsistema |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del subsistema |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del subsistema |

---

### **ctmu010_tipo_subsistema**
Catálogo que clasifica los subsistemas.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_subsistema` | `integer` | PK | Pk del tipo de subsistema |
| `descripcion` | `varchar(150)` | | Descripción del tipo de subsistema |
| `activo` | `char(1)` | | Indica si está activo el registro del tipo_subsistema |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del tipo_subsistema |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del tipo_subsistema |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del tipo_subsistema |

---

### **ctmu013_entidad_federativa**
Catálogo de entidades federativas, basado en INEGI.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_entidad_federativa` | `integer` | PK | Pk de la entidad federativa |
| `id_pais` | `integer` | FK | |
| `descripcion` | `varchar(150)` | | Descripción de la entidad federativa |
| `abreviatura` | `varchar(10)` | | Abreviatura de la entidad federativa |
| `clave` | `varchar(10)` | | Clave de la entidad federativa |
| `activo` | `char(1)` | | Indica si está activo el registro de la entidad_federativa |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la entidad_federativa |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la entidad_federativa |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la entidad_federativa |

---

### **ctmu014_estatus_inscripcion**
Catálogo para el estatus de una inscripción (Preinscripción, Reinscripción, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_estatus_inscripcion` | `integer` | PK | Pk del estatus de inscripción |
| `descripcion` | `varchar(150)` | | Descripción del estatus de inscripción |
| `activo` | `char(1)` | | Indica si está activo el registro del estatus_inscripcion |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del estatus_inscripcion |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del estatus_inscripcion |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del estatus_inscripcion |

---

### **ctmu015_localidad**
Catálogo de localidades, basado en INEGI.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_localidad` | `integer` | PK | Pk de la localidad |
| `id_municipio` | `integer` | FK | Fk del municipio correspondiente a la localidad. |
| `descripcion` | `varchar(150)` | | Descipción de la localidad |
| `abreviatura` | `varchar(10)` | | Abreviatura de la localidad |
| `clave` | `varchar(10)` | | Clave de la localidad |
| `activo` | `char(1)` | | Indica si está activo el registro de la localidad |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la localidad |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la localidad |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la localidad |

---

### **ctmu016_municipio**
Catálogo de municipios, basado en INEGI.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_municipio` | `integer` | PK | Pk del municipio |
| `id_entidad_federativa` | `integer` | FK | fk de la entidad correspondiente al municipio |
| `descripcion` | `varchar(150)` | | Descripción del municipio o alcaldía. |
| `abreviatura` | `varchar(10)` | | Descripción del municipio o alcaldía |
| `clave` | `varchar(10)` | | Descripción del municipio o alcaldía |
| `activo` | `char(1)` | | Indica si está activo el registro del municipio o alcaldía |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del municipio o alcaldía |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del municipio o alcaldía |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del municipio o alcaldía |

---

### **ctmu017_pais**
Catálogo de países, basado en INEGI.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_pais` | `integer` | PK | Pk del País |
| `clave` | `varchar(3)` | | Clave del país |
| `descripcion` | `varchar(200)` | | Descripción del país. |
| `abreviatura` | `varchar(3)` | | Abreviatura del país |
| `activo` | `char(1)` | | Indica si está activo el registro del País |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del País |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del País |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del País |

---

### **ctmu019_motivos_baja**
Catálogo de los motivos por los cuales un alumno puede ser dado de baja.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_motivo_baja` | `integer` | PK | Pk del motivo de baja |
| `descripcion` | `varchar(150)` | | Descripción del motivo de baja |
| `activo` | `char(1)` | | Indica si está activo el registro del motivos_baja |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del motivos_baja |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del motivos_baja |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del motivos_baja |

---

### **ctmu022_ciclo_escolar**
Catálogo de los ciclos escolares (ej. "2024-2025").

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_ciclo_escolar` | `integer` | PK | Pk del periodo |
| `descripcion` | `varchar(150)` | | Descripción del periodo |
| `activo` | `char(1)` | | Indica si está activo el registro del ciclo_escolar |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del ciclo_escolar |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del ciclo_escolar |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del ciclo_escolar |

---

### **ctmu023_tipo_evaluacion**
Catálogo de los tipos de evaluación (ordinario, extraordinario, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_evaluacion` | `integer` | PK | Pk del tipo de evaluación |
| `descripcion` | `varchar(150)` | | Descripción del tipo de evaluación |
| `activo` | `char(1)` | | Indica si está activo el registro del tipo_evaluacion |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del tipo_evaluacion |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del tipo_evaluacion |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del tipo_evaluacion |

---

### **ctmu024_parcialidad**
Catálogo para las parcialidades de evaluación.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_parcialidad` | `integer` | PK | Pk de la parcialidad |
| `descripcion` | `varchar(150)` | | Descripción de la parcialidad |
| `activo` | `char(1)` | | Indica si está activo el registro de la parcialidad |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la parcialidad |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la parcialidad |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la parcialidad |

---

### **ctmu025_aptitud_sobresal**
Catálogo de aptitudes sobresalientes.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_aptitud_sobresal` | `integer` | PK | Pk de la aptitud sobresaliente |
| `descripcion` | `varchar(150)` | | Descripción de la aptitud sobresaliente |
| `clave` | `varchar(10)` | | Descripción de la aptitud sobresaliente |
| `activo` | `char(1)` | | Indica si está activo el registro de la aptitud sobresaliente |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la aptitud sobresaliente |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la aptitud sobresaliente |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la aptitud sobresaliente |

---

### **ctmu026_idioma_lengua**
Catálogo de idiomas y lenguas indígenas.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_idioma_lengua` | `integer` | PK | Pk del idioma_lengua |
| `descripcion` | `varchar(150)` | | Descripcion del idioma_lengua |
| `clave` | `varchar(10)` | | Clave del idioma_lengua |
| `idioma_lengua` | `varchar(1)` | | Nombre del idioma_lengua |
| `activo` | `char(1)` | | Indica si está activo el registro del idioma_lengua |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del idioma_lengua |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del idioma_lengua |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del idioma_lengua |

---

### **ctmu027_origen_estudios**
Catálogo para el origen de los estudios previos (nacional, extranjero).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_origen_estudios` | `integer` | PK | Pk del origen_estudios |
| `descripcion` | `varchar(50)` | | Descripcion del origen_estudios |
| `activo` | `char(1)` | | Indica si está activo el registro del origen_estudios |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del origen_estudios |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del origen_estudios |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del origen_estudios |

---

### **ctmu028_tipo_documento**
Catálogo de tipos de documento (certificado, acta, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_documento` | `integer` | PK | PK del tipo_documento |
| `descripcion` | `varchar(50)` | | Descripcion del tipo_documento |
| `clave` | `varchar(3)` | | Clave del tipo_documento |
| `formato` | `varchar(20)` | | Formato del tipo_documento |
| `activo` | `char(1)` | | Indica si está activo el registro del tipo_documento |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del tipo_documento |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del tipo_documento |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del tipo_documento |

---

### **ctmu029_grado**
Catálogo de los grados escolares.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_grado` | `integer` | PK | PK del grado|
| `descripcion` | `varchar(90)` | | Descripcion del grado |
| `clave` | `varchar(10)` | | Clave del grado |
| `activo` | `char(1)` | | Indica si está activo el registro del grado |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del grado |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del grado |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del grado |

---

### **ctmu030_modalidad_educativa**
Catálogo de modalidades educativas (escolarizada, no escolarizada).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_modalidad_educativa` | `integer` | PK | PK de la modalidad_educativa |
| `descripcion` | `varchar(50)` | | Descripcion de la modalidad_educativa |
| `activo` | `char(1)` | | Indica si está activo el registro de la modalidad_educativa |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la modalidad_educativa |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la modalidad_educativa |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la modalidad_educativa |

---

### **ctmu030_opcion_educativa**
Catálogo de opciones educativas (presencial, en línea, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_opcion_educativa` | `integer` | PK | PK de la opcion_educativa |
| `id_modalidad_educativa` | `integer` | FK | FK con la modalidad_educativa |
| `descripcion` | `varchar(50)` | | Descripcion de la opcion_educativa |
| `activo` | `char(1)` | | Indica si está activo el registro de la opcion_educativa |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro de la opcion_educativa |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro de la opcion_educativa |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro de la opcion_educativa |

---

### **ctmu031_turno**
Catálogo de turnos (matutino, vespertino, etc.).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_turno` | `integer` | PK | PK del turno |
| `descripcion` | `varchar(150)` | | Descripcion del turno |
| `activo` | `char(1)` | | Indica si está activo el registro del turno |
| `fcreacion` | `timestamp(6)` | | Fecha en que se generó el registro del turno |
| `fmodificacion` | `timestamp(6)` | | Fecha en que se modificó el registro del turno |
| `fbaja` | `timestamp(6)` | | Fecha en que se dio de baja el registro del turno |

---

## 4. Tablas del Modelo Núcleo (`tbmu*`)

Estas tablas representan el modelo de datos central, consolidado y validado del sistema SEP-MUSES.

---

### **tbmu002_persona**
Entidad central que representa a un individuo (alumno, docente, tutor).

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_persona` | `integer` | PK | Pk de la persona |
| `id_entidad_federativa_n` | `integer` | FK | fk de la entidad federativa de nacimiento con base al catálogo del inegi |
| `curp` | `varchar(18)` | | CURP de la  persona |
| `segmento_raiz` | `varchar(16)` | | segmento_raiz de la persona |
| `rfc` | `varchar(13)` | | rfc de la persona |
| `nombre` | `varchar(50)` | | nombre de la persona |
| `primer_apellido` | `varchar(50)` | | primer_apellido de la persona|
| `segundo_apellido` | `varchar(50)` | | segundo_apellido de la persona |
| `id_sexo` | `integer` | FK | FK con id_sexo |
| `activo` | `char(1)` | | Indica si está activo el registro de la persona |

---

### **tbmu020_alumno**
Almacena los atributos específicos de una persona que es un alumno.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_alumno` | `integer` | PK, FK | FK a `tbmu002_persona` |
| `tiene_discapacidad` | `char(1)` | | |
| `id_discapacidad` | `integer` | FK | |
| `id_estado_civil` | `integer` | FK | |
| `indigena` | `char(1)` | | |
| `id_lengua_materna` | `integer` | FK | |
| `id_segunda_lengua` | `integer` | FK | |
| `minoria` | `char(1)` | | |
| `afrodescendiente` | `char(1)` | | |
| `beca_academica` | `varchar(150)` | | |
| `beca_deportiva` | `varchar(150)` | | |
| `apoyo_social` | `char(1)` | | |
| `id_aptitud_sobresal` | `integer` | FK | |
| `activo` | `char(1)` | | |

---

### **tbmu016_docente**
Almacena los atributos específicos de una persona que es un docente.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_docente` | `integer` | PK, FK | FK a `tbmu002_persona` |
| `clave_cobro` | `varchar(30)` | | |
| `fecha_inicio` | `timestamp` | | |
| `fecha_fin` | `timestamp` | | |
| `activo` | `char(1)` | | |

---

### **tbmu022_domicilio_persona**
Almacena la información de domicilio de una persona.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_domicilio` | `integer` | PK | |
| `id_persona` | `integer` | FK | |
| `id_localidad` | `integer` | FK | fk de la localidad con base al catálogo del inegi |
| `domicilio` | `varchar(100)` | | Calle, numero exterior y número interior de la persona |
| `codigo_postal` | `varchar(5)` | | Código postal de la persona |
| `activo` | `char(1)` | | Indica si está activo el registro del domicilio_persona |

---

### **tbmu003_correo**
Almacena los correos electrónicos de una persona.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_correo` | `integer` | PK, FK | fk del tipo de correo |
| `id_persona` | `integer` | PK, FK | fk de la persona asociada |
| `correo` | `varchar(150)` | | Dirección de correo electrónico |
| `activo` | `char(1)` | | Indica si está activo el registro del correo |

---

### **tbmu004_telefono**
Almacena los teléfonos de una persona.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_tipo_telefono` | `integer` | PK, FK | fk del tipo de teléfono |
| `id_persona` | `integer` | PK, FK | fk de la persona asociada |
| `telefono` | `varchar(20)` | | Número telefónico |
| `activo` | `char(1)` | | Indica si está activo el registro del telefono |

---

### **tbmu005_curp_historica**
Histórico de CURPs de una persona.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_curp_historica` | `integer` | PK | Pk de curp histórica |
| `id_persona` | `integer` | PK, FK | fk de la persona asociada |
| `curp` | `varchar(18)` | | curp histórica (antecedente) |
| `activo` | `char(1)` | | Indica si está activo el registro de la curp_historica |

---

### **tbmu014_rfc_historico**
Histórico de RFCs de una persona.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_rfc_historico` | `integer` | PK | |
| `id_persona` | `integer` | FK | |
| `rfc` | `varchar(13)` | | |
| `activo` | `char(1)` | | |

---

### **tbmu008_institucion_academica**
Entidad que representa a una institución académica.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_institucion` | `integer` | PK | Pk de la institución |
| `nombre_institucion` | `varchar(250)` | | Nombre de la institución académica |
| `activo` | `char(1)` | | Indica si está activo el registro de la institucion_academica |

---

### **tbmu007_programa_academico**
Entidad que representa un programa o plan de estudios.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_programa_academico` | `integer` | PK | Pk de programas académicos |
| `id_competencia` | `integer` | FK | |
| `id_periodicidad` | `integer` | FK | |
| `cve_programa_academico` | `varchar(150)` | | |
| `descripcion_programa_academico` | `varchar(150)` | | |
| `total_creditos` | `varchar(150)` | | |
| `activo` | `char(1)` | | |

---

### **tbmu011_competencias**
Catálogo de competencias para los programas académicos.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_competencia` | `integer` | PK | |
| `descripcion` | `varchar(150)` | | |
| `activo` | `char(1)` | | |

---

### **tbmu009_programa_institucion**
Tabla de cruce que asocia un programa académico con una institución donde se imparte.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_programa_institucion` | `integer` | PK | Pk de la institución académica |
| `id_programa_academico` | `integer` | FK | Fk del programa académico |
| `id_institucion` | `integer` | FK | Fk de la institución |
| `id_opcion_educativa` | `integer` | FK | Fk de la opcion_educativa |
| `activo` | `char(1)` | | Indica si está activo el registro del programa_institucion |

---

### **tbmu006_inscripcion**
Tabla transaccional que registra la inscripción de un alumno a un programa en una institución.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_inscripcion` | `integer` | PK | Pk de inscripción |
| `id_alumno` | `integer` | FK | fk de la persona asociada (alumno) |
| `id_padre_tutor` | `integer` | | fk de la persona asociada (tutor) |
| `id_programa_institucion` | `integer` | FK | |
| `id_estatus_inscripcion` | `integer` | FK | |
| `id_tipo_periodo` | `integer` | FK | |
| `cct` | `varchar(10)` | | |
| `fecha_inscripcion` | `timestamp(6)` | | |
| `id_origen_estudios` | `integer` | FK | (no aplica, nacionales, extranjeros) |
| `fecha_inicio_ems` | `timestamp` | | Fecha de inicio de estudios de Educación Media Superior dd/mm/aaaa |
| `id_tipo_documento` | `integer` | FK | Descripción del tipo de documento de procedencia conforme a catálogo |
| `folio_certificado` | `varchar(150)` | | Folio del certificado de procedencia (antecedente) |
| `cct_procedencia` | `varchar(10)` | | Clave Única del Centro de Trabajo de procedencia (antecedente) |
| `promedio_certificado` | `varchar(150)` | | Promedio del certificado de procedencia (antecedente) |
| `situacion_academica` | `varchar(150)` | | (regular, irregular) |
| `miembro_grupo_escolar` | `varchar(150)` | | (si / no) |
| `id_ciclo_escolar` | `integer` | FK | Ciclo escolar. Ejemplo: 2024-2025 |
| `id_grado` | `integer` | FK | Descripción del grado a cursar conforme a catálogo |
| `id_turno` | `integer` | FK | Descripción del turno conforme a catálogo. |
| `promedio_acumulado_ems` | `varchar(150)` | | Promedio acumulado en ems al momento de la inscripción |
| `creditos_acumulados_ems` | `varchar(150)` | | Créditos acumulado en ems al momento de la inscripción |
| `id_subsistema` | `integer` | FK | |
| `activo` | `char(1)` | | |
| `notificado_siged` | `boolean` | | Indica si el registro ya fue notificado a SIGED |

---

### **tbmu013_bajas**
Tabla transaccional que registra la baja de un alumno.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_baja` | `integer` | PK | Pk de Bajas |
| `id_persona` | `integer` | FK | |
| `id_motivo_baja` | `integer` | FK | |
| `id_subsistema` | `integer` | FK | |
| `id_programa_institucion` | `integer` | FK | |
| `tipo_baja` | `varchar(50)` | | |
| `fecha_baja` | `timestamp(6)` | | |
| `cct` | `varchar(20)` | | |
| `activo` | `char(1)` | | |
| `notificado_siged` | `boolean` | | Indica si el registro ya fue notificado a SIGED |

---

### **tbmu010_asignaturas**
Entidad que representa una asignatura o materia.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_asignatura` | `integer` | PK | |
| `cve_asignatura` | `varchar(150)` | | |
| `nombre_asignatura` | `varchar(150)` | | |
| `activo` | `char(1)` | | |

---

### **tbmu012_programa_asignatura**
Tabla de cruce que asocia una asignatura a un programa académico, definiendo horas y créditos.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_programa_asignatura` | `integer` | PK | |
| `id_programa_academico` | `integer` | FK | |
| `id_asignatura` | `integer` | FK | |
| `horas` | `varchar(150)` | | Indica el número total de horas de la asignatura para el programa académico asociado |
| `creditos` | `varchar(150)` | | Indica el número total de créditos de la asignatura para el programa académico asociado |
| `obligatoria` | `char(1)` | | Indica si la asignatura es obligatoria |
| `activo` | `char(1)` | | Indica si está activo el registro del programa_asignatura |

---

### **tbmu019_calificaciones**
Tabla transaccional que registra las calificaciones de un alumno en una asignatura.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_calificacion` | `integer` | PK | pk de calificación |
| `id_alumno` | `integer` | FK | fk de la persona asociada |
| `id_programa_asignatura` | `integer` | FK | |
| `id_ciclo_escolar` | `integer` | FK | |
| `id_parcialidad` | `integer` | FK | |
| `id_tipo_evaluacion` | `integer` | FK | |
| `calificacion_original` | `varchar(20)` | | |
| `calificacion_homologada` | `integer` | | |
| `ponderacion` | `varchar(20)` | | |
| `fecha_calificacion` | `timestamp` | | |
| `activo` | `char(1)` | | |

---

### **tbmu018_asistencias**
Tabla transaccional que registra la asistencia de una persona a una asignatura.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_asistencia` | `integer` | PK | pk de asistencia |
| `id_persona` | `integer` | FK | |
| `id_programa_asignatura` | `integer` | FK | |
| `fecha_asistencia` | `timestamp` | | |
| `activo` | `char(1)` | | |

---

### **tbmu015_docente_asignatura**
Tabla de cruce que asigna un docente a una asignatura para un ciclo escolar específico.

| Nombre de la Columna | Tipo de Dato | PK/FK | Descripción |
|---|---|---|---|
| `id_docente_asignatura` | `integer` | PK | |
| `id_docente` | `integer` | FK | fk de la persona docente |
| `id_programa_institucion` | `integer` | FK | |
| `id_programa_asignatura` | `integer` | FK | |
| `id_ciclo_escolar` | `integer` | FK | |
| `fecha_asignacion` | `timestamp(6)` | | Fecha en la que el docente se asigno a la materia |
| `activo` | `char(1)` | | |