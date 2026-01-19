# Plan de Pruebas del Sistema SEP-MUSES

## 1. Propósito

Este documento describe la estrategia, el alcance, los recursos y el cronograma de todas las actividades de prueba para la **Matrícula Única de Educación Superior (SEP-MUSES)**. El objetivo es garantizar que el software cumpla con los requerimientos funcionales y no funcionales definidos, asegurando su calidad, fiabilidad y rendimiento.

## 2. Alcance de las Pruebas

### Dentro del Alcance

*   **Pruebas de API (Backend):** Se probarán todos los endpoints de la API del Gateway de Interoperabilidad, incluyendo:
    *   Validación de la estructura de archivos CSV de carga masiva contra el layout definido.
    *   Lógica de negocio para cada tipo de evento (inscripción, baja, evaluación) contenido en los archivos.
    *   Manejo de errores y respuestas HTTP.
    *   Autenticación y autorización.
*   **Pruebas de Integración:** Se verificará la correcta comunicación entre los microservicios internos y con los servicios externos (RENAPO).
*   **Pruebas de Base de Datos:** Se validará la integridad de los datos y la correcta ejecución de los procesos ETL que operan dentro de la base de datos `sep_muses` (moviendo datos de las tablas `tbae*` a `tbmu*`).
*   **Pruebas No Funcionales:**
    *   **Rendimiento:** Pruebas de carga y estrés para asegurar que el sistema soporta el volumen de transacciones esperado.
    *   **Seguridad:** Pruebas de penetración básicas para identificar vulnerabilidades comunes.
*   **Pruebas de UI (Frontend `muses-web`):** Se realizarán pruebas funcionales y de usabilidad en todos los módulos de la aplicación Angular, incluyendo los formularios de inscripción, bajas y gestión de catálogos.

### Fuera del Alcance

*   Pruebas de los sistemas de control escolar de las entidades federativas.
*   Pruebas de la infraestructura de red subyacente (se asume que es estable).
*   Pruebas exhaustivas de los servicios externos (ej. RENAPO); solo se probará la integración con ellos.

## 3. Estrategia de Pruebas

Se utilizará un enfoque de múltiples niveles de prueba:

1.  **Pruebas Unitarias:** Realizadas por los desarrolladores para verificar los componentes individuales (clases y funciones) de manera aislada.
2.  **Pruebas de Integración:** Realizadas por desarrolladores y QA para verificar la interacción entre los microservicios y la base de datos.
3.  **Pruebas de Sistema (API E2E):** Realizadas por el equipo de QA para validar los flujos de negocio completos a través de la API, simulando las llamadas que harían los sistemas estatales.
4.  **Pruebas de Aceptación de Usuario (UAT):** Realizadas por un grupo selecto de usuarios finales (o sus representantes) para validar que el sistema cumple con sus necesidades.
5.  **Pruebas No Funcionales:** Realizadas por especialistas de QA y rendimiento.

## 4. Criterios de Entrada y Salida

*   **Criterios de Entrada:**
    *   La funcionalidad a probar está completamente desarrollada y desplegada en el entorno de pruebas.
    *   Todas las pruebas unitarias han sido ejecutadas y han pasado.
    *   El entorno de pruebas está estable y configurado.
*   **Criterios de Salida (para pase a Producción):**
    *   El 100% de los casos de prueba definidos han sido ejecutados.
    *   El 95% de los casos de prueba han pasado.
    *   No hay defectos críticos o bloqueantes sin resolver.
    *   Todos los defectos de alta prioridad tienen un plan de mitigación o corrección.

## 5. Entornos de Prueba

*   **Entorno de Desarrollo:** Utilizado por los desarrolladores para pruebas unitarias.
*   **Entorno de Pruebas (QA):** Un entorno aislado que replica la configuración de producción, donde se ejecutarán las pruebas de integración, sistema y no funcionales.
*   **Entorno de Staging/UAT:** Un entorno pre-productivo para las pruebas de aceptación de usuario.

## 6. Recursos y Herramientas

| Tipo de Prueba | Herramienta Propuesta |
| :--- | :--- |
| Pruebas Unitarias | Jest (Node.js), Karma/Jasmine (Angular) |
| Pruebas de API | Postman (con soporte para GraphQL), Apollo Sandbox |
| Pruebas de Rendimiento | JMeter, Gatling |
| Gestión de Defectos | Jira, Trello |
| Repositorio de Casos de Prueba | TestRail, Zephyr (o Markdown en el repositorio) |

## 7. Entregables

*   Este Plan de Pruebas.
*   Casos de prueba detallados.
*   Scripts de prueba automatizados.
*   Reportes de ejecución de pruebas.
*   Informe final de resumen de pruebas.
*   Reportes de defectos.

---

## 8. Estrategia Detallada de Pruebas No Funcionales

- **Pruebas de rendimiento:** Simular carga de eventos simultáneos por entidad federativa utilizando JMeter. Verificar tiempos de respuesta < 3s.
- **Pruebas de estrés:** Someter el Gateway a picos de eventos por encima del promedio esperado para encontrar el punto de quiebre.
- **Pruebas de escalabilidad:** Evaluar el comportamiento del sistema con aumento progresivo de réplicas de los microservicios.
- **Pruebas de disponibilidad:** Ejecutar simulaciones de caída y recuperación para validar cumplimiento del SLA (99.8%).
- **Pruebas de seguridad:** Validar autenticación de API, protección contra inyecciones (ej. SQLi, XSS), cifrado TLS y control de acceso por rol.
- **Pruebas de auditoría y trazabilidad:** Confirmar que cada evento se registre con un UUID y una bitácora inmutable.

## 9. Métricas de Calidad y Criterios de Aceptación Final

- **Cobertura mínima funcional:** 100% de los casos de uso críticos probados y aceptados.
- **Errores abiertos críticos:** 0 defectos abiertos de severidad alta al momento del despliegue.
- **Tiempo de respuesta:** Promedio < 3 segundos en el 95% de las pruebas de rendimiento.
- **Disponibilidad comprobada:** ≥ 99.8% durante pruebas de disponibilidad controladas.
- **Trazabilidad:** 100% de eventos registrados con UUID y acuse trazable.
- **Cumplimiento de seguridad:** 100% de pruebas de autenticación, cifrado y control de acceso superadas.
