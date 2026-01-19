**Acta Constitutiva del Proyecto: Evolución del SIGED hacia un Modelo de Registros Administrativos Interoperables y en Tiempo Real**

---

### 1. Nombre del Proyecto

Evolución del SIGED hacia un Modelo de Registros Administrativos Interoperables y en Tiempo Real

### 2. Propósito u Oportunidad que da Origen al Proyecto

La oportunidad surge de la necesidad institucional de contar con información educativa confiable, oportuna y trazable, eliminando la dependencia de registros estadísticos agregados y cortes masivos. Esto permitirá una planeación educativa basada en evidencia y una reducción significativa de la carga administrativa en los centros escolares.

### 3. Objetivos del Proyecto

- Sustituir gradualmente los registros estadísticos del SIGED por registros administrativos validados en origen.
- Implementar un modelo de interoperabilidad federada y en tiempo real entre subsistemas educativos y el SIGED.
- Establecer mecanismos de validación automática conforme a catálogos y reglas normativas.
- Garantizar la trazabilidad, auditabilidad y calidad de los datos educativos.

### 4. Alcance Preliminar

- Desarrollo de un middleware nacional de interoperabilidad.
- Publicación de APIs RESTful y reglas técnicas homologadas.
- Integración progresiva de eventos escolares: inscripciones, bajas, evaluaciones, certificaciones.
- Homologación de catálogos (CURP, INEGI, RENAPO).
- Implementación de mecanismos de autenticación y control de acceso.

### 5. Identificación de Productos Entregables Iniciales

- Documento de visión y requerimientos del sistema (artefacto RUP).
- Especificaciones funcionales y no funcionales del SIGED interoperable.
- Modelo de casos de uso y flujos de eventos administrativos.
- Documento de arquitectura de interoperabilidad.
- Modelo de interoperabilidad federada (eventos, servicios, actores).
- Diccionario de datos homologado (catálogos CURP, INEGI, RENAPO).
- Especificaciones técnicas de APIs RESTful con validación integrada.
- Módulo validador de datos en origen con control normativo.
- Infraestructura del Gateway Nacional SIGED con autenticación federada.
- Mecanismos de trazabilidad, UUID y firma digital para cada evento.
- Informe de pruebas piloto de integración con subsistemas estatales.

### 6. Límites del Proyecto

- No se desarrollan sistemas escolares locales.
- No se contemplan procesos que no generen eventos administrativos (actividades extracurriculares).
- La integración con otras dependencias se limita a RENAPO, SAT e INEGI.

### 7. Supuestos y Restricciones

**Supuestos:**

- Existencia de sistemas operativos funcionales en los centros de trabajo o a nivel estatal que permitan capturar eventos escolares.
- Capacidad técnica y de infraestructura básica en los subsistemas participantes, al menos para conectividad mínima y uso de API REST.
- Conectividad estable en una proporción mínima del 80% de los centros de trabajo durante horarios escolares.
- Madurez tecnológica suficiente en los subsistemas estatales para adoptar APIs estándar y catálogos homologados.
- Disponibilidad y respaldo institucional para acompañamiento técnico en fases piloto.
- Estabilidad normativa que permita mantener consistencia en los eventos administrativos y su estructura de datos durante al menos el primer año de implementación.

**Restricciones:**

- Presupuesto asignado conforme a disponibilidad anual.
- Interoperabilidad limitada por la madurez tecnológica local y heterogeneidad de sistemas existentes.
- Adopción voluntaria por parte de subsistemas durante fases iniciales, sujeta a interés, capacidad local y alineación normativa.

### 8. Actores Clave (Interesados y Responsables)

- **Patrocinador:** Oficialía Mayor de la SEP
- **Unidad Responsable:** Dirección General de Tecnologías de la Información y Comunicaciones (DGTIC)
- **Usuarios Clave:** Subsecretarías (Educación Básica, Media Superior, Superior)
- **Aliados Estratégicos:** RENAPO, INEGI, SAT, UAF, DGAIR

### 9. Criterios de Éxito

- Disponibilidad del Gateway Nacional operando en 24/7.
- 100% de eventos capturados por subsistemas piloto integrados en tiempo real.
- Reducción de 50% en tiempo de actualización de datos en SIGED.
- Sustitución parcial del cuestionario 911 por registros administrativos.

### 10. Enlace con Planes Estratégicos

- **PND 2019-2024:** Eje 3. Bienestar, Educación para la igualdad.
- **PROSEDUC:** Fortalecimiento del sistema de información educativa.
- **TICSEP 2020-2024:** Interoperabilidad y Transformación Digital del Sector Educativo.

### 11. Justificación Técnica, Normativa y Presupuestal

La implementación del proyecto permitirá sustituir registros estadísticos masivos, como el Cuestionario 911, por registros administrativos generados y validados desde origen, lo que se traducirá en una reducción significativa de la carga operativa para los centros escolares y autoridades locales. Al capturar los eventos escolares en tiempo real y con validación automática, se garantizará la integridad, consistencia y oportunidad de la información, evitando reprocesos y errores derivados de capturas duplicadas o inconsistentes.

Desde el punto de vista normativo y técnico:
- **MAAGTICSI:** Cumplimiento del proceso de Desarrollo y Mantenimiento de Sistemas de Información (DSI-01), asegurando trazabilidad, interoperabilidad y calidad de datos.
- **LGPDPPSO y LFTAIPG:** Protección de datos personales mediante controles de acceso, registro de operaciones, y principios de licitud y proporcionalidad.
- **LGCG:** Contribución al cumplimiento del principio de rendición de cuentas a través de información verificable en tiempo real.
- **ISO/IEC 27001:** Aplicación de controles técnicos para preservar la confidencialidad, integridad y disponibilidad de la información educativa.

Desde el enfoque presupuestal, la inversión en infraestructura de interoperabilidad y automatización generará economías de escala al reducir:
- Los costos recurrentes asociados con encuestas, cortes de información y validaciones manuales.
- Los errores en certificados, CURP, evaluaciones y bajas por causas administrativas.
- El esfuerzo humano en la consolidación mensual o semestral de datos.

Este enfoque permitirá liberar recursos para otras prioridades educativas, haciendo más eficiente el uso del gasto TIC federal y estatal.

### 12. Riesgos de Alto Nivel Detectados

- Resistencia al cambio por parte de actores locales, especialmente en centros escolares con procesos arraigados y sin digitalización.
- Falta de interoperabilidad en sistemas legados que utilizan tecnologías obsoletas o estructuras no estandarizadas.
- Posible insuficiencia presupuestal para el despliegue nacional y sostenibilidad operativa en fases posteriores.
- Problemas de conectividad en zonas marginadas que limitan la captura y envío de datos en tiempo real.
- Diversidad en la madurez tecnológica de los subsistemas estatales, lo que dificulta la adopción homogénea del modelo.
- Cambios normativos en materia educativa que podrían alterar la estructura de datos o el marco de referencia del SIGED.

### 13. Autoridad del Director del Proyecto

El Director del Proyecto (designado por DGTIC) tendrá autoridad para:

- Aprobar cambios al plan de trabajo.
- Coordinar recursos internos y externos.
- Autorizar entregables y escalamiento de riesgos.

### 14. Recomendaciones para el Comité de Dirección

- Incluir representantes de la DGTIC, UAF, Subsecretarías, RENAPO y la Dirección General de Planeación.
- Establecer sesiones mensuales de seguimiento.
- Aprobar las fases de liberación y despliegue progresivo.

---

### Resumen Ejecutivo

El proyecto de evolución del SIGED permitirá reemplazar los registros estadísticos por registros administrativos interoperables y en tiempo real. A través de un modelo de APIs, validación en origen, y control normativo, se reducirá la carga operativa en escuelas, se mejorará la calidad de datos y se facilitará la toma de decisiones educativas basada en evidencia. Este proyecto se alinea con los planes estratégicos nacionales y cumple con la normatividad vigente en materia de TIC, transparencia y protección de datos.
