COMMENT ON TABLE muses_dev.tbae001_inscripcion IS 'Tabla de staging para los eventos de inscripción.';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.uuid IS 'Pk de Sincronización para inscripción';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.id_operacion_origen IS 'ID de la transacción en el sistema de origen';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.id_subsistema IS 'Clave del subsistema del alumno';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.matricula_alumno IS 'Identificador único del alumno en el subsistema';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.cct IS 'Clave Única del Centro de Trabajo (escuela) del Alumno';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.curp_actual IS 'CURP del alumno';

COMMENT ON COLUMN muses_dev.tbae001_inscripcion.id_estatus_procesamiento IS 'Clave de estatus del procesamiento';

COMMENT ON TABLE muses_dev.tbae002_bajas IS 'Tabla de staging para los eventos de baja.';

COMMENT ON COLUMN muses_dev.tbae002_bajas.uuid IS 'Pk de Sincronización para bajas';

COMMENT ON COLUMN muses_dev.tbae002_bajas.id_operacion_origen IS 'ID de la transacción en el sistema de origen';

COMMENT ON COLUMN muses_dev.tbae002_bajas.id_subsistema IS 'Clave del subsistema del alumno';

COMMENT ON COLUMN muses_dev.tbae002_bajas.matricula_alumno IS 'Identificador único del alumno en el subsistema';

COMMENT ON COLUMN muses_dev.tbae002_bajas.curp IS 'CURP del alumno';

COMMENT ON COLUMN muses_dev.tbae002_bajas.id_estatus_procesamiento IS 'Clave de estatus del procesamiento';

COMMENT ON TABLE muses_dev.tbae009_respuesta IS 'Registra la respuesta general a una transacción procesada desde las tablas de staging.';

COMMENT ON COLUMN muses_dev.tbae009_respuesta.id_respuesta IS 'ID único de la respuesta';

COMMENT ON COLUMN muses_dev.tbae009_respuesta.uuid IS 'UUID de la transacción en la tabla de staging correspondiente';

COMMENT ON COLUMN muses_dev.tbae009_respuesta.id_estatus_procesamiento IS 'Estado final del procesamiento';

COMMENT ON COLUMN muses_dev.tbae009_respuesta.fecha_respuesta IS 'Fecha en que se generó la respuesta';

COMMENT ON TABLE muses_dev.tbae010_error IS 'Registra los errores específicos encontrados durante la validación de una transacción.';

COMMENT ON COLUMN muses_dev.tbae010_error.id_error IS 'ID único del error';

COMMENT ON COLUMN muses_dev.tbae010_error.id_respuesta IS 'FK a `tbae009_respuesta`';

COMMENT ON COLUMN muses_dev.tbae010_error.id_motivo_error IS 'FK a `ctmu008_motivo_error`';

COMMENT ON TABLE muses_dev.ctmu001_tipo_periodo IS 'Catálogo para los tipos de periodo escolar (semestral, anual, etc.).';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.id_tipo_periodo IS 'pk del tipo de periodo';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.descricion IS 'Descripción del tipo de periodo';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.activo IS 'Indica si está activo el tipo_periodo';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.fcreacion IS 'Fecha en que se generó el tipo_periodo';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.fmodificacion IS 'Fecha en que se modificó el tipo_periodo';

COMMENT ON COLUMN muses_dev.ctmu001_tipo_periodo.fbaja IS 'Fecha en que se dio de baja el tipo_periodo';

COMMENT ON TABLE muses_dev.ctmu002_tipo_telefono IS 'Catálogo para los tipos de teléfono (casa, móvil, trabajo).';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.id_tipo_telefono IS 'Pk del tipo de teléfono';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.descripcion IS 'Descripción del tipo de teléfono';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.activo IS 'Indica si está activo el tipo_telefono';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.fcreacion IS 'Fecha en que se generó el tipo_telefono';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.fmodificacion IS 'Fecha en que se modificó el tipo_telefono';

COMMENT ON COLUMN muses_dev.ctmu002_tipo_telefono.fbaja IS 'Fecha en que se dio de baja el tipo_telefono';

COMMENT ON TABLE muses_dev.ctmu003_sexo IS 'Catálogo para el sexo de las personas.';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.id_sexo IS 'Pk del sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.descripcion IS 'Descripción del sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.clave IS 'Clave del sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.activo IS 'Indica si está activo el registro de sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.fcreacion IS 'Fecha en que se generó el registro de sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.fmodificacion IS 'Fecha en que se modificó el registro de sexo';

COMMENT ON COLUMN muses_dev.ctmu003_sexo.fbaja IS 'Fecha en que se dio de baja el registro de sexo';

COMMENT ON TABLE muses_dev.ctmu004_discapacidad IS 'Catálogo para los tipos de discapacidad.';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.id_discapacidad IS 'Pk de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.descripcion IS 'Descripción de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.clave IS 'Clave de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.activo IS 'Indica si está activo el registro de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.fcreacion IS 'Fecha en que se generó el registro de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.fmodificacion IS 'Fecha en que se modificó el registro de la discapacidad';

COMMENT ON COLUMN muses_dev.ctmu004_discapacidad.fbaja IS 'Fecha en que se dio de baja el registro de la discapacidad';

COMMENT ON TABLE muses_dev.ctmu006_estado_civil IS 'Catálogo para el estado civil de las personas.';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.id_estado_civil IS 'Pk del estado civil';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.descripcion IS 'Descripción del estado civil';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.activo IS 'Indica si está activo el registro del estado_civil';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.fcreacion IS 'Fecha en que se generó el registro del estado_civil';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.fmodificacion IS 'Fecha en que se modificó el registro del estado_civil';

COMMENT ON COLUMN muses_dev.ctmu006_estado_civil.fbaja IS 'Fecha en que se dio de baja el registro del estado_civil';

COMMENT ON TABLE muses_dev.ctmu007_tipo_correo IS 'Catálogo para los tipos de correo electrónico (personal, académico).';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.id_tipo_correo IS 'Pk del tipo de correo electrónico';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.descripcion IS 'Descripción del tipo de correo electrónico';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.activo IS 'Indica si está activo el registro del tipo_correo';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.fcreacion IS 'Fecha en que se generó el registro del tipo_correo';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.fmodificacion IS 'Fecha en que se modificó el registro del tipo_correo';

COMMENT ON COLUMN muses_dev.ctmu007_tipo_correo.fbaja IS 'Fecha en que se dio de baja el registro del tipo_correo';

COMMENT ON TABLE muses_dev.ctmu009_subsistema IS 'Catálogo de los subsistemas de Educación Media Superior.';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.id_subsistema IS 'Pk del subsistema de Educación Media Superior';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.descripcion IS 'Descripción del subsistema';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.id_tipo_subsistema IS 'fk del tipo de subsistema';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.activo IS 'Indica si está activo el registro del subsistema';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.fcreacion IS 'Fecha en que se generó el registro del subsistema';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.fmodificacion IS 'Fecha en que se modificó el registro del subsistema';

COMMENT ON COLUMN muses_dev.ctmu009_subsistema.fbaja IS 'Fecha en que se dio de baja el registro del subsistema';

COMMENT ON TABLE muses_dev.ctmu010_tipo_subsistema IS 'Catálogo que clasifica los subsistemas.';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.id_tipo_subsistema IS 'Pk del tipo de subsistema';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.descripcion IS 'Descripción del tipo de subsistema';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.activo IS 'Indica si está activo el registro del tipo_subsistema';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.fcreacion IS 'Fecha en que se generó el registro del tipo_subsistema';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.fmodificacion IS 'Fecha en que se modificó el registro del tipo_subsistema';

COMMENT ON COLUMN muses_dev.ctmu010_tipo_subsistema.fbaja IS 'Fecha en que se dio de baja el registro del tipo_subsistema';

COMMENT ON TABLE muses_dev.ctmu013_entidad_federativa IS 'Catálogo de entidades federativas, basado en INEGI.';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.id_entidad_federativa IS 'Pk de la entidad federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.descripcion IS 'Descripción de la entidad federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.abreviatura IS 'Abreviatura de la entidad federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.clave IS 'Clave de la entidad federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.activo IS 'Indica si está activo el registro de la entidad_federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.fcreacion IS 'Fecha en que se generó el registro de la entidad_federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.fmodificacion IS 'Fecha en que se modificó el registro de la entidad_federativa';

COMMENT ON COLUMN muses_dev.ctmu013_entidad_federativa.fbaja IS 'Fecha en que se dio de baja el registro de la entidad_federativa';

COMMENT ON TABLE muses_dev.ctmu014_estatus_inscripcion IS 'Catálogo para el estatus de una inscripción (Preinscripción, Reinscripción, etc.).';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.id_estatus_inscripcion IS 'Pk del estatus de inscripción';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.descripcion IS 'Descripción del estatus de inscripción';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.activo IS 'Indica si está activo el registro del estatus_inscripcion';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.fcreacion IS 'Fecha en que se generó el registro del estatus_inscripcion';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.fmodificacion IS 'Fecha en que se modificó el registro del estatus_inscripcion';

COMMENT ON COLUMN muses_dev.ctmu014_estatus_inscripcion.fbaja IS 'Fecha en que se dio de baja el registro del estatus_inscripcion';

COMMENT ON TABLE muses_dev.ctmu015_localidad IS 'Catálogo de localidades, basado en INEGI.';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.id_localidad IS 'Pk de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.id_municipio IS 'Fk del municipio correspondiente a la localidad.';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.descripcion IS 'Descipción de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.abreviatura IS 'Abreviatura de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.clave IS 'Clave de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.activo IS 'Indica si está activo el registro de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.fcreacion IS 'Fecha en que se generó el registro de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.fmodificacion IS 'Fecha en que se modificó el registro de la localidad';

COMMENT ON COLUMN muses_dev.ctmu015_localidad.fbaja IS 'Fecha en que se dio de baja el registro de la localidad';

COMMENT ON TABLE muses_dev.ctmu016_municipio IS 'Catálogo de municipios, basado en INEGI.';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.id_municipio IS 'Pk del municipio';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.id_entidad_federativa IS 'fk de la entidad correspondiente al municipio';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.descripcion IS 'Descripción del municipio o alcaldía.';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.abreviatura IS 'Descripción del municipio o alcaldía';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.clave IS 'Descripción del municipio o alcaldía';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.activo IS 'Indica si está activo el registro del municipio o alcaldía';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.fcreacion IS 'Fecha en que se generó el registro del municipio o alcaldía';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.fmodificacion IS 'Fecha en que se modificó el registro del municipio o alcaldía';

COMMENT ON COLUMN muses_dev.ctmu016_municipio.fbaja IS 'Fecha en que se dio de baja el registro del municipio o alcaldía';

COMMENT ON TABLE muses_dev.ctmu017_pais IS 'Catálogo de países, basado en INEGI.';

COMMENT ON COLUMN muses_dev.ctmu017_pais.id_pais IS 'Pk del País';

COMMENT ON COLUMN muses_dev.ctmu017_pais.clave IS 'Clave del país';

COMMENT ON COLUMN muses_dev.ctmu017_pais.descripcion IS 'Descripción del país.';

COMMENT ON COLUMN muses_dev.ctmu017_pais.abreviatura IS 'Abreviatura del país';

COMMENT ON COLUMN muses_dev.ctmu017_pais.activo IS 'Indica si está activo el registro del País';

COMMENT ON COLUMN muses_dev.ctmu017_pais.fcreacion IS 'Fecha en que se generó el registro del País';

COMMENT ON COLUMN muses_dev.ctmu017_pais.fmodificacion IS 'Fecha en que se modificó el registro del País';

COMMENT ON COLUMN muses_dev.ctmu017_pais.fbaja IS 'Fecha en que se dio de baja el registro del País';

COMMENT ON TABLE muses_dev.ctmu019_motivos_baja IS 'Catálogo de los motivos por los cuales un alumno puede ser dado de baja.';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.id_motivo_baja IS 'Pk del motivo de baja';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.descripcion IS 'Descripción del motivo de baja';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.activo IS 'Indica si está activo el registro del motivos_baja';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.fcreacion IS 'Fecha en que se generó el registro del motivos_baja';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.fmodificacion IS 'Fecha en que se modificó el registro del motivos_baja';

COMMENT ON COLUMN muses_dev.ctmu019_motivos_baja.fbaja IS 'Fecha en que se dio de baja el registro del motivos_baja';

COMMENT ON TABLE muses_dev.ctmu022_ciclo_escolar IS 'Catálogo de los ciclos escolares (ej. "2024-2025").';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.id_ciclo_escolar IS 'Pk del periodo';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.descripcion IS 'Descripción del periodo';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.activo IS 'Indica si está activo el registro del ciclo_escolar';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.fcreacion IS 'Fecha en que se generó el registro del ciclo_escolar';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.fmodificacion IS 'Fecha en que se modificó el registro del ciclo_escolar';

COMMENT ON COLUMN muses_dev.ctmu022_ciclo_escolar.fbaja IS 'Fecha en que se dio de baja el registro del ciclo_escolar';

COMMENT ON TABLE muses_dev.ctmu023_tipo_evaluacion IS 'Catálogo de los tipos de evaluación (ordinario, extraordinario, etc.).';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.id_tipo_evaluacion IS 'Pk del tipo de evaluación';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.descripcion IS 'Descripción del tipo de evaluación';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.activo IS 'Indica si está activo el registro del tipo_evaluacion';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.fcreacion IS 'Fecha en que se generó el registro del tipo_evaluacion';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.fmodificacion IS 'Fecha en que se modificó el registro del tipo_evaluacion';

COMMENT ON COLUMN muses_dev.ctmu023_tipo_evaluacion.fbaja IS 'Fecha en que se dio de baja el registro del tipo_evaluacion';

COMMENT ON TABLE muses_dev.ctmu024_parcialidad IS 'Catálogo para las parcialidades de evaluación.';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.id_parcialidad IS 'Pk de la parcialidad';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.descripcion IS 'Descripción de la parcialidad';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.activo IS 'Indica si está activo el registro de la parcialidad';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.fcreacion IS 'Fecha en que se generó el registro de la parcialidad';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.fmodificacion IS 'Fecha en que se modificó el registro de la parcialidad';

COMMENT ON COLUMN muses_dev.ctmu024_parcialidad.fbaja IS 'Fecha en que se dio de baja el registro de la parcialidad';

COMMENT ON TABLE muses_dev.ctmu025_aptitud_sobresal IS 'Catálogo de aptitudes sobresalientes.';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.id_aptitud_sobresal IS 'Pk de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.descripcion IS 'Descripción de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.clave IS 'Descripción de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.activo IS 'Indica si está activo el registro de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.fcreacion IS 'Fecha en que se generó el registro de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.fmodificacion IS 'Fecha en que se modificó el registro de la aptitud sobresaliente';

COMMENT ON COLUMN muses_dev.ctmu025_aptitud_sobresal.fbaja IS 'Fecha en que se dio de baja el registro de la aptitud sobresaliente';

COMMENT ON TABLE muses_dev.ctmu026_idioma_lengua IS 'Catálogo de idiomas y lenguas indígenas.';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.id_idioma_lengua IS 'Pk del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.descripcion IS 'Descripcion del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.clave IS 'Clave del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.idioma_lengua IS 'Nombre del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.activo IS 'Indica si está activo el registro del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.fcreacion IS 'Fecha en que se generó el registro del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.fmodificacion IS 'Fecha en que se modificó el registro del idioma_lengua';

COMMENT ON COLUMN muses_dev.ctmu026_idioma_lengua.fbaja IS 'Fecha en que se dio de baja el registro del idioma_lengua';

COMMENT ON TABLE muses_dev.ctmu027_origen_estudios IS 'Catálogo para el origen de los estudios previos (nacional, extranjero).';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.id_origen_estudios IS 'Pk del origen_estudios';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.descripcion IS 'Descripcion del origen_estudios';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.activo IS 'Indica si está activo el registro del origen_estudios';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.fcreacion IS 'Fecha en que se generó el registro del origen_estudios';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.fmodificacion IS 'Fecha en que se modificó el registro del origen_estudios';

COMMENT ON COLUMN muses_dev.ctmu027_origen_estudios.fbaja IS 'Fecha en que se dio de baja el registro del origen_estudios';

COMMENT ON TABLE muses_dev.ctmu028_tipo_documento IS 'Catálogo de tipos de documento (certificado, acta, etc.).';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.id_tipo_documento IS 'PK del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.descripcion IS 'Descripcion del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.clave IS 'Clave del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.formato IS 'Formato del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.activo IS 'Indica si está activo el registro del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.fcreacion IS 'Fecha en que se generó el registro del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.fmodificacion IS 'Fecha en que se modificó el registro del tipo_documento';

COMMENT ON COLUMN muses_dev.ctmu028_tipo_documento.fbaja IS 'Fecha en que se dio de baja el registro del tipo_documento';

COMMENT ON TABLE muses_dev.ctmu029_grado IS 'Catálogo de los grados escolares.';

COMMENT ON COLUMN muses_dev.ctmu029_grado.id_grado IS 'PK del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.descripcion IS 'Descripcion del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.clave IS 'Clave del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.activo IS 'Indica si está activo el registro del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.fcreacion IS 'Fecha en que se generó el registro del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.fmodificacion IS 'Fecha en que se modificó el registro del grado';

COMMENT ON COLUMN muses_dev.ctmu029_grado.fbaja IS 'Fecha en que se dio de baja el registro del grado';

COMMENT ON TABLE muses_dev.ctmu030_modalidad_educativa IS 'Catálogo de modalidades educativas (escolarizada, no escolarizada).';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.id_modalidad_educativa IS 'PK de la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.descripcion IS 'Descripcion de la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.activo IS 'Indica si está activo el registro de la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.fcreacion IS 'Fecha en que se generó el registro de la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.fmodificacion IS 'Fecha en que se modificó el registro de la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_modalidad_educativa.fbaja IS 'Fecha en que se dio de baja el registro de la modalidad_educativa';

COMMENT ON TABLE muses_dev.ctmu030_opcion_educativa IS 'Catálogo de opciones educativas (presencial, en línea, etc.).';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.id_opcion_educativa IS 'PK de la opcion_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.id_modalidad_educativa IS 'FK con la modalidad_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.descripcion IS 'Descripcion de la opcion_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.activo IS 'Indica si está activo el registro de la opcion_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.fcreacion IS 'Fecha en que se generó el registro de la opcion_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.fmodificacion IS 'Fecha en que se modificó el registro de la opcion_educativa';

COMMENT ON COLUMN muses_dev.ctmu030_opcion_educativa.fbaja IS 'Fecha en que se dio de baja el registro de la opcion_educativa';

COMMENT ON TABLE muses_dev.ctmu031_turno IS 'Catálogo de turnos (matutino, vespertino, etc.).';

COMMENT ON COLUMN muses_dev.ctmu031_turno.id_turno IS 'PK del turno';

COMMENT ON COLUMN muses_dev.ctmu031_turno.descripcion IS 'Descripcion del turno';

COMMENT ON COLUMN muses_dev.ctmu031_turno.activo IS 'Indica si está activo el registro del turno';

COMMENT ON COLUMN muses_dev.ctmu031_turno.fcreacion IS 'Fecha en que se generó el registro del turno';

COMMENT ON COLUMN muses_dev.ctmu031_turno.fmodificacion IS 'Fecha en que se modificó el registro del turno';

COMMENT ON COLUMN muses_dev.ctmu031_turno.fbaja IS 'Fecha en que se dio de baja el registro del turno';

COMMENT ON TABLE muses_dev.tbmu002_persona IS 'Entidad central que representa a un individuo (alumno, docente, tutor).';

COMMENT ON COLUMN muses_dev.tbmu002_persona.id_persona IS 'Pk de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.id_entidad_federativa_n IS 'fk de la entidad federativa de nacimiento con base al catálogo del inegi';

COMMENT ON COLUMN muses_dev.tbmu002_persona.curp IS 'CURP de la  persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.segmento_raiz IS 'segmento_raiz de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.rfc IS 'rfc de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.nombre IS 'nombre de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.primer_apellido IS 'primer_apellido de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.segundo_apellido IS 'segundo_apellido de la persona';

COMMENT ON COLUMN muses_dev.tbmu002_persona.id_sexo IS 'FK con id_sexo';

COMMENT ON COLUMN muses_dev.tbmu002_persona.activo IS 'Indica si está activo el registro de la persona';

COMMENT ON TABLE muses_dev.tbmu020_alumno IS 'Almacena los atributos específicos de una persona que es un alumno.';

COMMENT ON COLUMN muses_dev.tbmu020_alumno.id_alumno IS 'FK a `tbmu002_persona`';

COMMENT ON TABLE muses_dev.tbmu016_docente IS 'Almacena los atributos específicos de una persona que es un docente.';

COMMENT ON COLUMN muses_dev.tbmu016_docente.id_docente IS 'FK a `tbmu002_persona`';

COMMENT ON TABLE muses_dev.tbmu022_domicilio_persona IS 'Almacena la información de domicilio de una persona.';

COMMENT ON COLUMN muses_dev.tbmu022_domicilio_persona.id_localidad IS 'fk de la localidad con base al catálogo del inegi';

COMMENT ON COLUMN muses_dev.tbmu022_domicilio_persona.domicilio IS 'Calle, numero exterior y número interior de la persona';

COMMENT ON COLUMN muses_dev.tbmu022_domicilio_persona.codigo_postal IS 'Código postal de la persona';

COMMENT ON COLUMN muses_dev.tbmu022_domicilio_persona.activo IS 'Indica si está activo el registro del domicilio_persona';

COMMENT ON TABLE muses_dev.tbmu003_correo IS 'Almacena los correos electrónicos de una persona.';

COMMENT ON COLUMN muses_dev.tbmu003_correo.id_tipo_correo IS 'fk del tipo de correo';

COMMENT ON COLUMN muses_dev.tbmu003_correo.id_persona IS 'fk de la persona asociada';

COMMENT ON COLUMN muses_dev.tbmu003_correo.correo IS 'Dirección de correo electrónico';

COMMENT ON COLUMN muses_dev.tbmu003_correo.activo IS 'Indica si está activo el registro del correo';

COMMENT ON TABLE muses_dev.tbmu004_telefono IS 'Almacena los teléfonos de una persona.';

COMMENT ON COLUMN muses_dev.tbmu004_telefono.id_tipo_telefono IS 'fk del tipo de teléfono';

COMMENT ON COLUMN muses_dev.tbmu004_telefono.id_persona IS 'fk de la persona asociada';

COMMENT ON COLUMN muses_dev.tbmu004_telefono.telefono IS 'Número telefónico';

COMMENT ON COLUMN muses_dev.tbmu004_telefono.activo IS 'Indica si está activo el registro del telefono';

COMMENT ON TABLE muses_dev.tbmu005_curp_historica IS 'Histórico de CURPs de una persona.';

COMMENT ON COLUMN muses_dev.tbmu005_curp_historica.id_curp_historica IS 'Pk de curp histórica';

COMMENT ON COLUMN muses_dev.tbmu005_curp_historica.id_persona IS 'fk de la persona asociada';

COMMENT ON COLUMN muses_dev.tbmu005_curp_historica.curp IS 'curp histórica (antecedente)';

COMMENT ON COLUMN muses_dev.tbmu005_curp_historica.activo IS 'Indica si está activo el registro de la curp_historica';

COMMENT ON TABLE muses_dev.tbmu014_rfc_historico IS 'Histórico de RFCs de una persona.';

COMMENT ON TABLE muses_dev.tbmu008_institucion_academica IS 'Entidad que representa a una institución académica.';

COMMENT ON COLUMN muses_dev.tbmu008_institucion_academica.id_institucion IS 'Pk de la institución';

COMMENT ON COLUMN muses_dev.tbmu008_institucion_academica.nombre_institucion IS 'Nombre de la institución académica';

COMMENT ON COLUMN muses_dev.tbmu008_institucion_academica.activo IS 'Indica si está activo el registro de la institucion_academica';

COMMENT ON TABLE muses_dev.tbmu007_programa_academico IS 'Entidad que representa un programa o plan de estudios.';

COMMENT ON COLUMN muses_dev.tbmu007_programa_academico.id_programa_academico IS 'Pk de programas académicos';

COMMENT ON TABLE muses_dev.tbmu011_competencias IS 'Catálogo de competencias para los programas académicos.';

COMMENT ON TABLE muses_dev.tbmu009_programa_institucion IS 'Tabla de cruce que asocia un programa académico con una institución donde se imparte.';

COMMENT ON COLUMN muses_dev.tbmu009_programa_institucion.id_programa_institucion IS 'Pk de la institución académica';

COMMENT ON COLUMN muses_dev.tbmu009_programa_institucion.id_programa_academico IS 'Fk del programa académico';

COMMENT ON COLUMN muses_dev.tbmu009_programa_institucion.id_institucion IS 'Fk de la institución';

COMMENT ON COLUMN muses_dev.tbmu009_programa_institucion.id_opcion_educativa IS 'Fk de la opcion_educativa';

COMMENT ON COLUMN muses_dev.tbmu009_programa_institucion.activo IS 'Indica si está activo el registro del programa_institucion';

COMMENT ON TABLE muses_dev.tbmu006_inscripcion IS 'Tabla transaccional que registra la inscripción de un alumno a un programa en una institución.';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_inscripcion IS 'Pk de inscripción';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_alumno IS 'fk de la persona asociada (alumno)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_padre_tutor IS 'fk de la persona asociada (tutor)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_origen_estudios IS '(no aplica, nacionales, extranjeros)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.fecha_inicio_ems IS 'Fecha de inicio de estudios de Educación Media Superior dd/mm/aaaa';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_tipo_documento IS 'Descripción del tipo de documento de procedencia conforme a catálogo';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.folio_certificado IS 'Folio del certificado de procedencia (antecedente)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.cct_procedencia IS 'Clave Única del Centro de Trabajo de procedencia (antecedente)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.promedio_certificado IS 'Promedio del certificado de procedencia (antecedente)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.situacion_academica IS '(regular, irregular)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.miembro_grupo_escolar IS '(si / no)';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_ciclo_escolar IS 'Ciclo escolar. Ejemplo: 2024-2025';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_grado IS 'Descripción del grado a cursar conforme a catálogo';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.id_turno IS 'Descripción del turno conforme a catálogo.';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.promedio_acumulado_ems IS 'Promedio acumulado en ems al momento de la inscripción';

COMMENT ON COLUMN muses_dev.tbmu006_inscripcion.creditos_acumulados_ems IS 'Créditos acumulado en ems al momento de la inscripción';

COMMENT ON TABLE muses_dev.tbmu013_bajas IS 'Tabla transaccional que registra la baja de un alumno.';

COMMENT ON COLUMN muses_dev.tbmu013_bajas.id_baja IS 'Pk de Bajas';

COMMENT ON TABLE muses_dev.tbmu010_asignaturas IS 'Entidad que representa una asignatura o materia.';

COMMENT ON TABLE muses_dev.tbmu012_programa_asignatura IS 'Tabla de cruce que asocia una asignatura a un programa académico, definiendo horas y créditos.';

COMMENT ON COLUMN muses_dev.tbmu012_programa_asignatura.horas IS 'Indica el número total de horas de la asignatura para el programa académico asociado';

COMMENT ON COLUMN muses_dev.tbmu012_programa_asignatura.creditos IS 'Indica el número total de créditos de la asignatura para el programa académico asociado';

COMMENT ON COLUMN muses_dev.tbmu012_programa_asignatura.obligatoria IS 'Indica si la asignatura es obligatoria';

COMMENT ON COLUMN muses_dev.tbmu012_programa_asignatura.activo IS 'Indica si está activo el registro del programa_asignatura';

COMMENT ON TABLE muses_dev.tbmu019_calificaciones IS 'Tabla transaccional que registra las calificaciones de un alumno en una asignatura.';

COMMENT ON COLUMN muses_dev.tbmu019_calificaciones.id_calificacion IS 'pk de calificación';

COMMENT ON COLUMN muses_dev.tbmu019_calificaciones.id_alumno IS 'fk de la persona asociada';

COMMENT ON TABLE muses_dev.tbmu018_asistencias IS 'Tabla transaccional que registra la asistencia de una persona a una asignatura.';

COMMENT ON COLUMN muses_dev.tbmu018_asistencias.id_asistencia IS 'pk de asistencia';

COMMENT ON TABLE muses_dev.tbmu015_docente_asignatura IS 'Tabla de cruce que asigna un docente a una asignatura para un ciclo escolar específico.';

COMMENT ON COLUMN muses_dev.tbmu015_docente_asignatura.id_docente IS 'fk de la persona docente';

COMMENT ON COLUMN muses_dev.tbmu015_docente_asignatura.fecha_asignacion IS 'Fecha en la que el docente se asigno a la materia';