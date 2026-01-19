**Caso de Uso: Enviar Evaluación Parcial o Final**

- **Código:** CU-003
- **Actor primario:** Sistema escolar estatal o local
- **Actores secundarios:** API Gateway Nacional SIGED, Catálogo de asignaturas, CURP RENAPO

**Precondiciones:**
- El alumno debe estar inscrito en el ciclo escolar vigente.
- La CURP y el CCT deben estar validados y activos.
- El catálogo de asignaturas y periodos de evaluación debe estar actualizado.

**Flujo principal de eventos:**
1. El docente o personal autorizado captura la calificación de un alumno para una asignatura en el sistema local.
2. El sistema local valida CURP, clave de asignatura, tipo de evaluación (parcial o final) y rango permitido de calificaciones.
3. Se genera el evento de evaluación y se envía al Gateway SIGED vía API.
4. El Gateway realiza validación estructural, semántica y cronológica (periodo de evaluación).
5. Si todo es correcto, el evento se registra con UUID, sello de tiempo y se devuelve un acuse de aceptación.
6. El sistema local almacena el acuse como constancia de que la calificación fue reportada correctamente.

**Flujos alternativos y excepciones:**
- CURP no inscrita en el ciclo escolar: error de referencia académica.
- Clave de asignatura no reconocida: error semántico con código específico.
- Calificación fuera del rango válido: rechazo con mensaje claro.
- Duplicidad de evento: si ya se registró esa evaluación con esa CURP y asignatura.

**Postcondiciones:**
- La evaluación queda registrada en el historial académico del alumno en SIGED.
- El acuse sirve como respaldo de cumplimiento para el centro escolar.
- Se permite la generación de reportes evaluativos consolidados a nivel estatal y nacional.

**Reglas de negocio involucradas:**
- Cada alumno sólo puede tener una calificación por asignatura y tipo de evaluación por periodo.
- Las evaluaciones deben corresponder al calendario escolar aprobado por la autoridad educativa.

**Interfaces relacionadas:**
- API REST SIGED: /api/v1/eventos/evaluacion
- Catálogo de asignaturas oficiales por nivel educativo
- Catálogo de tipos de evaluación y calendarios
- Servicio CURP RENAPO para validación de identidad
- Servicio de autenticación DGTIC (API Key + JWT)

**Observaciones adicionales:**
- Este evento es esencial para la emisión de certificados y análisis estadístico de desempeño.
- La validación temprana local evita rechazos masivos por estructura o calendario incorrecto.
