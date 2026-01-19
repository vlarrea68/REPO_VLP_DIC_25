**Caso de Uso: Reportar Baja**

- **Código:** CU-002
- **Actor primario:** Sistema escolar estatal o local
- **Actores secundarios:** API Gateway Nacional SIGED, Catálogo de motivos de baja

**Precondiciones:**
- El alumno debe contar con una CURP previamente inscrita y activa en el sistema.
- El CCT debe estar activo y registrado correctamente.
- El motivo de baja debe coincidir con los valores definidos en el catálogo oficial.

**Flujo principal de eventos:**
1. El sistema local identifica que un alumno se da de baja en el ciclo escolar actual.
2. Se registra la CURP del alumno, fecha efectiva de baja y motivo según catálogo SEP.
3. Se validan localmente los datos y se envía el evento al Gateway SIGED.
4. El Gateway valida que la CURP corresponde a un registro activo, que el motivo sea válido y que la fecha sea coherente.
5. Si la validación es exitosa, se genera un UUID, se sella el evento y se devuelve un acuse oficial al sistema local.
6. El sistema escolar almacena el acuse y actualiza el estatus del alumno en su sistema local.

**Flujos alternativos y excepciones:**
- CURP no encontrada como inscrita: se rechaza el evento con mensaje de error específico.
- Motivo no reconocido en el catálogo: error semántico.
- Fecha inválida (futura o anterior a inscripción): se devuelve error de validación temporal.

**Postcondiciones:**
- El SIGED registra el evento de baja como parte del historial académico del alumno.
- Se actualiza el estado administrativo del alumno para evitar evaluaciones posteriores.
- El centro de trabajo conserva acuse oficial de baja registrada.

**Reglas de negocio involucradas:**
- No se puede emitir una baja si no existe una inscripción previa vigente.
- La baja cancela automáticamente la expectativa de evaluaciones o certificaciones posteriores.

**Interfaces relacionadas:**
- API REST SIGED: /api/v1/eventos/baja
- Catálogo de motivos de baja (SEP)
- Servicio de autenticación DGTIC (API Key + JWT)

**Observaciones adicionales:**
- El evento de baja puede ser requerido como condición previa para ciertos trámites administrativos (transferencias, reinscripciones en otra escuela, etc.).
- Los acuses de baja se consideran documentos oficiales de respaldo para el sistema escolar local y estatal.
