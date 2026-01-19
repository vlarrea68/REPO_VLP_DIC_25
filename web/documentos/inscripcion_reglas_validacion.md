# Reglas de validación derivadas del layout de inscripción

Este documento sintetiza las reglas técnicas que deben implementarse en la captura manual y en el procesamiento de archivos CSV para los flujos de inscripción, reinscripción y baja. Cada regla proviene del `bd/layout_V01.md`, que es la fuente normativa entregada por la SEP.【F:bd/layout_V01.md†L1-L58】

## Validaciones generales
- **Flujo normativo:** el campo `Flujo` sólo admite los valores `I`, `R` o `B` y debe ser coherente con el grado escolar reportado (primer grado para inscripciones, grados subsecuentes para reinscripciones y cualquier grado para baja).【F:bd/layout_V01.md†L3-L3】
- **Periodo escolar:** `Ciclo escolar` debe seguir el patrón `AAAA-AAAA` y `Año escolar` debe ser un año numérico válido; ambos campos son obligatorios para todo registro enviado.【F:bd/layout_V01.md†L4-L5】
- **Formato de fechas:** `Fecha de nacimiento`, `Fecha de inicio del periodo`, `Fecha de inicio de estudios` y `Fecha de acuerdo de RVOE` utilizan el formato `DD/MM/AAAA` y deben rechazarse las fechas inválidas o futuras según corresponda.【F:bd/layout_V01.md†L10-L12】【F:bd/layout_V01.md†L45-L55】
- **Segmento raíz y CURP:** cuando se capture la CURP debe validarse estructura oficial (longitud, máscara y consistencia con sexo y entidad); si falta la CURP completa, el segmento raíz de 16 caracteres es obligatorio y debe seguir el algoritmo oficial.【F:bd/layout_V01.md†L8-L11】
- **Catálogos oficiales:** sexo, nacionalidad, países, entidades, modalidades, turnos, necesidades educativas, discapacidades, aptitudes, grados, periodos, tipos/motivos de baja y origen de estudios sólo aceptan claves definidas en los catálogos del layout.【F:bd/layout_V01.md†L7-L58】
- **Campos condicionales:** los campos de RVOE aplican únicamente a instituciones particulares, mientras que `Tipo de baja` y `Motivo de baja` sólo se habilitan cuando el flujo es `Baja`.【F:bd/layout_V01.md†L39-L45】【F:bd/layout_V01.md†L57-L58】

## Identidad y contacto
- **Nombres y apellidos:** deben capturarse sin abreviaturas, no pueden quedar vacíos (excepto segundo apellido) y deben aceptar caracteres especiales para reflejar fielmente el acta de nacimiento.【F:bd/layout_V01.md†L6-L8】
- **Sexo:** limitar la captura a los valores del catálogo (`H`/`M`) e incluir la observación para "No binario" conforme a la recomendación RENAPO.【F:bd/layout_V01.md†L7-L7】
- **Correos y teléfonos:** aunque son opcionales, cuando se proporcionen deben cumplir las validaciones de formato (`correo@dominio` y diez dígitos sin separadores).【F:bd/layout_V01.md†L11-L12】

## Nacimiento, residencia y domicilio
- **País y entidad:** los pares de país/entidad de nacimiento, residencia y procedencia deben existir en los catálogos oficiales y ser coherentes entre sí (p. ej. entidad válida para el país seleccionado).【F:bd/layout_V01.md†L14-L26】
- **Dirección:** tipo y nombre de vialidad son obligatorios según el layout, mientras que números exterior/interior pueden quedar vacíos pero deben aceptar caracteres alfanuméricos cuando se capturen.【F:bd/layout_V01.md†L18-L21】
- **Código postal y localidad:** validar que el código postal sea numérico de cinco dígitos y que la localidad/municipio correspondan al catálogo Entidad-Municipio-Localidad para la entidad indicada.【F:bd/layout_V01.md†L22-L24】

## Lenguas y necesidades educativas
- **Lengua materna:** siempre debe existir y provenir del catálogo INALI; la segunda lengua es opcional pero, si se captura, debe ser distinta a la materna.【F:bd/layout_V01.md†L32-L33】
- **Necesidad educativa:** aceptar únicamente claves válidas; cuando sea `01 Discapacidad` se requiere el tipo de discapacidad y cuando sea `02 Aptitud sobresaliente` se debe capturar la aptitud correspondiente.【F:bd/layout_V01.md†L34-L35】

## Identificadores institucionales y oferta académica
- **Claves oficiales:** institución, escuela (CCT) y carrera son obligatorias y deben validarse contra los catálogos autorizados por la SEP; cualquier cambio debe rechazarse si la clave no existe.【F:bd/layout_V01.md†L32-L39】
- **Modalidad y opción educativa:** validar que ambas pertenezcan a sus catálogos y que la opción sea coherente con la modalidad elegida.【F:bd/layout_V01.md†L37-L38】
- **RVOE:** el número y la fecha del acuerdo son requeridos sólo para instituciones particulares; ambos datos deben corresponder a registros oficiales válidos.【F:bd/layout_V01.md†L39-L45】
- **Turno y créditos:** el turno debe encontrarse en el catálogo oficial y los créditos totales de la carrera deben estar dentro del rango aprobado para el plan de estudios.【F:bd/layout_V01.md†L35-L41】

## Trayectoria académica y seguimiento
- **Ciclo institucional:** validar el patrón `AAAA-N` y que el valor corresponda con la configuración institucional activa.【F:bd/layout_V01.md†L42-L42】
- **Grado, periodo y duración:** los tres campos son obligatorios, deben provenir de sus catálogos y mantener coherencia entre sí (p. ej. duración correcta para el periodo seleccionado).【F:bd/layout_V01.md†L43-L45】
- **Fechas académicas:** la fecha de inicio del periodo no puede ser anterior a la fecha de inicio de estudios del estudiante en educación superior.【F:bd/layout_V01.md†L45-L55】
- **Antecedente académico y matrícula:** ambos campos son obligatorios; el antecedente debe ser `S` o `N` y la matrícula institucional no puede estar vacía.【F:bd/layout_V01.md†L47-L53】
- **Situación académica y origen de estudios:** validar que la situación esté en el catálogo (Regular/Irregular) y que el origen de estudios, cuando se capture, use las claves válidas (`02` o `03`).【F:bd/layout_V01.md†L49-L56】
- **Campos de baja:** `Tipo de baja` y `Motivo de baja` sólo se aceptan cuando el flujo es `Baja`; en cualquier otro caso deben enviarse vacíos.【F:bd/layout_V01.md†L57-L58】
