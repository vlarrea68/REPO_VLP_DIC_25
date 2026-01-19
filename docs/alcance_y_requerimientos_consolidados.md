# Alcance y Requerimientos Consolidados

## 1. Alcance del Proyecto

El proyecto se enfoca en el desarrollo de la **Plataforma Central SEP-MUSES**. Las responsabilidades de los subsistemas externos (fuentes de datos) se limitan a la generación de archivos CSV según el layout especificado.

### Funcionalidad Dentro del Alcance

*   **Módulo de Carga de Datos:**
    *   Recepción de archivos CSV para inscripciones, bajas y reinscripciones.
    *   API para cargas masivas y formularios para carga manual individual.
*   **Módulo de Procesamiento y Consolidación:**
    *   Proceso asíncrono para la validación de datos contra catálogos y servicios externos (RENAPO).
    *   Lógica ETL para transformar y consolidar los datos en una única base de datos central.
*   **Módulo de Consulta:**
    *   API para consultar la trayectoria académica de un alumno por su CURP.
    *   Interfaz web para que los administradores realicen estas consultas.
*   **Módulo de Notificación:**
    *   Servicio para notificar eventos consolidados a sistemas externos como SIGED.

### Funcionalidad Fuera del Alcance

*   El desarrollo o modificación de los sistemas en los **Subsistemas de Educación Superior**.
*   El **Dashboard de Monitoreo para administradores SEP** (funcionalidad de inteligencia de negocio).

## 2. Requerimientos Funcionales Clave

*   **RF-001:** El sistema deberá permitir la carga de archivos CSV con un layout definido.
*   **RF-002:** El sistema deberá validar la CURP de los alumnos contra el servicio de RENAPO.
*   **RF-003:** El sistema deberá consolidar la información en una única base de datos central (`sep_muses`).
    *   **Modelo de Datos Centralizado:** La base de datos `sep_muses` contendrá:
        *   **Área de Staging (Tablas `tbae*`):** Donde los datos crudos son recibidos.
        *   **Catálogos (Tablas `ctmu*`):** Para la validación de datos.
        *   **Tablas Núcleo (Tablas `tbmu*`):** Donde residen los datos limpios y normalizados.
*   **RF-004:** El sistema deberá proveer una API para consultar la trayectoria de un alumno.
*   **RF-005:** El sistema deberá enviar notificaciones de eventos consolidados a SIGED.

## 3. Requerimientos No Funcionales

*   **RNF-001:** El sistema deberá procesar una carga de 50,000 registros en menos de 30 minutos.
*   **RNF-002:** El sistema deberá tener una disponibilidad del 99.9%.
*   **RNF-003:** La comunicación con servicios externos debe ser segura (HTTPS/TLS).
