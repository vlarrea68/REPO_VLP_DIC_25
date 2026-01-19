# Diseño de arquitectura para el módulo de inscripción

## 1. Propósito y relación con la arquitectura global
Este documento aterriza las decisiones de arquitectura específicas para el módulo de inscripción y amplía los lineamientos definidos en el documento maestro de **[Arquitectura Detallada del Frontend](../../docs/arquitectura_detallada_frontend.md)**. Sirve como un caso de estudio práctico de cómo se aplican los patrones generales al flujo de negocio de "Inscripción".

## 2. Alcance funcional
El diseño cubre la solución web necesaria para:
1. Capturar inscripciones individuales con validaciones en tiempo real.
2. Importar inscripciones de forma masiva mediante archivos CSV alineados al `bd/layout_V01.md`, que concentra la definición oficial de campos, máscaras y catálogos.【F:bd/layout_V01.md†L1-L58】
3. Administrar catálogos, reglas de negocio y persistencia de información derivada de ambos flujos.

## 3. Visión arquitectónica específica del módulo
### 3.1 Front-end Angular
- **Feature module dedicado**: `InscripcionesModule` encapsula formulario, carga masiva y componentes reutilizables para catálogos y bitácoras, integrándose con los componentes descritos en `muses_web_diseno_componentes.md`.
- **Estado compartido**: servicios basados en signals coordinan progreso, filtros y almacenamiento local de lotes importados, manteniendo sincronía con `localStorage` para reanudaciones.
- **Validación en origen**: el front-end verifica estructura de archivos CSV, encabezados obligatorios y formatos básicos antes de delegar reglas de negocio al back-end.

### 3.2 Servicios de aplicación (back-end/API)
- **API REST**: endpoints `POST /inscripciones/manual` y `POST /inscripciones/masiva` procesan los dos flujos. El servicio masivo orquesta trabajos en segundo plano para lotes grandes y expone actualizaciones de progreso.
- **Reglas centralizadas**: validadores reutilizables garantizan coherencia con el diccionario de campos y permiten compartir lógica con otros módulos (bajas, evaluaciones).
- **Orquestación de catálogos**: servicios dedicados sincronizan catálogos oficiales (RENAPO, INEGI, DGP) y publican versiones consumibles para el front-end.

### 3.3 Dominio y datos
- **Modelos de dominio**: entidades como `Alumno`, `Inscripcion`, `Trayectoria` y `BitacoraCarga` encapsulan reglas de consistencia y evitan duplicidades.
- **Persistencia**: base de datos relacional (PostgreSQL) con tablas para estudiantes, eventos de inscripción, catálogos y log de importaciones. Los archivos originales y reportes de errores se almacenan en un bucket seguro (S3/Azure Blob).

## 4. Flujos clave
### 4.1 Inscripción manual
1. El usuario autenticado captura la información del alumno en el formulario.
2. El front-end valida formato y catálogos obligatorios y envía la solicitud al API.
3. El back-end ejecuta validaciones de negocio, registra la inscripción, genera folio y devuelve acuse.
4. Se persisten los datos y se actualizan bitácoras de auditoría.

### 4.2 Inscripción masiva (CSV)
1. El usuario carga el archivo CSV y confirma el procesamiento.
2. El front-end valida encabezados, muestra metadatos y envía el archivo al servicio masivo.
3. El proceso en segundo plano valida estructura y reglas de negocio, notificando avances por lotes.
4. Se generan resultados por registro (aceptados/rechazados) y una bitácora consultable desde la UI.
5. Los registros válidos se almacenan en base de datos y los errores se conservan para seguimiento.

## 5. Integraciones y catálogos
- **Catálogos institucionales**: planteles, carreras, modalidades y turnos se sincronizan mediante jobs programados y se sirven vía APIs cacheables.
- **Servicios externos**: RENAPO para validar CURP, catálogos INEGI para entidad/municipio/localidad y, de forma opcional, servicios de notificación.
- **Versionamiento**: cada catálogo mantiene metadatos de versión y vigencia para garantizar trazabilidad en los acuses enviados a SIGED.

## 6. Seguridad y atributos de calidad
- **Autenticación y autorización**: integración con Keycloak/JWT, roles diferenciados (capturista, supervisor, administrador) y guardas de ruta en el front-end.
- **Disponibilidad**: establecer SLO/SLA para ventanas de captura y capacidad de reanudar cargas masivas cuando falle la red.
- **Escalabilidad y rendimiento**: colas de procesamiento y web workers permiten manejar lotes grandes sin bloquear la UI.
- **Observabilidad**: registro de métricas, tiempos de procesamiento y errores por campo para análisis posterior.
- **Cumplimiento normativo**: cifrado en tránsito y reposo, almacenamiento de acuses y bitácoras para auditorías.

## 7. Artefactos complementarios
- **Diagrama de contexto**: interacción entre usuarios, front-end, back-end y servicios externos.
- **Diagrama de componentes**: relación entre formulario, cargador CSV, validadores, servicios y repositorios.
- **Diagrama de despliegue**: entornos (dev/qa/prod), servicios gestionados y mecanismos de entrega continua.
- **Plan de migración de datos**: estrategia para importar históricos o sincronizar con sistemas heredados.
- **Plan de pruebas**: matrices funcionales y no funcionales alineadas a los casos de uso documentados.

## 8. Relación con la documentación existente
- Los casos de uso en `web/documentos/casos_de_uso/inscripcion/` definen comportamiento esperado y alimentan reglas de negocio.
- El `inscripcion_diccionario_campos.md` y `inscripcion_reglas_validacion.md` son la referencia para construir modelos, validadores y mensajes de error.
- `inscripcion_catalogos_referenciados.md` identifica la dependencia de catálogos y evita duplicar listados que ya están en `bd/layout_V01.md`.
