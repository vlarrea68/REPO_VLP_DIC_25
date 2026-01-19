-- =============================================================
-- DDL: SEP MUSES - versión 0.0
-- Fecha: 2025-10-09
-- Entorno: PostgreSQL 14
-- Esquema: muses_dev
-- =============================================================

--
-- PostgreSQL database dump
--

\restrict XEwOw2IT3TAgLUUGEst4WqXT66gkoSgJ6dAabV2oRskCYwyLtN5Rfh8EhV9vAjY

-- Dumped from database version 14.19
-- Dumped by pg_dump version 14.19

-- Started on 2025-10-09 13:10:15

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
-- TOC entry 7 (class 2615 OID 58415)
-- Name: muses_dev; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA muses_dev;


ALTER SCHEMA muses_dev OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 58462)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 2



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 58580)
-- Name: ctmu001_tipo_periodo; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu001_tipo_periodo (
    id_tipo_periodo integer NOT NULL,
    descricion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone,
    notificado_siged boolean DEFAULT false
);


ALTER TABLE muses_dev.ctmu001_tipo_periodo OWNER TO postgres;

--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 211



--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 211



--
-- TOC entry 212 (class 1259 OID 58583)
-- Name: ctmu002_tipo_telefono; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu002_tipo_telefono (
    id_tipo_telefono integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu002_tipo_telefono OWNER TO postgres;

--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 212



--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 212



--
-- TOC entry 213 (class 1259 OID 58586)
-- Name: ctmu003_sexo; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu003_sexo (
    id_sexo integer NOT NULL,
    descripcion character varying(20) NOT NULL,
    clave character varying(1) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu003_sexo OWNER TO postgres;

--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 213



--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 213



--
-- TOC entry 214 (class 1259 OID 58589)
-- Name: ctmu004_discapacidad; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu004_discapacidad (
    id_discapacidad integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    clave character varying(10),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu004_discapacidad OWNER TO postgres;

--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 214



--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 214



--
-- TOC entry 215 (class 1259 OID 58592)
-- Name: ctmu006_estado_civil; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu006_estado_civil (
    id_estado_civil integer NOT NULL,
    descripcion character varying(20) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu006_estado_civil OWNER TO postgres;

--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 215



--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 215



--
-- TOC entry 216 (class 1259 OID 58595)
-- Name: ctmu007_tipo_correo; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu007_tipo_correo (
    id_tipo_correo integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu007_tipo_correo OWNER TO postgres;

--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 216



--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 216



--
-- TOC entry 217 (class 1259 OID 58598)
-- Name: ctmu008_motivo_error; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu008_motivo_error (
    id_motivo_error integer NOT NULL,
    tipo_error integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) DEFAULT 'A'::bpchar NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu008_motivo_error OWNER TO postgres;

--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 217



--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 217

1 - Error
2 - Advertencia';


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 217



--
-- TOC entry 218 (class 1259 OID 58602)
-- Name: ctmu009_subsistema; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu009_subsistema (
    id_subsistema integer NOT NULL,
    descripcion character varying(150),
    id_tipo_subsistema integer NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu009_subsistema OWNER TO postgres;

--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 218



--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 218



--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 218



--
-- TOC entry 219 (class 1259 OID 58605)
-- Name: ctmu010_tipo_subsistema; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu010_tipo_subsistema (
    id_tipo_subsistema integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) DEFAULT 'A'::bpchar NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone,
    fcreacion timestamp(6) without time zone NOT NULL
);


ALTER TABLE muses_dev.ctmu010_tipo_subsistema OWNER TO postgres;

--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 219



--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 219



--
-- TOC entry 220 (class 1259 OID 58609)
-- Name: ctmu011_estatus_procesamiento; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu011_estatus_procesamiento (
    id_estatus_procesamiento integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) DEFAULT 'A'::bpchar NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu011_estatus_procesamiento OWNER TO postgres;

--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 220



--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 220



--
-- TOC entry 221 (class 1259 OID 58613)
-- Name: ctmu013_entidad_federativa; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu013_entidad_federativa (
    id_entidad_federativa integer NOT NULL,
    id_pais integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    abreviatura character varying(10),
    clave character varying(10),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu013_entidad_federativa OWNER TO postgres;

--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 221



--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 221



--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 221



--
-- TOC entry 222 (class 1259 OID 58616)
-- Name: ctmu014_estatus_inscripcion; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu014_estatus_inscripcion (
    id_estatus_inscripcion integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu014_estatus_inscripcion OWNER TO postgres;

--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 222



--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 222



--
-- TOC entry 223 (class 1259 OID 58619)
-- Name: ctmu015_localidad; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu015_localidad (
    id_localidad integer NOT NULL,
    id_municipio integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    abreviatura character varying(10),
    clave character varying(10),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu015_localidad OWNER TO postgres;

--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 223



--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 223



--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 223



--
-- TOC entry 224 (class 1259 OID 58622)
-- Name: ctmu016_municipio; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu016_municipio (
    id_municipio integer NOT NULL,
    id_entidad_federativa integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    abreviatura character varying(10),
    clave character varying(10) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu016_municipio OWNER TO postgres;

--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 224



--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 224



--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 224



--
-- TOC entry 225 (class 1259 OID 58625)
-- Name: ctmu017_pais; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu017_pais (
    id_pais integer NOT NULL,
    clave character varying(3) NOT NULL,
    descripcion character varying(200) NOT NULL,
    abreviatura character varying(3),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu017_pais OWNER TO postgres;

--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 225



--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 225



--
-- TOC entry 226 (class 1259 OID 58628)
-- Name: ctmu019_motivos_baja; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu019_motivos_baja (
    id_motivo_baja integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu019_motivos_baja OWNER TO postgres;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 226



--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 226



--
-- TOC entry 227 (class 1259 OID 58634)
-- Name: ctmu022_ciclo_escolar; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu022_ciclo_escolar (
    id_ciclo_escolar integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu022_ciclo_escolar OWNER TO postgres;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 227



--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 227



--
-- TOC entry 228 (class 1259 OID 58637)
-- Name: ctmu023_tipo_evaluacion; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu023_tipo_evaluacion (
    id_tipo_evaluacion integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu023_tipo_evaluacion OWNER TO postgres;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 228



--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 228



--
-- TOC entry 229 (class 1259 OID 58640)
-- Name: ctmu024_parcialidad; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu024_parcialidad (
    id_parcialidad integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    creado timestamp(6) without time zone NOT NULL,
    actualizado timestamp(6) without time zone,
    eliminado timestamp(6) without time zone,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu024_parcialidad OWNER TO postgres;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 229



--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 229



--
-- TOC entry 230 (class 1259 OID 58643)
-- Name: ctmu025_aptitud_sobresal; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu025_aptitud_sobresal (
    id_aptitud_sobresal integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    clave character varying(10) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu025_aptitud_sobresal OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 58646)
-- Name: ctmu026_idioma_lengua; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu026_idioma_lengua (
    id_idioma_lengua integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    clave character varying(10) NOT NULL,
    idioma_lengua character varying(1) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu026_idioma_lengua OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 58649)
-- Name: ctmu027_origen_estudios; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu027_origen_estudios (
    id_origen_estudios integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu027_origen_estudios OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 58652)
-- Name: ctmu028_tipo_documento; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu028_tipo_documento (
    id_tipo_documento integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    clave character varying(3) NOT NULL,
    formato character varying(20) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu028_tipo_documento OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 58655)
-- Name: ctmu029_grado; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu029_grado (
    id_grado integer NOT NULL,
    descripcion character varying(90) NOT NULL,
    clave character varying(10) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu029_grado OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 58658)
-- Name: ctmu030_modalidad_educativa; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu030_modalidad_educativa (
    id_modalidad_educativa integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu030_modalidad_educativa OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 58661)
-- Name: ctmu030_opcion_educativa; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu030_opcion_educativa (
    id_opcion_educativa integer NOT NULL,
    id_modalidad_educativa integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu030_opcion_educativa OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 58664)
-- Name: ctmu031_turno; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.ctmu031_turno (
    id_turno integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.ctmu031_turno OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 58681)
-- Name: sq_ctmu008_motivo_error; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_ctmu008_motivo_error
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_ctmu008_motivo_error OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 58682)
-- Name: sq_ctmu009_subsistema; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_ctmu009_subsistema
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_ctmu009_subsistema OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 58683)
-- Name: sq_ctmu010_tipo_subsistema; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_ctmu010_tipo_subsistema
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_ctmu010_tipo_subsistema OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 58685)
-- Name: sq_tbae000_bajas; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_tbae000_bajas
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_tbae000_bajas OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 58686)
-- Name: sq_tbae001_inscripcion; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_tbae001_inscripcion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_tbae001_inscripcion OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 58687)
-- Name: sq_tbmu001_error; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_tbmu001_error
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_tbmu001_error OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 58689)
-- Name: sq_xpobjecttype; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sq_xpobjecttype
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE muses_dev.sq_xpobjecttype OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 58690)
-- Name: sqae_tbae009; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sqae_tbae009
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 20;


ALTER TABLE muses_dev.sqae_tbae009 OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 58691)
-- Name: sqae_tbae010; Type: SEQUENCE; Schema: muses_dev; Owner: postgres
--

CREATE SEQUENCE muses_dev.sqae_tbae010
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 20;


ALTER TABLE muses_dev.sqae_tbae010 OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 58692)
-- Name: tbae001_inscripcion; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae001_inscripcion (
    uuid character varying(36) DEFAULT public.uuid_generate_v4() NOT NULL,
    id_operacion_origen character varying(50),
    id_subsistema integer NOT NULL,
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
    fecha_actualizacion timestamp(6) without time zone,
    id_estatus_procesamiento integer NOT NULL
);


ALTER TABLE muses_dev.tbae001_inscripcion OWNER TO postgres;

--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
si / no';


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
intelectual 
motriz 
auditiva - sordera
auditiva - hipoacusia 
visual - ceguera
visual - baja VISIÓN 
MÚLTIPLE
sordoceguera
mental O psicosocial 
trastorno (CONDICIÓN) del espectro autista 
trastorno por DÉFICIT de ATENCIÓN E hiperactividad 
severas de conducta
severas de COMUNICACIÓN
severas de aprendizaje

';


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
intelectual
creativa
socioafectiva
ARTÍSTICA
psicomotriz

';


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
hombre / mujer
';


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
soltero
casado
viudo
divorciado
';


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 247

si / no';


--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 247

si / no';


--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 247

si / no';


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 247

no aplica
nacionales
extranjeros
';


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 247

Valores válidos:
regular
irregular
';


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 247

Valores válidos: 
anual
semestral
trimestral
bimestral
mensual';


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 247

';


--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 247

Valores válidos
matutino
verpertino
nocturno
discontinuo/mixto
continuo
abierto

';


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 247



--
-- TOC entry 248 (class 1259 OID 58698)
-- Name: tbae002_bajas; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae002_bajas (
    uuid character varying(36) NOT NULL,
    id_operacion_origen character varying(50),
    id_subsistema integer NOT NULL,
    matricula_alumno character varying(50),
    tipo_baja character varying(50),
    motivo_baja character varying(150),
    curp character varying(18),
    nombre character varying(150),
    primer_apellido character varying(150),
    segundo_apellido character varying(150),
    fecha_baja timestamp(6) with time zone,
    cct character varying(10),
    cve_programa_academico character varying(150),
    desc_prog_academico character varying(150),
    id_estatus_procesamiento integer NOT NULL,
    fecha_actualizacion timestamp(6) without time zone,
    curp_solicita_baja character varying(18),
    nombre_solicita_baja character varying(150),
    primer_apellido_solicita_baja character varying(150),
    segundo_apellido_solicita_baja character varying(150)
);


ALTER TABLE muses_dev.tbae002_bajas OWNER TO postgres;

--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 248

Valores válidos:
baja temporal
baja definitiva
';


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 248

Valores válidos:
baja por dificultad de acceso/transporte al plantel (distancia)
baja por cambio de domicilio A otro PAÍS.
baja por cambio de domicilio A otra entidad federativa
baja por adeudo de materias.
baja por embarazo, maternidad, paternidad O matrimonio. (*)
baja por factor ECONÓMICO.
baja por trabajo.
baja por enfermedad CRÓNICA Y/O estancia hospitalaria.
baja por DEFUNCIÓN.
baja por medida preventiva O disciplinaria del plantel.
baja por motivos emocionales.
baja por violencia O inseguridad en el entorno social.
baja por acoso escolar (reformular CÓMO se pregunta).
baja por adicciones.
baja por problemas O enfermedad familiar.
baja por DESINTERÉS O falta de MOTIVACIÓN.
baja por retraso de entrega de certificado de secundaria.
';


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 248



--
-- TOC entry 249 (class 1259 OID 58703)
-- Name: tbae005_asistencias; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae005_asistencias (
    uuid character varying(36) NOT NULL,
    id_operacion_origen character varying(50),
    id_subsistema integer NOT NULL,
    matricula_alumno character varying(50),
    curp character varying(18),
    nombre character varying(150),
    primer_apellido character varying(150),
    segundo_apellido character varying(150),
    fecha_asistencia timestamp(6) without time zone,
    cct character varying(10),
    cve_programa_academico character varying(150),
    desc_prog_academico character varying(150),
    cve_asignatura character varying(150),
    asignatura character varying(150),
    id_estatus_procesamiento integer NOT NULL,
    fecha_actualizacion timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbae005_asistencias OWNER TO postgres;

--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 249



--
-- TOC entry 250 (class 1259 OID 58708)
-- Name: tbae007_calificaciones; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae007_calificaciones (
    uuid character varying(36) NOT NULL,
    id_operacion_origen character varying(50),
    id_subsistema integer NOT NULL,
    matricula_alumno character varying(50),
    curp character varying(18),
    nombre character varying(150),
    primer_apellido character varying(150),
    segundo_apellido character varying(150),
    cct character varying(10),
    cve_programa_academico character varying(150),
    desc_prog_academico character varying(150),
    cve_asignatura character varying(150),
    anio character varying(4),
    periodo character varying(150),
    parcialidad character varying(150),
    calificacion character varying(150),
    tipo_evaluacion character varying(20),
    ponderacion character varying(150),
    fecha_calificacion timestamp(6) without time zone,
    id_estatus_procesamiento integer NOT NULL,
    fecha_actualizacion timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbae007_calificaciones OWNER TO postgres;

--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 250

';


--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 250



--
-- TOC entry 251 (class 1259 OID 58713)
-- Name: tbae009_respuesta; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae009_respuesta (
    id_respuesta integer DEFAULT nextval('muses_dev.sqae_tbae009'::regclass) NOT NULL,
    uuid character varying(36) NOT NULL,
    id_estatus_procesamiento integer NOT NULL,
    fecha_respuesta timestamp(6) without time zone NOT NULL
);


ALTER TABLE muses_dev.tbae009_respuesta OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 58717)
-- Name: tbae010_error; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbae010_error (
    id_error integer DEFAULT nextval('muses_dev.sqae_tbae010'::regclass) NOT NULL,
    id_respuesta integer NOT NULL,
    id_motivo_error integer NOT NULL
);


ALTER TABLE muses_dev.tbae010_error OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 58721)
-- Name: tbmu002_persona; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu002_persona (
    id_persona integer NOT NULL,
    id_entidad_federativa_n integer NOT NULL,
    curp character varying(18),
    segmento_raiz character varying(16) NOT NULL,
    rfc character varying(13) NOT NULL,
    nombre character varying(50) NOT NULL,
    primer_apellido character varying(50) NOT NULL,
    segundo_apellido character varying(50),
    id_sexo integer NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu002_persona OWNER TO postgres;

--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 253



--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 253



--
-- TOC entry 254 (class 1259 OID 58724)
-- Name: tbmu003_correo; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu003_correo (
    id_tipo_correo integer NOT NULL,
    id_persona integer NOT NULL,
    correo character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu003_correo OWNER TO postgres;

--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 254



--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 254



--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 254

';


--
-- TOC entry 255 (class 1259 OID 58727)
-- Name: tbmu004_telefono; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu004_telefono (
    id_tipo_telefono integer NOT NULL,
    id_persona integer NOT NULL,
    telefono character varying(20) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu004_telefono OWNER TO postgres;

--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 255



--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 255



--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 255



--
-- TOC entry 256 (class 1259 OID 58730)
-- Name: tbmu005_curp_historica; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu005_curp_historica (
    id_curp_historica integer NOT NULL,
    id_persona integer NOT NULL,
    curp character varying(18) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu005_curp_historica OWNER TO postgres;

--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 256



--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 256



--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 256



--
-- TOC entry 257 (class 1259 OID 58733)
-- Name: tbmu006_inscripcion; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu006_inscripcion (
    id_inscripcion integer NOT NULL,
    id_alumno integer NOT NULL,
    id_padre_tutor integer,
    id_programa_institucion integer NOT NULL,
    id_estatus_inscripcion integer NOT NULL,
    id_tipo_periodo integer NOT NULL,
    cct character varying(10) NOT NULL,
    fecha_inscripcion timestamp(6) without time zone NOT NULL,
    id_origen_estudios integer NOT NULL,
    fecha_inicio_ems timestamp without time zone,
    id_tipo_documento integer NOT NULL,
    folio_certificado character varying(150),
    cct_procedencia character varying(10),
    promedio_certificado character varying(150),
    situacion_academica character varying(150) NOT NULL,
    miembro_grupo_escolar character varying(150) NOT NULL,
    id_ciclo_escolar integer NOT NULL,
    id_grado integer NOT NULL,
    id_turno integer NOT NULL,
    promedio_acumulado_ems character varying(150),
    creditos_acumulados_ems character varying(150),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone,
    id_subsistema integer NOT NULL,
    notificado_siged boolean DEFAULT false
);


ALTER TABLE muses_dev.tbmu006_inscripcion OWNER TO postgres;

--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 257

no aplica
nacionales
extranjeros
';


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 257

Valores válidos:
regular
irregular
';


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 257

si / no
';


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 257

Valores válidos
matutino
verpertino
nocturno
discontinuo/mixto
continuo
abierto

';


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 257



--
-- TOC entry 258 (class 1259 OID 58738)
-- Name: tbmu007_programa_academico; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu007_programa_academico (
    id_programa_academico integer NOT NULL,
    id_competencia integer NOT NULL,
    id_periodicidad integer NOT NULL,
    cve_programa_academico character varying(150) NOT NULL,
    descripcion_programa_academico character varying(150) NOT NULL,
    total_creditos character varying(150),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu007_programa_academico OWNER TO postgres;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 258



--
-- TOC entry 259 (class 1259 OID 58741)
-- Name: tbmu008_institucion_academica; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu008_institucion_academica (
    id_institucion integer NOT NULL,
    nombre_institucion character varying(250) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu008_institucion_academica OWNER TO postgres;

--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 259



--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 259



--
-- TOC entry 260 (class 1259 OID 58744)
-- Name: tbmu009_programa_institucion; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu009_programa_institucion (
    id_programa_institucion integer NOT NULL,
    id_programa_academico integer NOT NULL,
    id_institucion integer NOT NULL,
    id_opcion_educativa integer NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu009_programa_institucion OWNER TO postgres;

--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 260



--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 260



--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 260



--
-- TOC entry 261 (class 1259 OID 58747)
-- Name: tbmu010_asignaturas; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu010_asignaturas (
    id_asignatura integer NOT NULL,
    cve_asignatura character varying(150) NOT NULL,
    nombre_asignatura character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu010_asignaturas OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 58750)
-- Name: tbmu011_competencias; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu011_competencias (
    id_competencia integer NOT NULL,
    descripcion character varying(150) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu011_competencias OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 58753)
-- Name: tbmu012_programa_asignatura; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu012_programa_asignatura (
    id_programa_asignatura integer NOT NULL,
    id_programa_academico integer NOT NULL,
    id_asignatura integer,
    horas character varying(150),
    creditos character varying(150),
    obligatoria character(1),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu012_programa_asignatura OWNER TO postgres;

--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 263



--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 263



--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 263



--
-- TOC entry 264 (class 1259 OID 58756)
-- Name: tbmu013_bajas; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu013_bajas (
    id_baja integer NOT NULL,
    id_persona integer NOT NULL,
    id_motivo_baja integer NOT NULL,
    id_subsistema integer NOT NULL,
    id_programa_institucion integer NOT NULL,
    tipo_baja character varying(50) NOT NULL,
    fecha_baja timestamp(6) with time zone NOT NULL,
    cct character varying(20),
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu013_bajas OWNER TO postgres;

--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 264



--
-- TOC entry 265 (class 1259 OID 58759)
-- Name: tbmu014_rfc_historico; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu014_rfc_historico (
    id_rfc_historico integer NOT NULL,
    id_persona integer NOT NULL,
    rfc character varying(13) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu014_rfc_historico OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 58762)
-- Name: tbmu015_docente_asignatura; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu015_docente_asignatura (
    id_docente_asignatura integer NOT NULL,
    id_docente integer NOT NULL,
    id_programa_institucion integer NOT NULL,
    id_programa_asignatura integer NOT NULL,
    id_ciclo_escolar integer NOT NULL,
    fecha_asignacion timestamp(6) without time zone NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu015_docente_asignatura OWNER TO postgres;

--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 266



--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 266



--
-- TOC entry 267 (class 1259 OID 58765)
-- Name: tbmu016_docente; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu016_docente (
    id_docente integer NOT NULL,
    clave_cobro character varying(30) NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu016_docente OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 58771)
-- Name: tbmu018_asistencias; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu018_asistencias (
    id_asistencia integer NOT NULL,
    id_persona integer NOT NULL,
    id_programa_asignatura integer NOT NULL,
    fecha_asistencia timestamp without time zone NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu018_asistencias OWNER TO postgres;

--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 268



--
-- TOC entry 269 (class 1259 OID 58774)
-- Name: tbmu019_calificaciones; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu019_calificaciones (
    id_calificacion integer NOT NULL,
    id_alumno integer NOT NULL,
    id_programa_asignatura integer NOT NULL,
    id_ciclo_escolar integer NOT NULL,
    id_parcialidad integer NOT NULL,
    id_tipo_evaluacion integer NOT NULL,
    calificacion_original character varying(20),
    calificacion_homologada integer,
    ponderacion character varying(20),
    fecha_calificacion timestamp without time zone,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu019_calificaciones OWNER TO postgres;

--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 269



--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 269



--
-- TOC entry 270 (class 1259 OID 58777)
-- Name: tbmu020_alumno; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu020_alumno (
    id_alumno integer NOT NULL,
    tiene_discapacidad character(1) NOT NULL,
    id_discapacidad integer NOT NULL,
    id_estado_civil integer NOT NULL,
    indigena character(1) NOT NULL,
    id_lengua_materna integer NOT NULL,
    id_segunda_lengua integer NOT NULL,
    minoria character(1) NOT NULL,
    afrodescendiente character(1) NOT NULL,
    beca_academica character varying(150),
    beca_deportiva character varying(150),
    apoyo_social character(1) NOT NULL,
    id_aptitud_sobresal integer NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu020_alumno OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 58783)
-- Name: tbmu022_domicilio_persona; Type: TABLE; Schema: muses_dev; Owner: postgres
--

CREATE TABLE muses_dev.tbmu022_domicilio_persona (
    id_domicilio integer NOT NULL,
    id_persona integer NOT NULL,
    id_localidad integer NOT NULL,
    domicilio character varying(100) NOT NULL,
    codigo_postal character varying(5) NOT NULL,
    activo character(1) NOT NULL,
    fcreacion timestamp(6) without time zone NOT NULL,
    fmodificacion timestamp(6) without time zone,
    fbaja timestamp(6) without time zone
);


ALTER TABLE muses_dev.tbmu022_domicilio_persona OWNER TO postgres;

--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 271



--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 271



--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 271



--
-- TOC entry 3435 (class 2606 OID 58787)
-- Name: ctmu026_idioma_lengua ctm026_idioma_lengua_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu026_idioma_lengua
    ADD CONSTRAINT ctm026_idioma_lengua_pk PRIMARY KEY (id_idioma_lengua);


--
-- TOC entry 3437 (class 2606 OID 58789)
-- Name: ctmu027_origen_estudios ctm027_origen_estudios_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu027_origen_estudios
    ADD CONSTRAINT ctm027_origen_estudios_pk PRIMARY KEY (id_origen_estudios);


--
-- TOC entry 3395 (class 2606 OID 58791)
-- Name: ctmu001_tipo_periodo ctmu001_periodicidad_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu001_tipo_periodo
    ADD CONSTRAINT ctmu001_periodicidad_pk PRIMARY KEY (id_tipo_periodo);


--
-- TOC entry 3397 (class 2606 OID 58793)
-- Name: ctmu002_tipo_telefono ctmu002_tipo_telefono_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu002_tipo_telefono
    ADD CONSTRAINT ctmu002_tipo_telefono_pk PRIMARY KEY (id_tipo_telefono);


--
-- TOC entry 3399 (class 2606 OID 58795)
-- Name: ctmu003_sexo ctmu003_sexo_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu003_sexo
    ADD CONSTRAINT ctmu003_sexo_pk PRIMARY KEY (id_sexo);


--
-- TOC entry 3401 (class 2606 OID 58797)
-- Name: ctmu004_discapacidad ctmu004_discapacidad_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu004_discapacidad
    ADD CONSTRAINT ctmu004_discapacidad_pk PRIMARY KEY (id_discapacidad);


--
-- TOC entry 3403 (class 2606 OID 58799)
-- Name: ctmu006_estado_civil ctmu006_estado_civil_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu006_estado_civil
    ADD CONSTRAINT ctmu006_estado_civil_pk PRIMARY KEY (id_estado_civil);


--
-- TOC entry 3405 (class 2606 OID 58801)
-- Name: ctmu007_tipo_correo ctmu007_tipo_correo_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu007_tipo_correo
    ADD CONSTRAINT ctmu007_tipo_correo_pk PRIMARY KEY (id_tipo_correo);


--
-- TOC entry 3407 (class 2606 OID 58803)
-- Name: ctmu008_motivo_error ctmu008_motivo_error_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu008_motivo_error
    ADD CONSTRAINT ctmu008_motivo_error_pk PRIMARY KEY (id_motivo_error);


--
-- TOC entry 3409 (class 2606 OID 58805)
-- Name: ctmu009_subsistema ctmu008_subsistema_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu009_subsistema
    ADD CONSTRAINT ctmu008_subsistema_pk PRIMARY KEY (id_subsistema);


--
-- TOC entry 3411 (class 2606 OID 58807)
-- Name: ctmu010_tipo_subsistema ctmu010_tipo_subsistema_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu010_tipo_subsistema
    ADD CONSTRAINT ctmu010_tipo_subsistema_pk PRIMARY KEY (id_tipo_subsistema);


--
-- TOC entry 3413 (class 2606 OID 58809)
-- Name: ctmu011_estatus_procesamiento ctmu011_estatus_proc_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu011_estatus_procesamiento
    ADD CONSTRAINT ctmu011_estatus_proc_pk PRIMARY KEY (id_estatus_procesamiento);


--
-- TOC entry 3415 (class 2606 OID 58811)
-- Name: ctmu013_entidad_federativa ctmu013_entidad_federativa_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu013_entidad_federativa
    ADD CONSTRAINT ctmu013_entidad_federativa_pk PRIMARY KEY (id_entidad_federativa);


--
-- TOC entry 3417 (class 2606 OID 58813)
-- Name: ctmu014_estatus_inscripcion ctmu014_estatus_inscripcion_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu014_estatus_inscripcion
    ADD CONSTRAINT ctmu014_estatus_inscripcion_pk PRIMARY KEY (id_estatus_inscripcion);


--
-- TOC entry 3419 (class 2606 OID 58815)
-- Name: ctmu015_localidad ctmu015_localidad_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu015_localidad
    ADD CONSTRAINT ctmu015_localidad_pk PRIMARY KEY (id_localidad);


--
-- TOC entry 3421 (class 2606 OID 58817)
-- Name: ctmu016_municipio ctmu016_municipio_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu016_municipio
    ADD CONSTRAINT ctmu016_municipio_pk PRIMARY KEY (id_municipio);


--
-- TOC entry 3423 (class 2606 OID 58819)
-- Name: ctmu017_pais ctmu017_pais_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu017_pais
    ADD CONSTRAINT ctmu017_pais_pk PRIMARY KEY (id_pais);


--
-- TOC entry 3425 (class 2606 OID 58821)
-- Name: ctmu019_motivos_baja ctmu019_motivos_baja_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu019_motivos_baja
    ADD CONSTRAINT ctmu019_motivos_baja_pk PRIMARY KEY (id_motivo_baja);


--
-- TOC entry 3427 (class 2606 OID 58825)
-- Name: ctmu022_ciclo_escolar ctmu022_periodo_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu022_ciclo_escolar
    ADD CONSTRAINT ctmu022_periodo_pk PRIMARY KEY (id_ciclo_escolar);


--
-- TOC entry 3429 (class 2606 OID 58827)
-- Name: ctmu023_tipo_evaluacion ctmu023_tipo_evaluacion_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu023_tipo_evaluacion
    ADD CONSTRAINT ctmu023_tipo_evaluacion_pk PRIMARY KEY (id_tipo_evaluacion);


--
-- TOC entry 3431 (class 2606 OID 58829)
-- Name: ctmu024_parcialidad ctmu024_parcialidad_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu024_parcialidad
    ADD CONSTRAINT ctmu024_parcialidad_pk PRIMARY KEY (id_parcialidad);


--
-- TOC entry 3433 (class 2606 OID 58831)
-- Name: ctmu025_aptitud_sobresal ctmu025_aptitud_sobresal_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu025_aptitud_sobresal
    ADD CONSTRAINT ctmu025_aptitud_sobresal_pk PRIMARY KEY (id_aptitud_sobresal);


--
-- TOC entry 3439 (class 2606 OID 58833)
-- Name: ctmu028_tipo_documento ctmu028_tipo_documento_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu028_tipo_documento
    ADD CONSTRAINT ctmu028_tipo_documento_pk PRIMARY KEY (id_tipo_documento);


--
-- TOC entry 3441 (class 2606 OID 58835)
-- Name: ctmu029_grado ctmu029_grado_cursar_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu029_grado
    ADD CONSTRAINT ctmu029_grado_cursar_pk PRIMARY KEY (id_grado);


--
-- TOC entry 3443 (class 2606 OID 58837)
-- Name: ctmu030_modalidad_educativa ctmu030_modalidad_educativa_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu030_modalidad_educativa
    ADD CONSTRAINT ctmu030_modalidad_educativa_pk PRIMARY KEY (id_modalidad_educativa);


--
-- TOC entry 3445 (class 2606 OID 58839)
-- Name: ctmu030_opcion_educativa ctmu030_opcion_educativa_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu030_opcion_educativa
    ADD CONSTRAINT ctmu030_opcion_educativa_pk PRIMARY KEY (id_opcion_educativa);


--
-- TOC entry 3447 (class 2606 OID 58841)
-- Name: ctmu031_turno ctmu031_turno_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu031_turno
    ADD CONSTRAINT ctmu031_turno_pk PRIMARY KEY (id_turno);


--
-- TOC entry 3449 (class 2606 OID 58843)
-- Name: tbae001_inscripcion tbae001_inscripcion_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae001_inscripcion
    ADD CONSTRAINT tbae001_inscripcion_pk PRIMARY KEY (uuid);


--
-- TOC entry 3451 (class 2606 OID 58845)
-- Name: tbae001_inscripcion tbae001_inscripcion_un; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae001_inscripcion
    ADD CONSTRAINT tbae001_inscripcion_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3453 (class 2606 OID 58847)
-- Name: tbae002_bajas tbae002_bajas_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae002_bajas
    ADD CONSTRAINT tbae002_bajas_pk PRIMARY KEY (uuid);


--
-- TOC entry 3455 (class 2606 OID 58849)
-- Name: tbae002_bajas tbae002_bajas_un; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae002_bajas
    ADD CONSTRAINT tbae002_bajas_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3457 (class 2606 OID 58851)
-- Name: tbae005_asistencias tbae005_asistencias_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae005_asistencias
    ADD CONSTRAINT tbae005_asistencias_pk PRIMARY KEY (uuid);


--
-- TOC entry 3459 (class 2606 OID 58853)
-- Name: tbae005_asistencias tbae005_asistencias_un; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae005_asistencias
    ADD CONSTRAINT tbae005_asistencias_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3461 (class 2606 OID 58855)
-- Name: tbae007_calificaciones tbae007_calificaciones_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae007_calificaciones
    ADD CONSTRAINT tbae007_calificaciones_pk PRIMARY KEY (uuid);


--
-- TOC entry 3463 (class 2606 OID 58857)
-- Name: tbae007_calificaciones tbae007_calificaciones_un; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae007_calificaciones
    ADD CONSTRAINT tbae007_calificaciones_un UNIQUE (id_operacion_origen, id_subsistema, matricula_alumno);


--
-- TOC entry 3465 (class 2606 OID 58859)
-- Name: tbae009_respuesta tbae009_respuesta_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae009_respuesta
    ADD CONSTRAINT tbae009_respuesta_pk PRIMARY KEY (id_respuesta);


--
-- TOC entry 3467 (class 2606 OID 58861)
-- Name: tbae010_error tbmu001_error_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae010_error
    ADD CONSTRAINT tbmu001_error_pk PRIMARY KEY (id_error);


--
-- TOC entry 3469 (class 2606 OID 58863)
-- Name: tbmu002_persona tbmu002_persona_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu002_persona
    ADD CONSTRAINT tbmu002_persona_pk PRIMARY KEY (id_persona);


--
-- TOC entry 3471 (class 2606 OID 58865)
-- Name: tbmu003_correo tbmu003_correo_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu003_correo
    ADD CONSTRAINT tbmu003_correo_pk PRIMARY KEY (id_persona, id_tipo_correo);


--
-- TOC entry 3473 (class 2606 OID 58867)
-- Name: tbmu004_telefono tbmu004_telefono_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu004_telefono
    ADD CONSTRAINT tbmu004_telefono_pk PRIMARY KEY (id_tipo_telefono, id_persona);


--
-- TOC entry 3475 (class 2606 OID 58869)
-- Name: tbmu005_curp_historica tbmu005_curp_historica_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu005_curp_historica
    ADD CONSTRAINT tbmu005_curp_historica_pk PRIMARY KEY (id_persona, id_curp_historica);


--
-- TOC entry 3477 (class 2606 OID 58871)
-- Name: tbmu006_inscripcion tbmu006_inscripcion_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_inscripcion_pk PRIMARY KEY (id_inscripcion);


--
-- TOC entry 3479 (class 2606 OID 58873)
-- Name: tbmu007_programa_academico tbmu007_programa_academico_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu007_programa_academico
    ADD CONSTRAINT tbmu007_programa_academico_pk PRIMARY KEY (id_programa_academico);


--
-- TOC entry 3481 (class 2606 OID 58875)
-- Name: tbmu008_institucion_academica tbmu008_institucion_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu008_institucion_academica
    ADD CONSTRAINT tbmu008_institucion_pk PRIMARY KEY (id_institucion);


--
-- TOC entry 3483 (class 2606 OID 58877)
-- Name: tbmu009_programa_institucion tbmu009_prog_inst_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu009_programa_institucion
    ADD CONSTRAINT tbmu009_prog_inst_pk PRIMARY KEY (id_programa_institucion);


--
-- TOC entry 3485 (class 2606 OID 58879)
-- Name: tbmu010_asignaturas tbmu010_asignaturas_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu010_asignaturas
    ADD CONSTRAINT tbmu010_asignaturas_pk PRIMARY KEY (id_asignatura);


--
-- TOC entry 3487 (class 2606 OID 58881)
-- Name: tbmu011_competencias tbmu011_competencias_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu011_competencias
    ADD CONSTRAINT tbmu011_competencias_pk PRIMARY KEY (id_competencia);


--
-- TOC entry 3489 (class 2606 OID 58883)
-- Name: tbmu012_programa_asignatura tbmu012_programa_asignatura_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu012_programa_asignatura
    ADD CONSTRAINT tbmu012_programa_asignatura_pk PRIMARY KEY (id_programa_asignatura);


--
-- TOC entry 3491 (class 2606 OID 58885)
-- Name: tbmu013_bajas tbmu013_bajas_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu013_bajas
    ADD CONSTRAINT tbmu013_bajas_pk PRIMARY KEY (id_baja);


--
-- TOC entry 3493 (class 2606 OID 58887)
-- Name: tbmu014_rfc_historico tbmu014_rfc_historico_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu014_rfc_historico
    ADD CONSTRAINT tbmu014_rfc_historico_pk PRIMARY KEY (id_rfc_historico);


--
-- TOC entry 3495 (class 2606 OID 58889)
-- Name: tbmu015_docente_asignatura tbmu015_docente_asignatura_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu015_docente_asignatura
    ADD CONSTRAINT tbmu015_docente_asignatura_pk PRIMARY KEY (id_docente_asignatura);


--
-- TOC entry 3497 (class 2606 OID 58891)
-- Name: tbmu016_docente tbmu016_docente_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu016_docente
    ADD CONSTRAINT tbmu016_docente_pk PRIMARY KEY (id_docente);


--
-- TOC entry 3499 (class 2606 OID 58895)
-- Name: tbmu018_asistencias tbmu018_asistencias_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu018_asistencias
    ADD CONSTRAINT tbmu018_asistencias_pk PRIMARY KEY (id_asistencia);


--
-- TOC entry 3501 (class 2606 OID 58897)
-- Name: tbmu019_calificaciones tbmu019_calificaciones_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_calificaciones_pk PRIMARY KEY (id_calificacion);


--
-- TOC entry 3503 (class 2606 OID 58899)
-- Name: tbmu020_alumno tbmu020_alumno_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_alumno_pk PRIMARY KEY (id_alumno);


--
-- TOC entry 3505 (class 2606 OID 58903)
-- Name: tbmu022_domicilio_persona tbmu022_domicilio_persona_pk; Type: CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu022_domicilio_persona
    ADD CONSTRAINT tbmu022_domicilio_persona_pk PRIMARY KEY (id_domicilio);


--
-- TOC entry 3506 (class 2606 OID 58905)
-- Name: ctmu009_subsistema ctmu009_ctmu010_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu009_subsistema
    ADD CONSTRAINT ctmu009_ctmu010_fk FOREIGN KEY (id_tipo_subsistema) REFERENCES muses_dev.ctmu010_tipo_subsistema(id_tipo_subsistema);


--
-- TOC entry 3507 (class 2606 OID 58910)
-- Name: ctmu013_entidad_federativa ctmu013_ctmu017_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu013_entidad_federativa
    ADD CONSTRAINT ctmu013_ctmu017_fk FOREIGN KEY (id_pais) REFERENCES muses_dev.ctmu017_pais(id_pais);


--
-- TOC entry 3508 (class 2606 OID 58915)
-- Name: ctmu015_localidad ctmu015_ctmu016_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu015_localidad
    ADD CONSTRAINT ctmu015_ctmu016_fk FOREIGN KEY (id_municipio) REFERENCES muses_dev.ctmu016_municipio(id_municipio);


--
-- TOC entry 3509 (class 2606 OID 58920)
-- Name: ctmu016_municipio ctmu016_ctmu013_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu016_municipio
    ADD CONSTRAINT ctmu016_ctmu013_fk FOREIGN KEY (id_entidad_federativa) REFERENCES muses_dev.ctmu013_entidad_federativa(id_entidad_federativa);


--
-- TOC entry 3510 (class 2606 OID 58925)
-- Name: ctmu030_opcion_educativa ctmu030_ctmu030_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.ctmu030_opcion_educativa
    ADD CONSTRAINT ctmu030_ctmu030_fk FOREIGN KEY (id_modalidad_educativa) REFERENCES muses_dev.ctmu030_modalidad_educativa(id_modalidad_educativa);


--
-- TOC entry 3511 (class 2606 OID 58930)
-- Name: tbae001_inscripcion tbae001_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae001_inscripcion
    ADD CONSTRAINT tbae001_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3512 (class 2606 OID 58935)
-- Name: tbae001_inscripcion tbae001_ctmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae001_inscripcion
    ADD CONSTRAINT tbae001_ctmu011_fk FOREIGN KEY (id_estatus_procesamiento) REFERENCES muses_dev.ctmu011_estatus_procesamiento(id_estatus_procesamiento);


--
-- TOC entry 3513 (class 2606 OID 58940)
-- Name: tbae002_bajas tbae002_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae002_bajas
    ADD CONSTRAINT tbae002_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3514 (class 2606 OID 58945)
-- Name: tbae002_bajas tbae002_ctmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae002_bajas
    ADD CONSTRAINT tbae002_ctmu011_fk FOREIGN KEY (id_estatus_procesamiento) REFERENCES muses_dev.ctmu011_estatus_procesamiento(id_estatus_procesamiento);


--
-- TOC entry 3515 (class 2606 OID 58950)
-- Name: tbae005_asistencias tbae005_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae005_asistencias
    ADD CONSTRAINT tbae005_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3516 (class 2606 OID 58955)
-- Name: tbae005_asistencias tbae005_ctmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae005_asistencias
    ADD CONSTRAINT tbae005_ctmu011_fk FOREIGN KEY (id_estatus_procesamiento) REFERENCES muses_dev.ctmu011_estatus_procesamiento(id_estatus_procesamiento);


--
-- TOC entry 3517 (class 2606 OID 58960)
-- Name: tbae007_calificaciones tbae007_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae007_calificaciones
    ADD CONSTRAINT tbae007_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3518 (class 2606 OID 58965)
-- Name: tbae007_calificaciones tbae007_ctmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae007_calificaciones
    ADD CONSTRAINT tbae007_ctmu011_fk FOREIGN KEY (id_estatus_procesamiento) REFERENCES muses_dev.ctmu011_estatus_procesamiento(id_estatus_procesamiento);


--
-- TOC entry 3519 (class 2606 OID 58970)
-- Name: tbae009_respuesta tbae009_ctmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae009_respuesta
    ADD CONSTRAINT tbae009_ctmu011_fk FOREIGN KEY (id_estatus_procesamiento) REFERENCES muses_dev.ctmu011_estatus_procesamiento(id_estatus_procesamiento);


--
-- TOC entry 3520 (class 2606 OID 58975)
-- Name: tbae010_error tbmu001_ctmu008_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae010_error
    ADD CONSTRAINT tbmu001_ctmu008_fk FOREIGN KEY (id_motivo_error) REFERENCES muses_dev.ctmu008_motivo_error(id_motivo_error);


--
-- TOC entry 3521 (class 2606 OID 58980)
-- Name: tbae010_error tbmu001_tbae009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbae010_error
    ADD CONSTRAINT tbmu001_tbae009_fk FOREIGN KEY (id_respuesta) REFERENCES muses_dev.tbae009_respuesta(id_respuesta);


--
-- TOC entry 3522 (class 2606 OID 58985)
-- Name: tbmu002_persona tbmu002_ctmu003_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu002_persona
    ADD CONSTRAINT tbmu002_ctmu003_fk FOREIGN KEY (id_sexo) REFERENCES muses_dev.ctmu003_sexo(id_sexo);


--
-- TOC entry 3523 (class 2606 OID 58990)
-- Name: tbmu002_persona tbmu002_ctmu013_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu002_persona
    ADD CONSTRAINT tbmu002_ctmu013_fk FOREIGN KEY (id_entidad_federativa_n) REFERENCES muses_dev.ctmu013_entidad_federativa(id_entidad_federativa);


--
-- TOC entry 3528 (class 2606 OID 58995)
-- Name: tbmu005_curp_historica tbmu005_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu005_curp_historica
    ADD CONSTRAINT tbmu005_tbmu002_fk FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3529 (class 2606 OID 59000)
-- Name: tbmu006_inscripcion tbmu006_ctmu001_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu001_fk FOREIGN KEY (id_tipo_periodo) REFERENCES muses_dev.ctmu001_tipo_periodo(id_tipo_periodo);


--
-- TOC entry 3530 (class 2606 OID 59005)
-- Name: tbmu006_inscripcion tbmu006_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3531 (class 2606 OID 59010)
-- Name: tbmu006_inscripcion tbmu006_ctmu014_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu014_fk FOREIGN KEY (id_estatus_inscripcion) REFERENCES muses_dev.ctmu014_estatus_inscripcion(id_estatus_inscripcion);


--
-- TOC entry 3532 (class 2606 OID 59015)
-- Name: tbmu006_inscripcion tbmu006_ctmu022_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu022_fk FOREIGN KEY (id_ciclo_escolar) REFERENCES muses_dev.ctmu022_ciclo_escolar(id_ciclo_escolar);


--
-- TOC entry 3533 (class 2606 OID 59020)
-- Name: tbmu006_inscripcion tbmu006_ctmu027_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu027_fk FOREIGN KEY (id_origen_estudios) REFERENCES muses_dev.ctmu027_origen_estudios(id_origen_estudios);


--
-- TOC entry 3534 (class 2606 OID 59025)
-- Name: tbmu006_inscripcion tbmu006_ctmu028_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu028_fk FOREIGN KEY (id_tipo_documento) REFERENCES muses_dev.ctmu028_tipo_documento(id_tipo_documento);


--
-- TOC entry 3535 (class 2606 OID 59030)
-- Name: tbmu006_inscripcion tbmu006_ctmu029_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu029_fk FOREIGN KEY (id_grado) REFERENCES muses_dev.ctmu029_grado(id_grado);


--
-- TOC entry 3536 (class 2606 OID 59035)
-- Name: tbmu006_inscripcion tbmu006_ctmu031_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_ctmu031_fk FOREIGN KEY (id_turno) REFERENCES muses_dev.ctmu031_turno(id_turno);


--
-- TOC entry 3537 (class 2606 OID 59040)
-- Name: tbmu006_inscripcion tbmu006_tbmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_tbmu009_fk FOREIGN KEY (id_programa_institucion) REFERENCES muses_dev.tbmu009_programa_institucion(id_programa_institucion);


--
-- TOC entry 3538 (class 2606 OID 59045)
-- Name: tbmu006_inscripcion tbmu006_tbmu020_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu006_inscripcion
    ADD CONSTRAINT tbmu006_tbmu020_fk FOREIGN KEY (id_alumno) REFERENCES muses_dev.tbmu020_alumno(id_alumno);


--
-- TOC entry 3539 (class 2606 OID 59055)
-- Name: tbmu007_programa_academico tbmu007_ctmu001_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu007_programa_academico
    ADD CONSTRAINT tbmu007_ctmu001_fk FOREIGN KEY (id_periodicidad) REFERENCES muses_dev.ctmu001_tipo_periodo(id_tipo_periodo);


--
-- TOC entry 3540 (class 2606 OID 59060)
-- Name: tbmu007_programa_academico tbmu007_tbmu011_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu007_programa_academico
    ADD CONSTRAINT tbmu007_tbmu011_fk FOREIGN KEY (id_competencia) REFERENCES muses_dev.tbmu011_competencias(id_competencia);


--
-- TOC entry 3541 (class 2606 OID 59065)
-- Name: tbmu009_programa_institucion tbmu009_ctmu030_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu009_programa_institucion
    ADD CONSTRAINT tbmu009_ctmu030_fk FOREIGN KEY (id_opcion_educativa) REFERENCES muses_dev.ctmu030_opcion_educativa(id_opcion_educativa);


--
-- TOC entry 3542 (class 2606 OID 59070)
-- Name: tbmu009_programa_institucion tbmu009_tbmu007_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu009_programa_institucion
    ADD CONSTRAINT tbmu009_tbmu007_fk FOREIGN KEY (id_programa_academico) REFERENCES muses_dev.tbmu007_programa_academico(id_programa_academico);


--
-- TOC entry 3543 (class 2606 OID 59075)
-- Name: tbmu009_programa_institucion tbmu009_tbmu008_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu009_programa_institucion
    ADD CONSTRAINT tbmu009_tbmu008_fk FOREIGN KEY (id_institucion) REFERENCES muses_dev.tbmu008_institucion_academica(id_institucion);


--
-- TOC entry 3544 (class 2606 OID 59080)
-- Name: tbmu012_programa_asignatura tbmu012_tbmu007_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu012_programa_asignatura
    ADD CONSTRAINT tbmu012_tbmu007_fk FOREIGN KEY (id_programa_academico) REFERENCES muses_dev.tbmu007_programa_academico(id_programa_academico);


--
-- TOC entry 3545 (class 2606 OID 59085)
-- Name: tbmu012_programa_asignatura tbmu012_tbmu010_pk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu012_programa_asignatura
    ADD CONSTRAINT tbmu012_tbmu010_pk FOREIGN KEY (id_asignatura) REFERENCES muses_dev.tbmu010_asignaturas(id_asignatura);


--
-- TOC entry 3526 (class 2606 OID 59090)
-- Name: tbmu004_telefono tbmu013_ctmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu004_telefono
    ADD CONSTRAINT tbmu013_ctmu002_fk FOREIGN KEY (id_tipo_telefono) REFERENCES muses_dev.ctmu002_tipo_telefono(id_tipo_telefono);


--
-- TOC entry 3546 (class 2606 OID 59095)
-- Name: tbmu013_bajas tbmu013_ctmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu013_bajas
    ADD CONSTRAINT tbmu013_ctmu009_fk FOREIGN KEY (id_subsistema) REFERENCES muses_dev.ctmu009_subsistema(id_subsistema);


--
-- TOC entry 3547 (class 2606 OID 59100)
-- Name: tbmu013_bajas tbmu013_ctmu019_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu013_bajas
    ADD CONSTRAINT tbmu013_ctmu019_fk FOREIGN KEY (id_motivo_baja) REFERENCES muses_dev.ctmu019_motivos_baja(id_motivo_baja);


--
-- TOC entry 3548 (class 2606 OID 59105)
-- Name: tbmu013_bajas tbmu013_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu013_bajas
    ADD CONSTRAINT tbmu013_tbmu002_fk FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3527 (class 2606 OID 59110)
-- Name: tbmu004_telefono tbmu013_tbmu002_fkv2; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu004_telefono
    ADD CONSTRAINT tbmu013_tbmu002_fkv2 FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3549 (class 2606 OID 59115)
-- Name: tbmu013_bajas tbmu013_tbmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu013_bajas
    ADD CONSTRAINT tbmu013_tbmu009_fk FOREIGN KEY (id_programa_institucion) REFERENCES muses_dev.tbmu009_programa_institucion(id_programa_institucion);


--
-- TOC entry 3550 (class 2606 OID 59120)
-- Name: tbmu014_rfc_historico tbmu014_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu014_rfc_historico
    ADD CONSTRAINT tbmu014_tbmu002_fk FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3551 (class 2606 OID 59125)
-- Name: tbmu015_docente_asignatura tbmu015_ctmu022_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu015_docente_asignatura
    ADD CONSTRAINT tbmu015_ctmu022_fk FOREIGN KEY (id_ciclo_escolar) REFERENCES muses_dev.ctmu022_ciclo_escolar(id_ciclo_escolar);


--
-- TOC entry 3552 (class 2606 OID 59130)
-- Name: tbmu015_docente_asignatura tbmu015_tbmu009_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu015_docente_asignatura
    ADD CONSTRAINT tbmu015_tbmu009_fk FOREIGN KEY (id_programa_institucion) REFERENCES muses_dev.tbmu009_programa_institucion(id_programa_institucion);


--
-- TOC entry 3553 (class 2606 OID 59135)
-- Name: tbmu015_docente_asignatura tbmu015_tbmu012_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu015_docente_asignatura
    ADD CONSTRAINT tbmu015_tbmu012_fk FOREIGN KEY (id_programa_asignatura) REFERENCES muses_dev.tbmu012_programa_asignatura(id_programa_asignatura);


--
-- TOC entry 3554 (class 2606 OID 59140)
-- Name: tbmu015_docente_asignatura tbmu015_tbmu016_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu015_docente_asignatura
    ADD CONSTRAINT tbmu015_tbmu016_fk FOREIGN KEY (id_docente) REFERENCES muses_dev.tbmu016_docente(id_docente);


--
-- TOC entry 3555 (class 2606 OID 59145)
-- Name: tbmu016_docente tbmu016_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu016_docente
    ADD CONSTRAINT tbmu016_tbmu002_fk FOREIGN KEY (id_docente) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3524 (class 2606 OID 59165)
-- Name: tbmu003_correo tbmu018_ctmu007_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu003_correo
    ADD CONSTRAINT tbmu018_ctmu007_fk FOREIGN KEY (id_tipo_correo) REFERENCES muses_dev.ctmu007_tipo_correo(id_tipo_correo);


--
-- TOC entry 3525 (class 2606 OID 59170)
-- Name: tbmu003_correo tbmu018_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu003_correo
    ADD CONSTRAINT tbmu018_tbmu002_fk FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3556 (class 2606 OID 59175)
-- Name: tbmu018_asistencias tbmu018_tbmu002_fkv2; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu018_asistencias
    ADD CONSTRAINT tbmu018_tbmu002_fkv2 FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3557 (class 2606 OID 59180)
-- Name: tbmu018_asistencias tbmu018_tbmu012_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu018_asistencias
    ADD CONSTRAINT tbmu018_tbmu012_fk FOREIGN KEY (id_programa_asignatura) REFERENCES muses_dev.tbmu012_programa_asignatura(id_programa_asignatura);


--
-- TOC entry 3558 (class 2606 OID 59185)
-- Name: tbmu019_calificaciones tbmu019_ctmu022_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_ctmu022_fk FOREIGN KEY (id_ciclo_escolar) REFERENCES muses_dev.ctmu022_ciclo_escolar(id_ciclo_escolar);


--
-- TOC entry 3559 (class 2606 OID 59190)
-- Name: tbmu019_calificaciones tbmu019_ctmu023_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_ctmu023_fk FOREIGN KEY (id_tipo_evaluacion) REFERENCES muses_dev.ctmu023_tipo_evaluacion(id_tipo_evaluacion);


--
-- TOC entry 3560 (class 2606 OID 59195)
-- Name: tbmu019_calificaciones tbmu019_ctmu024_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_ctmu024_fk FOREIGN KEY (id_parcialidad) REFERENCES muses_dev.ctmu024_parcialidad(id_parcialidad);


--
-- TOC entry 3561 (class 2606 OID 59200)
-- Name: tbmu019_calificaciones tbmu019_tbmu012_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_tbmu012_fk FOREIGN KEY (id_programa_asignatura) REFERENCES muses_dev.tbmu012_programa_asignatura(id_programa_asignatura);


--
-- TOC entry 3562 (class 2606 OID 59205)
-- Name: tbmu019_calificaciones tbmu019_tbmu020_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu019_calificaciones
    ADD CONSTRAINT tbmu019_tbmu020_fk FOREIGN KEY (id_alumno) REFERENCES muses_dev.tbmu020_alumno(id_alumno);


--
-- TOC entry 3563 (class 2606 OID 59210)
-- Name: tbmu020_alumno tbmu020_ctmu004_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_ctmu004_fk FOREIGN KEY (id_discapacidad) REFERENCES muses_dev.ctmu004_discapacidad(id_discapacidad);


--
-- TOC entry 3564 (class 2606 OID 59215)
-- Name: tbmu020_alumno tbmu020_ctmu006_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_ctmu006_fk FOREIGN KEY (id_estado_civil) REFERENCES muses_dev.ctmu006_estado_civil(id_estado_civil);


--
-- TOC entry 3565 (class 2606 OID 59220)
-- Name: tbmu020_alumno tbmu020_ctmu025_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_ctmu025_fk FOREIGN KEY (id_aptitud_sobresal) REFERENCES muses_dev.ctmu025_aptitud_sobresal(id_aptitud_sobresal);


--
-- TOC entry 3566 (class 2606 OID 59225)
-- Name: tbmu020_alumno tbmu020_ctmu026_2_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_ctmu026_2_fk FOREIGN KEY (id_segunda_lengua) REFERENCES muses_dev.ctmu026_idioma_lengua(id_idioma_lengua);


--
-- TOC entry 3567 (class 2606 OID 59230)
-- Name: tbmu020_alumno tbmu020_ctmu026_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_ctmu026_fk FOREIGN KEY (id_lengua_materna) REFERENCES muses_dev.ctmu026_idioma_lengua(id_idioma_lengua);


--
-- TOC entry 3568 (class 2606 OID 59235)
-- Name: tbmu020_alumno tbmu020_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu020_alumno
    ADD CONSTRAINT tbmu020_tbmu002_fk FOREIGN KEY (id_alumno) REFERENCES muses_dev.tbmu002_persona(id_persona);


--
-- TOC entry 3569 (class 2606 OID 59265)
-- Name: tbmu022_domicilio_persona tbmu022_ctmu015_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu022_domicilio_persona
    ADD CONSTRAINT tbmu022_ctmu015_fk FOREIGN KEY (id_localidad) REFERENCES muses_dev.ctmu015_localidad(id_localidad);


--
-- TOC entry 3570 (class 2606 OID 59270)
-- Name: tbmu022_domicilio_persona tbmu022_tbmu002_fk; Type: FK CONSTRAINT; Schema: muses_dev; Owner: postgres
--

ALTER TABLE ONLY muses_dev.tbmu022_domicilio_persona
    ADD CONSTRAINT tbmu022_tbmu002_fk FOREIGN KEY (id_persona) REFERENCES muses_dev.tbmu002_persona(id_persona);



-- =============================================================
-- Comentarios de Tablas y Columnas (Generados Automáticamente)
-- =============================================================

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

-- Completed on 2025-10-09 13:10:16

--
-- PostgreSQL database dump complete
--

\unrestrict XEwOw2IT3TAgLUUGEst4WqXT66gkoSgJ6dAabV2oRskCYwyLtN5Rfh8EhV9vAjY

