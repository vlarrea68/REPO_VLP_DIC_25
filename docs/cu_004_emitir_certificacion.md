**Caso de Uso: Emitir Certificación**

- **Código:** CU-004
- **Actor primario:** Sistema estatal de control escolar
- **Actores secundarios:** API Gateway Nacional SIGED, CURP RENAPO, Servicio de Firma Digital

**Precondiciones:**
- El alumno debe contar con evaluaciones registradas y válidas en el ciclo escolar.
- El promedio final debe estar calculado conforme a las reglas de ponderación establecidas.
- El sistema debe contar con los certificados digitales válidos para la firma de documentos.

**Flujo principal de eventos:**
1. El sistema estatal consolida el expediente académico del alumno con CURP, evaluaciones y promedio final.
2. Se valida localmente la integridad del expediente y la coincidencia de datos con catálogos federales.
3. El sistema firma digitalmente el certificado con clave institucional.
4. Se envía el evento de certificación al Gateway SIGED vía API.
5. El Gateway valida la estructura del documento, firma digital, CURP y folio de certificación.
6. Si es aceptado, el SIGED registra el evento con UUID, sello de tiempo y devuelve un acuse al sistema estatal.

**Flujos alternativos y excepciones:**
- Evaluaciones incompletas o promedio inválido: rechazo del evento con descripción.
- Firma digital inválida o no reconocida: evento rechazado por integridad.
- Folio duplicado en el mismo ciclo: error de unicidad.

**Postcondiciones:**
- El certificado queda registrado como documento oficial en el SIGED.
- El folio pasa a formar parte del historial del alumno con validez oficial.
- El sistema estatal conserva el acuse como respaldo del acto certificador.

**Reglas de negocio involucradas:**
- No se puede emitir certificación sin la totalidad de evaluaciones requeridas.
- El folio debe ser único por CURP y ciclo escolar.
- La firma digital debe cumplir con la normatividad aplicable (e.firma u otra reconocida por SEP).

**Interfaces relacionadas:**
- API REST SIGED: /api/v1/eventos/certificacion
- Servicio de firma digital oficial (e.firma, SEP u otro)
- CURP RENAPO
- Catálogo de folios oficiales de certificación
- Servicio de autenticación DGTIC (API Key + JWT)

**Observaciones adicionales:**
- Este evento es crítico para la emisión de documentos con validez oficial.
- La trazabilidad y seguridad jurídica del proceso dependen del control del folio y firma digital.
