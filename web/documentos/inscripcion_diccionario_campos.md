# Diccionario de datos de inscripción y bajas

Este diccionario consolida los campos normativos definidos en el `layout_V01.md` entregado por la SEP y los agrupa de la misma manera en la que se construyen los componentes del módulo de inscripción y el subflujo de bajas. Todos los tipos, validaciones y notas provienen de ese layout y sirven como contrato único para el formulario manual y la carga masiva.【F:bd/layout_V01.md†L1-L58】

## 1. Metadatos del evento
Los primeros campos identifican la naturaleza del movimiento y delimitan el periodo escolar al que pertenece el registro.【F:bd/layout_V01.md†L3-L5】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 1 | Flujo | Cadena / 1 | Sí | Sólo acepta I, R o B; debe corresponder con el grado reportado para distinguir inscripción, reinscripción o baja. | Controla la visibilidad de secciones (p. ej. datos de baja) y encabezados del CSV. |
| 2 | Ciclo escolar | Cadena / 9 (AAAA-AAAA) | Sí | No nulo y debe cumplir el patrón `AAAA-AAAA`. | Precargar con el ciclo vigente publicado por la SEP para reducir errores de captura. |
| 3 | Año escolar | Cadena / 4 | Sí | Año numérico válido coherente con el ciclo escolar. | Puede derivarse del ciclo para evitar inconsistencias. |

## 2. Identidad y datos de contacto del estudiante
Estos campos permiten identificar a la persona estudiante y establecer los medios básicos de contacto.【F:bd/layout_V01.md†L6-L15】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 4 | Nombre(s) del alumno | Cadena / 100 | Sí | No puede estar vacío y debe aceptar caracteres especiales. | Mostrar ayudas para nombres compuestos y evitar abreviaturas. |
| 5 | Primer apellido | Cadena / 100 | Sí | No puede estar vacío y debe aceptar caracteres especiales. | Reforzar captura conforme al acta de nacimiento. |
| 6 | Segundo apellido | Cadena / 100 | No | Debe aceptar caracteres especiales cuando se proporcione. | Permitir dejarlo vacío y soportar apellidos con guiones. |
| 7 | Sexo | Cadena / 1 | Sí | Valor limitado al catálogo oficial (H/M) y observaciones para incluir "No binario". | Presentar opciones del catálogo y mantener compatibilidad con RENAPO. |
| 8 | CURP | Cadena / 18 | Condicional | Validar longitud, máscara oficial, concordancia con sexo y entidad, y existencia en RENAPO. | Campo normativo pero con flexibilización: si no se captura debe generarse el segmento raíz. |
| 9 | Segmento raíz | Cadena / 16 | Sí | No nulo, debe seguir el algoritmo oficial y coincidir con la CURP cuando exista. | Autogenerar y bloquear edición manual salvo excepciones justificadas. |
| 10 | Fecha de nacimiento | Fecha / DD/MM/AAAA | Sí | No nula y con fecha válida. | Usar selector de fecha restringido a fechas pasadas. |
| 11 | Correo electrónico | Cadena / 100 | No | Debe contener `@` y dominio válido. | Permitir capturar correo institucional y personal; ambos opcionales según comentarios del layout. |
| 12 | Número telefónico | Numérico / 10 | No | Únicamente dígitos y longitud de 10 posiciones. | Campo opcional; mostrar máscara o ejemplo para orientar al usuario. |
| 13 | Nacionalidad | Numérico / 1 | Sí | Debe pertenecer al catálogo de nacionalidades. | Desplegar catálogo corto (Mexicano/Extranjero) y permitir búsqueda cuando se amplíe. |

## 3. Nacimiento, residencia y domicilio actual
El layout detalla los datos de origen y residencia que deben acompañar la inscripción.【F:bd/layout_V01.md†L16-L31】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 14 | País de nacimiento | Numérico / 3 | Sí | Valor debe existir en el catálogo de países. | Autocompletar por clave o nombre. |
| 15 | Entidad de nacimiento | Cadena / 2 | Sí | Debe existir en catálogo de entidades y ser coherente con el país de nacimiento. | Limitar opciones según país seleccionado. |
| 16 | País de residencia | Numérico / 3 | Sí | Debe existir en catálogo de países. | Usar el mismo componente de selección que en país de nacimiento. |
| 17 | Entidad de residencia | Cadena / 2 | Sí | Valor en catálogo de entidades y coherente con país de residencia. | Disparar carga de municipios/localidades. |
| 18 | Tipo de vialidad | Cadena | Sí | No nulo según layout; clasifica la vialidad con catálogo específico. | El layout sugiere volverlo opcional, documentar decisión final con negocio. |
| 19 | Nombre de la vialidad | Cadena / 100 | Sí | No nulo según layout. | Permitir nombres largos y caracteres especiales; evaluar si se vuelve opcional. |
| 20 | Número exterior | Cadena / 15 | No | Sin validación obligatoria, aceptar caracteres alfanuméricos. | Mantener flexibilidad para domicilios sin número. |
| 21 | Número interior | Cadena / 15 | No | Sin validación obligatoria, aceptar caracteres alfanuméricos. | Útil para departamentos; no bloquear si se omite. |
| 22 | Código postal | Numérico / 5 | Sí | No nulo y numérico de cinco dígitos. | Validar contra catálogo SEP/SEPOMEX cuando esté disponible. |
| — | Localidad | Numérico / 5 | Condicional | Clave debe provenir del catálogo Entidad-Municipio-Localidad. | Se captura junto con municipio; reutilizar selector jerárquico. |
| 23 | Municipio o demarcación | Numérico / 3 | Sí | Debe existir en catálogo de municipios y ser coherente con entidad. | Enlazar con entidad seleccionada para filtrar resultados. |
| 24 | Entidad federativa del domicilio | Cadena / 2 | Sí | Debe existir en catálogo de entidades. | Mostrar clave y nombre para reducir ambigüedades. |
| 25 | País de procedencia | Numérico / 3 | Sí | Debe existir en catálogo de países. | Captura independiente del país de residencia para históricos. |
| 26 | Entidad de procedencia | Cadena / 2 | Sí | Debe existir en catálogo de entidades y concordar con país de procedencia. | Población condicional al país de procedencia. |

## 4. Lenguas y necesidades educativas
Estos campos describen las lenguas que habla la persona estudiante y, de existir, sus necesidades de apoyo.【F:bd/layout_V01.md†L32-L36】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 27 | Lengua materna | Numérico / 4 | Sí | No nulo y clave válida del catálogo INALI. | Ofrecer búsqueda por nombre y clave; incluir "Español". |
| 28 | Segunda lengua | Numérico / 4 | Condicional | Clave en catálogo INALI y distinta a la lengua materna. | Mostrar sólo cuando el usuario indique que existe otra lengua. |
| 29 | Necesidad educativa | Cadena / 2 | Sí | No nulo y dentro del catálogo oficial. | Señalar sensibilidad del dato y permitir "00 No aplica". |
| 30 | Tipo de discapacidad | Cadena / 2 | Condicional | Requerido sólo si la necesidad educativa es "01". | Desplegar catálogo correspondiente cuando aplique. |
| 31 | Tipo de aptitud sobresaliente | Cadena / 2 | Condicional | Requerido sólo si la necesidad educativa es "02". | Igual que el campo anterior, con catálogo específico. |

## 5. Identificadores institucionales y académicos
El layout define los identificadores clave de la institución, programa y oferta educativa.【F:bd/layout_V01.md†L37-L46】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 32 | Clave de la institución | Cadena / 12 | Sí | Debe existir en el catálogo de instituciones autorizadas por DGP. | Autocompletar para evitar errores de captura manual. |
| 33 | Clave de la escuela (CCT) | Cadena / 11 | Sí | Debe existir en catálogo CCT emitido por la DGPPEE. | Mostrar razón social al seleccionar para confirmar coincidencia. |
| 34 | Clave de la carrera | Cadena / 12 | Sí | Debe existir en catálogo de carreras autorizado por DGP. | Reutilizar catálogo centralizado; permitir búsqueda por nombre. |
| 35 | Créditos totales de la carrera | Numérico / 3 | Sí | No nulo y dentro del rango oficial del plan de estudios. | Prellenar desde catálogo institucional cuando sea posible. |
| 36 | Nivel educativo | Numérico / 2 | Sí | Valor debe estar en el catálogo de niveles (Licenciatura, Maestría, etc.). | Relacionar con validaciones posteriores (modalidad, opción educativa). |
| 37 | Modalidad educativa | Numérico / 1 | Sí | Valor debe encontrarse en el catálogo de modalidades (1-4). | Mostrar descripciones completas para orientar al usuario. |
| 38 | Opción educativa | Texto / lista | Sí | Valor debe existir en catálogo y ser coherente con la modalidad. | Validar dependencias modalidad-opción antes de guardar. |
| 39 | Número de acuerdo de RVOE | Cadena | Condicional | Requerido y validable contra el registro oficial cuando aplica. | No aplica para IES públicas; documentar campo alterno (decreto, oficio). |
| 40 | Fecha de acuerdo de RVOE | Fecha / DD/MM/AAAA | Condicional | Fecha válida y sólo aplicable cuando se captura el RVOE. | Para IES públicas registrar la fecha del documento equivalente. |
| 41 | Turno | Numérico / 1 | Sí | Valor debe existir en el catálogo de turnos (matutino, vespertino, mixto, abierto). | Sincronizar con la oferta real del plantel seleccionado. |

## 6. Trayectoria académica y seguimiento
Los siguientes campos describen el avance académico y datos históricos que acompañan a la inscripción.【F:bd/layout_V01.md†L47-L56】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 42 | Ciclo institucional | Cadena / 7 (AAAA-N) | Sí | No nulo y debe seguir el patrón `AAAA-N`. | Generar automáticamente a partir de configuraciones institucionales. |
| 43 | Grado de avance | Numérico / 2 | Sí | Valor debe existir en el catálogo y corresponder al plan de estudios. | Mostrar equivalencias (año/semestre) para guiar la selección. |
| 44 | Periodo o módulo escolar | Numérico / 2 | Sí | No nulo, en catálogo y coherente con la duración registrada. | Validar dependencias con grado y duración. |
| 45 | Duración del periodo/módulo | Numérico / 1 | Sí | No nulo y en catálogo de duraciones. | Mostrar unidades (semanas, meses) en la interfaz. |
| 46 | Fecha de inicio del periodo | Fecha / DD/MM/AAAA | Sí | Fecha válida y posterior o igual a la fecha de inicio de estudios. | Validar contra calendarios institucionales. |
| 47 | Antecedente académico | Cadena / 1 | Sí | Valor debe estar en el catálogo (S/N). | Documentar en la ayuda qué se considera antecedente por nivel. |
| 48 | Número de matrícula institucional | Cadena | Sí | No puede ser nulo. | Garantizar unicidad por institución y carrera dentro del ciclo. |
| 49 | Situación académica | Cadena / 1 | Sí | Valor debe pertenecer al catálogo (Regular/Irregular). | Validar coherencia con adeudos de créditos registrados. |
| 50 | Fecha de inicio de estudios | Fecha / DD/MM/AAAA | Sí | Fecha válida correspondiente al primer ingreso en educación superior. | Usar como ancla para validar fechas posteriores. |
| 51 | Origen de estudios precedentes | Cadena / 2 | Condicional | Valor debe existir en catálogo (02 Nacionales, 03 Extranjeros). | Útil para reportes; marcarlo como requerido por negocio si se decide. |

## 7. Campos exclusivos para bajas
Los últimos campos sólo aplican cuando el flujo corresponde a una baja y deben permanecer vacíos en otros escenarios.【F:bd/layout_V01.md†L57-L58】

| ID Layout | Campo | Tipo / longitud | Obligatorio | Validaciones clave | Observaciones para UI |
|-----------|-------|-----------------|-------------|--------------------|-----------------------|
| 52 | Tipo de baja del servicio educativo | Numérico / 1 | Condicional | Requerido cuando el flujo es Baja; vacío en cualquier otro flujo. | Mostrar únicamente al seleccionar flujo "B" y validar contra el catálogo. |
| 53 | Motivo de baja | Numérico / 2 | Condicional | Requerido junto con el tipo de baja; debe coincidir con el catálogo oficial. | Desplegar catálogo detallado y permitir búsqueda textual. |

> **Nota:** Los catálogos detallados para modalidades, turnos, necesidades, motivos de baja y demás campos se incluyen en el mismo `bd/layout_V01.md`, por lo que deben consumirse de esa fuente para garantizar consistencia con el gateway SIGED.【F:bd/layout_V01.md†L1-L58】
