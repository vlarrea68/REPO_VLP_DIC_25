--
-- PostgreSQL database dump
--

\restrict 5zZIOISUVID0OZloiva4OvJBBSkaRXNh4kwr4pQnAbUiChLTkyjCKR2Qtbdn2bK

-- Dumped from database version 14.19
-- Dumped by pg_dump version 14.19

-- Started on 2025-10-09 13:42:50

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 59347)
-- Name: ides_sep_001; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ides_sep_001;


ALTER SCHEMA ides_sep_001 OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 59394)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

--
-- TOC entry 211 (class 1259 OID 59407)
-- Name: tbae001_inscripcion_subsis; Type: TABLE; Schema: ides_sep_001; Owner: postgres
--

CREATE TABLE ides_sep_001.tbae001_inscripcion_subsis (
    id_operacion_origen character varying(50) NOT NULL,
    id_subsistema smallint NOT NULL,
    matricula_alumno character varying(50),
    cct character varying(10),
    nombre_cct character varying(150),
    estatus_inscripcion character varying(50),
    pais_nacimiento character varying(150),
    estado_nacimiento character varying(150),
    pais character varying(150),
    estado character varying(150),
    municipio character varying(150),
    localidad character varying(150),
    domicilio character varying(150),
    codigo_postal character varying(5),
    tiene_discapacidad character varying(2),
    tipo_discapacidad character varying(150),
    aptitud_sobresaliente character varying(150),
    curp_actual character varying(18),
    curp_anterior character varying(18),
    segmento_raiz character varying(16),
    rfc character varying(13),
    nombre character varying(150),
    primer_apellido character varying(150),
    segundo_apellido character varying(150),
    genero character varying(20),
    estado_civil character varying(20),
    telefono_casa character varying(20),
    telefono_movil character varying(20),
    telefono_trabajo character varying(20),
    telefono_contacto character varying(20),
    afrodescendiente character varying(5),
    es_indigena character varying(2),
    minoria character varying(2),
    lengua_materna character varying(150),
    segunda_lengua character varying(150),
    correo_academico character varying(150),
    correo_personal character varying(150),
    beca_academica character varying(150),
    beca_deportiva character varying(150),
    origen_estudios character varying(150),
    fecha_inicio timestamp without time zone,
    tipo_documento character varying(150),
    folio_certificado character varying(150),
    cct_procedencia character varying(10),
    promedio_certificado character varying(150),
    situacion_academica character varying(150),
    fecha_inscripcion timestamp without time zone,
    ciclo_escolar character varying(150),
    tipo_periodo character varying(150),
    grado_cursa character varying(150),
    opcion_educativa character varying(150),
    cve_programa_academico character varying(150),
    desc_prog_academico character varying(150),
    turno character varying(150),
    promedio_acumulado character varying(150),
    creditos_acumulados character varying(150),
    fecha_actualizacion timestamp without time zone,
    id_estatus_procesamiento integer NOT NULL,
    CONSTRAINT "SYS_C007549" CHECK ((id_operacion_origen IS NOT NULL)),
    CONSTRAINT "SYS_C007550" CHECK ((id_estatus_procesamiento IS NOT NULL)),
    CONSTRAINT "SYS_C007551" CHECK ((id_subsistema IS NOT NULL))
);


ALTER TABLE ides_sep_001.tbae001_inscripcion_subsis OWNER TO postgres;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.id_subsistema; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.id_subsistema IS 'Clave del subsistema del alumno conforme a catalogo';


--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.matricula_alumno; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.matricula_alumno IS 'Identificador unico del alumno en el subsistema';


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.cct; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.cct IS 'Clave unica del Centro de Trabajo (escuela) del Alumno';


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.nombre_cct; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.nombre_cct IS 'Nombre del Centro de Trabajo';


--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.estatus_inscripcion; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.estatus_inscripcion IS 'Preinscripcion / Reinscripcion / Inscripcion';


--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.pais_nacimiento; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.pais_nacimiento IS 'Descripcion del pais de nacimiento del alumno con base al catalogo de inegi';


--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.estado_nacimiento; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.estado_nacimiento IS 'Descripcion de la entidad de nacimiento del alumno con base al catalogo de inegi';


--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.pais; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.pais IS 'Descripcion del pais del domicilio del alumno con base al catalogo de inegi';


--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.estado; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.estado IS 'Descripcion de la entidad del domicilio del alumno con base al catalogo de inegi';


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.municipio; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.municipio IS 'Descripcion del municipio del domicilio del alumno con base al catalogo del inegi';


--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.localidad; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.localidad IS 'Descripcion de la localidad del domicilio del alumno con base al catalogo del inegi';


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.domicilio; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.domicilio IS 'Calle, numero exterior y numero interior del alumno';


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.codigo_postal; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.codigo_postal IS 'Codigo postal del alumno';


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.tiene_discapacidad; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.tiene_discapacidad IS 'Si el alumno cuenta con algun tipo de discapacidad
Valores vlidos:
si / no';


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.tipo_discapacidad; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.tipo_discapacidad IS 'Descripcion del tipo de discapacidad conforme a catalogo
Valores validos:
intelectual 
motriz 
auditiva - sordera
auditiva - hipoacusia 
visual - ceguera
visual - baja vision 
multiple
sordoceguera
mental O psicosocial 
trastorno (condicion) del espectro autista 
trastorno por dficit de atencion E hiperactividad 
severas de conducta
severas de comunicacion
severas de aprendizaje

';


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.aptitud_sobresaliente; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.aptitud_sobresaliente IS 'Descripcion de la aptitud sobresaliente conforme a catlogo.
Valores vlidos:
intelectual
creativa
socioafectiva
artistica
psicomotriz

';


--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.curp_actual; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.curp_actual IS 'curp del alumno, con base al registro en renapo';


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.curp_anterior; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.curp_anterior IS 'curp anterior del alumno, en caso de existir';


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.segmento_raiz; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.segmento_raiz IS 'Segmento raiz de la curp del alumno';


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.rfc; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.rfc IS 'rfc del alumno';


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.nombre; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.nombre IS 'Nombre(s) del alumno';


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.primer_apellido; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.primer_apellido IS 'Primer apellido del alumno';


--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.segundo_apellido; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.segundo_apellido IS 'Segundo apellido del alumno';


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.genero; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.genero IS 'Genero del alumno
Valores vlidos:
hombre / mujer
';


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.estado_civil; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.estado_civil IS 'Estado civil del alumno
Valores validos:
soltero
casado
viudo
divorciado
';


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.telefono_casa; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.telefono_casa IS 'Telefono de casa a 10 digitos';


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.telefono_movil; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.telefono_movil IS 'Telefono movil a 10 digitos';


--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.telefono_trabajo; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.telefono_trabajo IS 'Telefono trabajo a 10 digitos';


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.telefono_contacto; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.telefono_contacto IS 'Telefono de contacto en caso de emergencia a 10 digitos';


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.afrodescendiente; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.afrodescendiente IS 'Valores validos:
si / no';


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.es_indigena; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.es_indigena IS 'Valores validos:
si / no';


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.minoria; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.minoria IS 'Valores validos:
si / no';


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.lengua_materna; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.lengua_materna IS 'Descripcion de la lengua conforme a catalogo';


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.segunda_lengua; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.segunda_lengua IS 'Descripcion de la lengua conforme a catalogo';


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.correo_academico; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.correo_academico IS 'Correo electronico del alumno en la Institucion Academica';


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.correo_personal; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.correo_personal IS 'Correo electronico personal del alumno ';


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.beca_academica; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.beca_academica IS 'Nombre de la beca academica en caso de contar con una';


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.beca_deportiva; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.beca_deportiva IS 'Nombre de la beca deportiva en caso de contar con una';


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.origen_estudios; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.origen_estudios IS 'Valores validos:
no aplica
nacionales
extranjeros
';


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.fecha_inicio; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.fecha_inicio IS 'Fecha de inicio de estudios de Educacion Media Superior dd/mm/aaaa';


--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.tipo_documento; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.tipo_documento IS 'Descripcion del tipo de documento de procedencia conforme a catalogo';


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.folio_certificado; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.folio_certificado IS 'Folio del certificado de procedencia (antecedente)';


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.cct_procedencia; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.cct_procedencia IS 'Clave unica del Centro de Trabajo de procedencia (antecedente)';


--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.promedio_certificado; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.promedio_certificado IS 'Promedio del certificado de procedencia (antecedente)';


--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.situacion_academica; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.situacion_academica IS 'Sin adeudo / con adeudo de uac
Valores validos:
regular
irregular
';


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.fecha_inscripcion; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.fecha_inscripcion IS 'Fecha de inscripcion formato dd/mm/aaaa';


--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.ciclo_escolar; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.ciclo_escolar IS 'Ciclo escolar. Ejemplo: 2024-2025';


--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.tipo_periodo; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.tipo_periodo IS 'Tipo de Periodo de Inscripcion, conforme a catalogo
Valores validos: 
anual
semestral
trimestral
bimestral
mensual';


--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.grado_cursa; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.grado_cursa IS 'Descripcion del grado a cursar conforme a catalogo';


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.opcion_educativa; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.opcion_educativa IS 'Descripcion de la opcion educativa conforme a catlogo
';


--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.cve_programa_academico; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.cve_programa_academico IS 'Clave del programa academico';


--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.desc_prog_academico; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.desc_prog_academico IS 'Descripcion del programa academico';


--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.turno; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.turno IS 'Descripcion del turno conforme a catalogo.
Valores validos
matutino
vespertino
nocturno
discontinuo/mixto
continuo
abierto

';


--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.promedio_acumulado; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.promedio_acumulado IS 'Promedio acumulado en ems al momento de la inscripcion';


--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.creditos_acumulados; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.creditos_acumulados IS 'Creditos acumulados en ems al momento de la inscripcion';


--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.fecha_actualizacion; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.fecha_actualizacion IS 'Fecha de actualizacion formato dd/mm/aaaa hh:mm:ss';


--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN tbae001_inscripcion_subsis.id_estatus_procesamiento; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae001_inscripcion_subsis.id_estatus_procesamiento IS 'Clave de estatus del procesamiento';


--
-- TOC entry 212 (class 1259 OID 59415)
-- Name: tbae002_bajas_subsis; Type: TABLE; Schema: ides_sep_001; Owner: postgres
--

CREATE TABLE ides_sep_001.tbae002_bajas_subsis (
    id_operacion_origen character varying(50) NOT NULL,
    id_subsistema smallint NOT NULL,
    matricula_alumno character varying(50),
    tipo_baja character varying(50),
    motivo_baja character varying(150),
    curp character varying(18),
    nombre character varying(150),
    primer_apellido character varying(150),
    segundo_apellido character varying(150),
    fecha_baja timestamp with time zone,
    cct character varying(10),
    cve_programa_academico character varying(150),
    desc_prog_academico character varying(150),
    id_estatus_procesamiento integer NOT NULL,
    fecha_actualizacion timestamp without time zone,
    curp_solicita_baja character varying(18),
    nombre_solicita_baja character varying(150),
    primer_apellido_solicita_baja character varying(150),
    segundo_apellido_solicita_baja character varying(150),
    CONSTRAINT "SYS_C007553" CHECK ((id_operacion_origen IS NOT NULL))
);


ALTER TABLE ides_sep_001.tbae002_bajas_subsis OWNER TO postgres;

--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.id_subsistema; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.id_subsistema IS 'Clave del subsistema del alumno conforme a catalogo';


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.matricula_alumno; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.matricula_alumno IS 'Identificador unico del alumno en el subsistema';


--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.tipo_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.tipo_baja IS 'Descripcion del turno conforme a catalogo.
Valores validos:
baja temporal
baja definitiva
';


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.motivo_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.motivo_baja IS 'Descripcion del turno conforme a catalogo.
Valores validos:
baja por dificultad de acceso/transporte al plantel (distancia)
baja por cambio de domicilio A otro pais.
baja por cambio de domicilio A otra entidad federativa
baja por adeudo de materias.
baja por embarazo, maternidad, paternidad O matrimonio. (*)
baja por factor econmico.
baja por trabajo.
baja por enfermedad cronica Y/O estancia hospitalaria.
baja por defuncion.
baja por medida preventiva O disciplinaria del plantel.
baja por motivos emocionales.
baja por violencia O inseguridad en el entorno social.
baja por acoso escolar (reformular cmo se pregunta).
baja por adicciones.
baja por problemas O enfermedad familiar.
baja por desinteres O falta de motivacion.
baja por retraso de entrega de certificado de secundaria.
';


--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.curp; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.curp IS 'curp del alumno, con base al registro en renapo';


--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.nombre; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.nombre IS 'Nombre(s) del alumno';


--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.primer_apellido; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.primer_apellido IS 'Primer apellido del alumno';


--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.segundo_apellido; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.segundo_apellido IS 'Segundo apellido del alumno';


--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.fecha_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.fecha_baja IS 'Fecha de baja formato dd/mm/aaaa';


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.cct; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.cct IS 'Clave unica del Centro de Trabajo (escuela) del Alumno';


--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.cve_programa_academico; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.cve_programa_academico IS 'Clave del programa academico';


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.desc_prog_academico; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.desc_prog_academico IS 'Descripcion del programa academico';


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.fecha_actualizacion; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.fecha_actualizacion IS 'Fecha de actualizacion formato dd/mm/aaaa hh:mm:ss';


--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.curp_solicita_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.curp_solicita_baja IS 'curp de la persona que solicita la baja (alumno, tutor)';


--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.nombre_solicita_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.nombre_solicita_baja IS 'Nombre(s) de la persona que solicita la baja';


--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.primer_apellido_solicita_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.primer_apellido_solicita_baja IS 'Primer apellido de la persona que solicita la baja';


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN tbae002_bajas_subsis.segundo_apellido_solicita_baja; Type: COMMENT; Schema: ides_sep_001; Owner: postgres
--

COMMENT ON COLUMN ides_sep_001.tbae002_bajas_subsis.segundo_apellido_solicita_baja IS 'Segundo apellido de la persona que solicita la baja';


--
-- TOC entry 213 (class 1259 OID 59421)
-- Name: tbae009_respuesta_subsis; Type: TABLE; Schema: ides_sep_001; Owner: postgres
--

CREATE TABLE ides_sep_001.tbae009_respuesta_subsis (
    id_respuesta integer NOT NULL,
    uuid character varying(36) NOT NULL,
    id_operacion_origen character varying(50) NOT NULL,
    matricula_alumno character varying(50) NOT NULL,
    id_estatus_procesamiento integer NOT NULL,
    fecha_respuesta timestamp without time zone NOT NULL,
    CONSTRAINT "SYS_C007555" CHECK ((id_respuesta IS NOT NULL)),
    CONSTRAINT "SYS_C007556" CHECK ((fecha_respuesta IS NOT NULL)),
    CONSTRAINT "SYS_C007557" CHECK ((id_estatus_procesamiento IS NOT NULL)),
    CONSTRAINT "SYS_C007558" CHECK ((id_operacion_origen IS NOT NULL)),
    CONSTRAINT "SYS_C007559" CHECK ((matricula_alumno IS NOT NULL)),
    CONSTRAINT "SYS_C007560" CHECK ((uuid IS NOT NULL))
);


ALTER TABLE ides_sep_001.tbae009_respuesta_subsis OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 59430)
-- Name: tbae010_error_subsis; Type: TABLE; Schema: ides_sep_001; Owner: postgres
--

CREATE TABLE ides_sep_001.tbae010_error_subsis (
    id_error integer NOT NULL,
    id_respuesta integer NOT NULL,
    id_motivo_error integer NOT NULL,
    descripcion_error character varying(150) NOT NULL,
    warning integer NOT NULL,
    fecha_actualizacion timestamp with time zone,
    solucionado integer NOT NULL,
    CONSTRAINT "SYS_C007562" CHECK ((id_error IS NOT NULL)),
    CONSTRAINT "SYS_C007563" CHECK ((descripcion_error IS NOT NULL)),
    CONSTRAINT "SYS_C007564" CHECK ((warning IS NOT NULL)),
    CONSTRAINT "SYS_C007565" CHECK ((id_motivo_error IS NOT NULL)),
    CONSTRAINT "SYS_C007566" CHECK ((id_respuesta IS NOT NULL)),
    CONSTRAINT "SYS_C007567" CHECK ((solucionado IS NOT NULL)),
    CONSTRAINT "SYS_C007568" CHECK ((warning = ANY (ARRAY[0, 1]))),
    CONSTRAINT "SYS_C007569" CHECK ((solucionado = ANY (ARRAY[0, 1])))
);


ALTER TABLE ides_sep_001.tbae010_error_subsis OWNER TO postgres;

--
-- TOC entry 3207 (class 2606 OID 59442)
-- Name: tbae001_inscripcion_subsis tbae001_inscripcion_subsis_pk; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae001_inscripcion_subsis
    ADD CONSTRAINT tbae001_inscripcion_subsis_pk PRIMARY KEY (id_operacion_origen);


--
-- TOC entry 3209 (class 2606 OID 59444)
-- Name: tbae001_inscripcion_subsis tbae001_inscripcion_subsis_un; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae001_inscripcion_subsis
    ADD CONSTRAINT tbae001_inscripcion_subsis_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3211 (class 2606 OID 59446)
-- Name: tbae002_bajas_subsis tbae002_bajas_subsis_pk; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae002_bajas_subsis
    ADD CONSTRAINT tbae002_bajas_subsis_pk PRIMARY KEY (id_operacion_origen);


--
-- TOC entry 3213 (class 2606 OID 59448)
-- Name: tbae002_bajas_subsis tbae002_bajas_subsis_un; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae002_bajas_subsis
    ADD CONSTRAINT tbae002_bajas_subsis_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3215 (class 2606 OID 59450)
-- Name: tbae009_respuesta_subsis tbae009_respuesta_subsis_pk; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae009_respuesta_subsis
    ADD CONSTRAINT tbae009_respuesta_subsis_pk PRIMARY KEY (id_respuesta);


--
-- TOC entry 3217 (class 2606 OID 59452)
-- Name: tbae010_error_subsis tbae010_error_subsis_pk; Type: CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae010_error_subsis
    ADD CONSTRAINT tbae010_error_subsis_pk PRIMARY KEY (id_error);


--
-- TOC entry 3218 (class 2606 OID 59454)
-- Name: tbae010_error_subsis tbae010_tbae009_subsis_fk; Type: FK CONSTRAINT; Schema: ides_sep_001; Owner: postgres
--

ALTER TABLE ONLY ides_sep_001.tbae010_error_subsis
    ADD CONSTRAINT tbae010_tbae009_subsis_fk FOREIGN KEY (id_respuesta) REFERENCES ides_sep_001.tbae009_respuesta_subsis(id_respuesta);


-- Completed on 2025-10-09 13:42:51

--
-- PostgreSQL database dump complete
--

\unrestrict 5zZIOISUVID0OZloiva4OvJBBSkaRXNh4kwr4pQnAbUiChLTkyjCKR2Qtbdn2bK

