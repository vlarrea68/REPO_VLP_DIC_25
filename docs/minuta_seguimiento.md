# Plantilla de Minuta de Reunión de Seguimiento

---

## 1. Información de la Reunión

*   **Proyecto:** Matrícula Única de Educación Superior (SEP-MUSES)
*   **Fecha:** AAAA-MM-DD
*   **Hora:** HH:MM
*   **Lugar / Plataforma:** [Ej: Sala de Juntas 3, Google Meet]
*   **Moderador:** [Nombre]
*   **Secretario (toma de minuta):** [Nombre]

---

## 2. Participantes

| Nombre | Área / Rol | Asistencia |
| :--- | :--- | :--- |
| [Nombre Completo] | Líder de Proyecto | [X] |
| [Nombre Completo] | Líder Técnico / Arquitecto | [X] |
| [Nombre Completo] | Líder de Desarrollo | [ ] |
| [Nombre Completo] | Líder de QA | [X] |
| [Nombre Completo] | Representante de Negocio | [X] |
| ... | ... | ... |

---

## 3. Agenda

1.  **Revisión de Acuerdos Anteriores** (5 min)
2.  **Reporte de Avances por Fase/Componente** (15 min)
    *   Avance del Desarrollo
    *   Avance de Pruebas
    *   Estado de la Infraestructura
3.  **Discusión de Bloqueos y Riesgos** (15 min)
4.  **Próximos Pasos y Hitos** (10 min)
5.  **Acuerdos y Tareas** (5 min)

---

## 4. Desarrollo de la Reunión

### 4.1. Revisión de Acuerdos Anteriores

| ID Acuerdo Anterior | Descripción | Responsable | Estado | Comentarios |
| :--- | :--- | :--- | :--- | :--- |
| **AC-2301** | Definir el esquema de autenticación para la API. | Líder Técnico | **Completado** | Se utilizará API Key para la v1. |
| **AC-2302** | Solicitar acceso al entorno de pruebas de RENAPO. | Líder de Proyecto | **En Progreso**| Se envió la solicitud, en espera de respuesta. |

### 4.2. Reporte de Avances

*   **Desarrollo:**
    *   Se completó el desarrollo del módulo de Inscripciones (API y lógica de negocio).
    *   Avance del 70% en el módulo de Bajas.
    *   El próximo sprint se enfocará en el módulo de Evaluaciones.
*   **Pruebas:**
    *   Se ejecutaron las pruebas funcionales para la API de Inscripciones, con un 95% de casos exitosos.
    *   Se reportaron 3 nuevos defectos (BUG-101, BUG-102, BUG-103).
*   **Infraestructura:**
    *   El entorno de QA está estable.
    *   Se está trabajando en la configuración del entorno de Staging.

### 4.3. Bloqueos y Riesgos

| ID | Descripción del Bloqueo / Riesgo | Impacto (Alto/Medio/Bajo) | Plan de Mitigación |
| :- | :--- | :--- | :--- |
| **B-01** | **Bloqueo:** No se ha recibido respuesta de RENAPO para el acceso al entorno de pruebas. | **Alto** | El Líder de Proyecto escalará la solicitud. Como plan B, el equipo de desarrollo creará un mock más robusto. |
| **R-01** | **Riesgo:** El equipo de desarrollo tiene una alta dependencia de un solo desarrollador backend. | **Medio** | Se programarán sesiones de "pair programming" para compartir conocimiento. |

---

## 5. Acuerdos y Tareas (Nuevos)

| ID | Descripción del Acuerdo / Tarea | Responsable | Fecha Límite |
| :--- | :--- | :--- | :--- |
| **AC-2401** | Investigar y proponer una solución para el defecto BUG-103 (Error 500 en JSON mal formado). | Líder de Desarrollo | AAAA-MM-DD |
| **AC-2402** | Preparar un borrador de los casos de prueba para el módulo de Evaluaciones. | Líder de QA | AAAA-MM-DD |
| **AC-2403** | Dar seguimiento diario a la solicitud de acceso a RENAPO. | Líder de Proyecto | N/A |

---

## 6. Próxima Reunión

*   **Fecha:** AAAA-MM-DD
*   **Hora:** HH:MM
