**Caso de Uso: Reportar Titulación**

- **Código:** CU-005
- **Actor primario:** Sistema estatal de titulación
- **Actores secundarios:** API Gateway Nacional SIGED, RENAPO, Servicio de Firma Digital

**Precondiciones:**
- El alumno debe haber concluido un plan de estudios acreditado y contar con certificado previo registrado en SIGED.
- La CURP y el folio de certificado deben estar validados.
- El sistema de titulación debe tener permisos de emisión y firma digital autorizada.

**Flujo principal de eventos:**
1. El sistema estatal prepara el expediente de titulación del alumno con CURP, carrera, promedio y fecha de conclusión.
2. Se valida la integridad documental y se genera el título electrónico firmado digitalmente.
3. Se arma el evento con folio, firma digital, UUID de certificación previa y se envía al Gateway SIGED.
4. El Gateway valida estructura, CURP, firma y unicidad del folio de titulación.
5. Si todo es correcto, se registra el evento con sello de tiempo y se genera acuse de aceptación.
6. El sistema estatal almacena el acuse como respaldo de trámite completado.

**Flujos alternativos y excepciones:**
- CURP o folio de certificación inexistentes: error de referencia.
- Firma digital no válida o no autorizada: evento rechazado.
- Duplicidad de folio de titulación: rechazo por integridad.

**Postcondiciones:**
- El título queda registrado en el SIGED con trazabilidad y validez oficial.
- El alumno puede ser consultado como titulado mediante UUID asociado.

**Reglas de negocio involucradas:**
- Sólo se permite un evento de titulación por CURP y carrera.
- El folio debe ser único y no reutilizable.
- El título debe ser firmado digitalmente y cumplir con normas de autenticación institucional.

**Interfaces relacionadas:**
- API REST SIGED: /api/v1/eventos/titulacion
- CURP RENAPO
- Servicio de Firma Digital autorizada (SEP, e.firma, etc.)
- Catálogo de programas/carreras registrados
- Servicio de autenticación DGTIC (API Key + JWT)

**Observaciones adicionales:**
- El evento de titulación representa el cierre académico de nivel medio superior o superior.
- Es fundamental para trámites subsecuentes (ingreso laboral, profesionalización, etc.).
