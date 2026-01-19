# Reporte de Ejecución de Pruebas de Estrés

## 1. Propósito

Este documento presenta los resultados de las pruebas de estrés realizadas sobre el sistema SIGED, con el objetivo de identificar el punto de quiebre del sistema y evaluar su comportamiento bajo condiciones extremas.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Herramienta Utilizada:** `[Ej. k6, JMeter, Locust]`
-   **Responsable de la Ejecución:** `[Especialista de Rendimiento]`

## 3. Escenario de Prueba

-   **Descripción:** Se incrementó gradualmente la carga de usuarios virtuales (VUs) que envían peticiones `POST` al endpoint `/api/eventos`, comenzando con 100 VUs y aumentando en 50 VUs cada 2 minutos.
-   **Duración:** Hasta que la tasa de errores superó el 10% o los tiempos de respuesta excedieron los 5 segundos de forma consistente.

## 4. Resultados

-   **Punto de Quiebre Identificado:** El sistema comenzó a mostrar una degradación significativa a los **450 usuarios virtuales concurrentes**.
-   **Rendimiento Máximo (Throughput):** Se alcanzó un máximo de **800 peticiones por segundo (RPS)** antes de que la tasa de errores comenzara a aumentar drásticamente.
-   **Tiempos de Respuesta en Punto de Quiebre:** El tiempo de respuesta promedio p(95) subió a **4800ms**.
-   **Tasa de Errores en Punto de Quiebre:** La tasa de errores alcanzó el **12%** (principalmente errores `503 Service Unavailable`).

## 5. Evidencias

-   **Gráfica de Tiempos de Respuesta vs. Usuarios Virtuales:**
    *(Adjuntar aquí la gráfica generada por la herramienta de pruebas)*

-   **Gráfica de Tasa de Errores vs. Usuarios Virtuales:**
    *(Adjuntar aquí la gráfica generada por la herramienta de pruebas)*

## 6. Observaciones y Defectos

-   **Observación 1:** Se identificó un cuello de botella en el pool de conexiones a la base de datos a partir de los 400 VUs.
-   **ID del Defecto:** `BUG-003`
-   **Descripción:** El servicio no se recupera automáticamente después de un pico de carga; requiere un reinicio manual de los pods.
-   **Prioridad:** Alta.
-   **Asignado a:** `[Equipo de Desarrollo / SRE]`
