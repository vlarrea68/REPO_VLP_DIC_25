# Catálogos referenciados por el módulo de inscripción y bajas

Los catálogos listados a continuación se mencionan explícitamente en el `bd/layout_V01.md`. Esta tabla resume qué campos dependen de cada catálogo y señala consideraciones para la implementación del front-end y la carga masiva; los valores completos deben consultarse siempre en el layout para evitar desalineaciones con el gateway SIGED.【F:bd/layout_V01.md†L1-L58】

| Catálogo | Campos del layout | Notas para implementación |
| --- | --- | --- |
| Flujo del movimiento | 1 | Valores `I` (Inscripción), `R` (Reinscripción) y `B` (Baja); condicionan la visibilidad de secciones y de los campos 52-53.【F:bd/layout_V01.md†L3-L3】 |
| Sexo | 7 | Incluye `H` y `M`; considerar la observación del layout para habilitar "No binario" en la UI y evitar rechazos posteriores.【F:bd/layout_V01.md†L7-L7】 |
| Nacionalidad | 13 | Catálogo corto con al menos las claves 1 (Mexicano) y 2 (Extranjero); permitir búsqueda cuando se amplíe la lista.【F:bd/layout_V01.md†L13-L13】 |
| Países | 14, 16, 25 | Se reutiliza para país de nacimiento, residencia y procedencia; conviene exponer búsqueda por clave y nombre para evitar errores.【F:bd/layout_V01.md†L14-L30】 |
| Entidades federativas | 15, 17, 24, 26 | Deben filtrarse según el país seleccionado; necesarias tanto para nacimiento como para domicilio y procedencia.【F:bd/layout_V01.md†L15-L26】 |
| Municipios y localidades | 22 (localidad), 23 | Catálogo combinado Entidad-Municipio-Localidad; usar selectores jerárquicos y validación cruzada con la entidad.【F:bd/layout_V01.md†L22-L24】 |
| Tipos de vialidad | 18 | Lista utilizada para clasificar la vialidad del domicilio; el layout la marca como obligatoria aunque se solicitó analizar si puede ser opcional.【F:bd/layout_V01.md†L18-L18】 |
| Tipos de asentamientos humanos | 18 (comentario) | El layout referencia este catálogo para complementar la dirección; si se habilita debe seguir la codificación oficial de SEDATU/INEGI.【F:bd/layout_V01.md†L18-L21】 |
| Lenguas (INALI) | 27, 28 | Lengua materna es obligatoria; la segunda lengua debe ser distinta a la primera cuando se capture.【F:bd/layout_V01.md†L32-L33】 |
| Necesidades educativas | 29 | Contiene claves `00`, `01`, `02`; guía la obligatoriedad de los campos 30 y 31 al seleccionar discapacidad o aptitud sobresaliente.【F:bd/layout_V01.md†L34-L35】 |
| Tipos de discapacidad | 30 | Sólo se captura cuando la necesidad educativa es `01`; usar el catálogo oficial vigente de la SEP.【F:bd/layout_V01.md†L34-L35】 |
| Tipos de aptitud sobresaliente | 31 | Requerido cuando la necesidad educativa es `02`; mantenerlo sincronizado con el catálogo nacional.【F:bd/layout_V01.md†L34-L35】 |
| Instituciones (DGP) | 32 | Catálogo de instituciones autorizadas para educación superior; controlar versiones por fecha de publicación.【F:bd/layout_V01.md†L37-L37】 |
| CCT de escuelas | 33 | Catálogo nacional de centros de trabajo (CCT); al seleccionar debe autopoblarse nombre y ubicación del plantel.【F:bd/layout_V01.md†L38-L38】 |
| Carreras autorizadas (DGP) | 34 | Catálogo de claves de carrera; conviene relacionarlo con institución y modalidad para validar combinaciones permitidas.【F:bd/layout_V01.md†L39-L39】 |
| Modalidades educativas | 37 | Opciones 1 a 4 (Escolarizada, No escolarizada, Mixta, Dual).【F:bd/layout_V01.md†L37-L37】 |
| Opciones educativas | 38 | Valores como Presencial, En línea, Abierta, Certificación por examen y Dual; dependen de la modalidad seleccionada.【F:bd/layout_V01.md†L38-L38】 |
| Turnos | 41 | Claves 1 (Matutino), 2 (Vespertino), 4 (Discontinuo/Mixto) y 6 (Abierto); filtrar según oferta del plantel.【F:bd/layout_V01.md†L41-L41】 |
| Grados del plan de estudios | 43 | Se apoya en la tabla de equivalencias proporcionada en el layout para validar el avance reportado.【F:bd/layout_V01.md†L43-L43】 |
| Periodos o módulos escolares | 44 | Catálogo numérico que, junto con la duración, define el bloque cursado por el estudiante.【F:bd/layout_V01.md†L44-L44】 |
| Duraciones de periodo | 45 | Debe coincidir con el catálogo de periodos/módulos; úsese para validar consistencia temporal.【F:bd/layout_V01.md†L45-L45】 |
| Antecedente académico | 47 | Catálogo binario (`S`/`N`); documentar internamente qué se considera antecedente por nivel educativo.【F:bd/layout_V01.md†L47-L47】 |
| Situación académica | 49 | Claves `R` (Regular) e `I` (Irregular); deben alinearse con la definición local de adeudos de créditos.【F:bd/layout_V01.md†L49-L49】 |
| Origen de estudios precedentes | 51 | Valores `02` (Nacionales) y `03` (Extranjeros); opcional pero útil para reportes federales.【F:bd/layout_V01.md†L51-L51】 |
| Tipo de baja | 52 | Claves `1` (Temporal) y `2` (Definitiva); sólo se muestran cuando el flujo es `Baja`.【F:bd/layout_V01.md†L57-L57】 |
| Motivo de baja | 53 | Catálogo detallado de motivos; debe consumirse completo para garantizar trazabilidad normativa.【F:bd/layout_V01.md†L58-L58】 |
