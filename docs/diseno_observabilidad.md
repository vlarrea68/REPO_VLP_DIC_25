# Diseño de la Estrategia de Observabilidad

## 1. Introducción

Este documento define la estrategia de **observabilidad** para el sistema SEP-MUSES. Mientras que el monitoreo tradicional se enfoca en *predecir* fallas conocidas (ej. uso de CPU), la observabilidad nos permite *explorar y entender* problemas imprevistos y complejos que surgen en sistemas distribuidos.

Una estrategia de observabilidad robusta es fundamental para la operación, mantenimiento y depuración de una arquitectura de microservicios como la de SEP-MUSES. Nos permitirá responder preguntas como:
*   "¿Por qué el procesamiento de un archivo CSV específico fue más lento de lo normal?"
*   "¿Qué secuencia de servicios fue invocada por una petición fallida?"
*   "¿Cómo impactó un aumento de carga en el rendimiento de cada componente individual?"

Esta estrategia se basa en tres pilares fundamentales: **Métricas, Logs (Registros) y Trazas Distribuidas**.

## 2. Pilares de la Observabilidad y Herramientas Propuestas

### 2.1. Métricas (Metrics)

*   **¿Qué son?** Agregaciones numéricas de datos sobre un intervalo de tiempo. Son la base para dashboards, alertas y análisis de tendencias.
*   **Herramientas Propuestas:**
    *   **Prometheus:** Un sistema de monitoreo y alerta de código abierto, estándar en la industria, que recolecta métricas de los servicios a través de un modelo *pull* (raspado de endpoints `/metrics`).
    *   **Grafana:** Una plataforma de visualización que se integra nativamente con Prometheus para crear dashboards interactivos y personalizables.
*   **Métricas Clave a Implementar:**
    *   **API de Recepción:**
        *   `http_requests_total`: Contador de peticiones HTTP por endpoint, método y código de estado.
        *   `http_request_duration_seconds`: Histograma de la latencia de las peticiones.
        *   `csv_validation_errors_total`: Contador de errores de validación de archivos CSV.
    *   **Servicios de Procesamiento (Workers):**
        *   `events_processed_total`: Contador de eventos (filas de CSV) procesados.
        *   `event_processing_duration_seconds`: Histograma del tiempo que toma procesar cada evento.
        *   `external_service_call_duration_seconds`: Histograma de la latencia de las llamadas a servicios externos (ej. RENAPO).
    *   **Cola de Mensajes:**
        *   `queue_messages_enqueued_total` / `queue_messages_dequeued_total`: Contadores de mensajes encolados y desencolados.
        *   `queue_messages_ready`: Medidor del número de mensajes en espera de ser procesados (fundamental para detectar cuellos de botella).

### 2.2. Logs (Registros)

*   **¿Qué son?** Registros inmutables y con marca de tiempo de eventos discretos. Son esenciales para la depuración detallada y el análisis forense.
*   **Estrategia y Herramientas Propuestas:**
    *   **Logs Estructurados:** Todos los microservicios deberán emitir logs en formato **JSON**. Esto permite que los logs sean fácilmente parseables, filtrables y consultables.
    *   **Centralización de Logs:** Los logs de todos los componentes serán recolectados y enviados a un sistema centralizado. Se proponen dos alternativas de stacks de código abierto:
        1.  **Stack ELK/EFK:** Elasticsearch (almacenamiento y búsqueda), Logstash/Fluentd (recolección y procesamiento) y Kibana (visualización). Es un stack muy potente y maduro.
        2.  **Loki:** Un sistema de agregación de logs inspirado en Prometheus, diseñado para ser altamente eficiente en costos y fácil de operar, especialmente si ya se usa Grafana (se integra en la misma interfaz).
*   **Ejemplo de Log Estructurado:**
    ```json
    {
      "timestamp": "2025-10-31T15:00:00Z",
      "level": "ERROR",
      "service": "servicio-procesamiento-inicial",
      "message": "Fallo la validación de la CURP",
      "transaction_id": "a1b2c3d4-e5f6-7890-1234-567890abcdef",
      "curp": "XXXX000000XXXXXX00",
      "error_details": "CURP no encontrada en el servicio de RENAPO"
    }
    ```

### 2.3. Trazas Distribuidas (Distributed Tracing)

*   **¿Qué son?** Muestran el ciclo de vida completo de una petición a medida que viaja a través de los múltiples microservicios del sistema. Son la herramienta más poderosa para entender el comportamiento de sistemas distribuidos.
*   **Herramientas Propuestas:**
    *   **OpenTelemetry (OTel):** Un estándar de instrumentación de código abierto, agnóstico de la plataforma. Las librerías de OTel se usarán en cada microservicio para generar y propagar las trazas.
    *   **Jaeger:** Un sistema de backend de código abierto para almacenar y visualizar las trazas. Jaeger permite ver diagramas de Gantt de las peticiones, identificar cuellos de botella y entender las dependencias entre servicios.
*   **Funcionamiento:**
    1.  Cuando una petición llega al **API Gateway**, se le asigna un **Trace ID** único.
    2.  Este Trace ID se propaga automáticamente en los encabezados de todas las comunicaciones subsecuentes (llamadas HTTP, mensajes en la cola).
    3.  Cada servicio añade sus propios "spans" (unidades de trabajo) a la traza.
    4.  El resultado es una vista completa que une todos los logs y métricas relacionados con una única transacción.

## 3. Integración y Correlación

La verdadera potencia de la observabilidad se logra al **correlacionar** los tres pilares. La estrategia para SEP-MUSES será:
*   **Inyectar Trace IDs en los Logs:** Todos los logs estructurados incluirán el `trace_id` de la petición que se está procesando. Esto permitirá filtrar en Kibana o Loki todos los logs de una traza específica.
*   **Vincular Trazas desde Grafana:** Grafana permitirá saltar directamente desde un dashboard de métricas a la visualización de trazas en Jaeger o a los logs en Kibana/Loki, proporcionando un flujo de trabajo de depuración unificado.
