# Casos de Uso Detallados del Formulario de Inscripción (Registro por Registro)

Este documento descompone el caso de uso **CU-001 Registrar Inscripción** en registros operativos específicos del formulario de captura, tomando como referencia los lineamientos normativos y técnicos descritos en la documentación del proyecto SIGED interoperable. Cada registro representa una sección funcional del formulario y detalla actores, datos requeridos, validaciones y flujos principales.

---

## Registro 1. Identificación de la persona estudiante

- **Propósito:** Capturar y validar la identidad única del estudiante que será inscrito.
- **Actor primario:** Personal de control escolar del centro de trabajo.
- **Actores secundarios:** Servicio CURP RENAPO (validación en línea), Gateway Nacional SIGED.

### Datos y validaciones

| Campo | Descripción | Validación / Regla | Catálogo o servicio asociado |
| --- | --- | --- | --- |
| CURP | Clave Única de Registro de Población de 18 caracteres | Debe existir y estar vigente en RENAPO. Validación estructural previa al envío | RENAPO (consulta en línea) |
| Primer apellido | Apellido paterno del estudiante | Obligatorio, caracteres alfabéticos, coincide con CURP | Reglas de nombre internas |
| Segundo apellido | Apellido materno | Opcional según CURP, caracteres alfabéticos | Reglas de nombre internas |
| Nombre(s) | Nombre o nombres del estudiante | Obligatorio, caracteres alfabéticos | Reglas de nombre internas |
| Fecha de nacimiento | Fecha en formato ISO (AAAA-MM-DD) | Debe ser coherente con CURP y no mayor a la fecha actual | Regla de consistencia CURP |
| Sexo | Valor M/F derivado de CURP | Debe coincidir con posición 11 de la CURP | Regla de consistencia CURP |

### Flujo principal

1. El personal captura la CURP y datos de identidad en el formulario local.
2. El sistema local valida la estructura de la CURP y la coherencia de los datos auxiliares (nombre, sexo, fecha).
3. Se consulta el servicio RENAPO para confirmar la vigencia de la CURP.
4. Con la validación exitosa, se habilita el avance al siguiente registro del formulario.
5. Al enviar el evento al Gateway SIGED, se replica la validación estructural y se genera el UUID del evento si todo es correcto.

### Flujos alternativos

- **CURP inexistente o inválida:** se notifica al usuario y se impide continuar hasta corregirla.
- **Datos auxiliares no coincidentes con la CURP:** se solicita ajustar nombre, sexo o fecha antes de continuar.

---

## Registro 2. Identificación del centro de trabajo y programa educativo

- **Propósito:** Asociar la inscripción a un centro de trabajo (CCT) y programa académico válidos.
- **Actor primario:** Personal de control escolar.
- **Actores secundarios:** Catálogo nacional de CCT, catálogos INEGI de ubicación, catálogos DGAIR de nivel/modalidad.

### Datos y validaciones

| Campo | Descripción | Validación / Regla | Catálogo o servicio asociado |
| --- | --- | --- | --- |
| CCT | Clave del Centro de Trabajo (11 caracteres) | Debe existir, estar activo y corresponder al centro emisor | Catálogo nacional de CCT |
| Nombre del plantel | Denominación oficial del centro | Autocompletado a partir del CCT válido | Catálogo nacional de CCT |
| Entidad federativa | Estado donde opera el plantel | Debe coincidir con la ubicación registrada del CCT | Catálogo INEGI de entidades |
| Municipio / Alcaldía | Municipio asociado | Debe coincidir con la ubicación registrada del CCT | Catálogo INEGI de municipios |
| Localidad | Localidad del plantel | Validación contra catálogo vigente | Catálogo INEGI de localidades |
| Nivel educativo | Licenciatura, Técnico Superior, etc. | Selección conforme a catálogo DGAIR | Catálogo de niveles/modalidades |
| Modalidad | Escolarizada, no escolarizada, mixta | Selección conforme a catálogo vigente | Catálogo de niveles/modalidades |
| Programa educativo | Carrera o plan académico | Debe existir y estar activo para el CCT | Catálogo interno estatal |

### Flujo principal

1. Tras validar la CURP, el sistema solicita el CCT del plantel que emite la inscripción.
2. Se valida el CCT contra el catálogo nacional y se autopuebla la información del plantel.
3. El usuario selecciona nivel, modalidad y programa conforme a catálogos homologados.
4. El sistema verifica que el programa esté autorizado para el CCT y modalidad seleccionados.
5. Se almacena el conjunto de datos y se habilita el siguiente registro.

### Flujos alternativos

- **CCT inactivo o inexistente:** el sistema notifica y bloquea el envío del formulario.
- **Programa no autorizado:** se solicita seleccionar un programa válido según catálogos vigentes.

---

## Registro 3. Datos administrativos de la inscripción

- **Propósito:** Capturar la información del evento administrativo de inscripción para el ciclo escolar correspondiente.
- **Actor primario:** Personal de control escolar.
- **Actores secundarios:** Catálogo de ciclos escolares, reglas técnicas del SIGED.

### Datos y validaciones

| Campo | Descripción | Validación / Regla | Catálogo o servicio asociado |
| --- | --- | --- | --- |
| Ciclo escolar | Periodo oficial (p. ej. 2025-2026) | Debe existir en el catálogo vigente y estar abierto para inscripción | Catálogo nacional de ciclos |
| Periodo / Semestre | Identificador del periodo dentro del ciclo | Selección conforme a catálogo local homologado | Catálogo estatal homologado |
| Fecha de inscripción | Fecha efectiva de alta | No puede ser futura ni anterior al inicio del ciclo | Regla temporal SIGED |
| Tipo de movimiento | Alta inicial, reinscripción, cambio de programa | Valor permitido por reglas técnicas | Catálogo de tipos de evento |
| Origen de la solicitud | Presencial, ventanilla digital, integración masiva | Valores prefijados para trazabilidad | Catálogo de canales |
| Turno | Matutino, vespertino, mixto | Consistente con oferta del CCT | Catálogo del plantel |
| Matrícula interna | Identificador local del estudiante | Único por CCT y programa dentro del ciclo | Regla de unicidad local |

### Flujo principal

1. El usuario selecciona el ciclo y periodo vigentes para la inscripción.
2. El sistema valida que la fecha de inscripción se encuentre dentro del ciclo y que el tipo de movimiento sea permitido.
3. Se registran datos complementarios (turno, canal, matrícula interna) para trazabilidad local.
4. El sistema consolida la estructura del evento conforme al esquema JSON requerido por el Gateway SIGED.
5. Con todas las validaciones superadas, el registro queda listo para enviarse al módulo de confirmación.

### Flujos alternativos

- **Ciclo no vigente o cerrado:** el sistema bloquea la captura y solicita seleccionar un ciclo válido.
- **Fecha fuera de rango:** se notifica al usuario para corregir la fecha antes de continuar.

---

## Registro 4. Confirmación y trazabilidad del evento

- **Propósito:** Validar la transmisión al SIGED y conservar la evidencia oficial del registro administrativo.
- **Actor primario:** Sistema escolar estatal/local.
- **Actores secundarios:** Gateway Nacional SIGED, servicios de autenticación DGTIC.

### Datos y validaciones

| Campo | Descripción | Validación / Regla | Catálogo o servicio asociado |
| --- | --- | --- | --- |
| API Key / Token JWT | Credenciales del sistema emisor | Deben ser válidas y vigentes para invocar la API | Servicio de autenticación DGTIC |
| UUID del evento | Identificador único generado tras aceptación | Debe recibirse en el acuse y almacenarse íntegramente | Gateway Nacional SIGED |
| Sello de tiempo | Timestamp de aceptación | Debe provenir del SIGED y conservarse sin alteraciones | Gateway Nacional SIGED |
| Estatus del evento | Aceptado, Aceptado con error, Rechazado | Registro obligatorio para gestión posterior | Motor de validación SIGED |
| Acuse digital | Documento o payload de confirmación | Debe guardarse como evidencia normativa | Sistema local de control escolar |
| Observaciones / errores | Mensajes de retroalimentación | Se registran para seguimiento y corrección | Bitácora local |

### Flujo principal

1. El sistema arma el payload final con los registros previos y autentica la petición mediante API Key y token JWT válidos.
2. Se envía el evento de inscripción al Gateway Nacional SIGED mediante la API REST oficial.
3. El Gateway valida estructura, catálogos y reglas de negocio; si todo es correcto genera UUID, sello de tiempo y acuse.
4. El sistema local almacena el acuse y los metadatos (UUID, estatus, sello de tiempo) para auditoría y seguimiento.
5. Se presenta al usuario la confirmación de registro exitoso o los errores a corregir.

### Flujos alternativos

- **Error de autenticación:** la API rechaza la petición y se solicita renovar credenciales.
- **Rechazo por validación:** el Gateway devuelve errores específicos; el sistema local mantiene el registro en estado pendiente hasta su corrección.

---

## Consideraciones transversales

- Todo registro debe respetar las reglas técnicas federales publicadas por la SEP, incluyendo validaciones en origen y uso de catálogos homologados.
- La captura puede realizarse registro por registro o mediante carga masiva; en ambos casos se aplican las mismas validaciones estructurales y semánticas.
- La evidencia del acuse con UUID es necesaria para desencadenar procesos subsecuentes (evaluaciones, certificados, bajas).
