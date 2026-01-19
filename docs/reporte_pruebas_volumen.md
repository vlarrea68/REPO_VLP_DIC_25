# Reporte de Ejecución de Pruebas de Volumen

## 1. Propósito

Este documento describe los resultados de las pruebas de volumen, diseñadas para evaluar el comportamiento y la capacidad del sistema SIGED al procesar grandes cantidades de datos.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Responsable de la Ejecución:** `[Equipo de QA / DBA]`

## 3. Escenario de Prueba

-   **Descripción:** Se ejecutó un proceso batch para insertar un gran volumen de registros en la base de datos, simulando la carga de datos de un ciclo escolar completo para una entidad federativa grande.
-   **Volumen de Datos:**
    -   `500,000` registros de alumnos.
    -   `1,500,000` registros de inscripciones.
    -   `10,000,000` de registros de evaluaciones.
-   **Métrica Principal:** Medir el tiempo total de procesamiento y el impacto en el rendimiento de las consultas durante y después de la carga.

## 4. Resultados

-   **Tiempo Total de Procesamiento:** La carga completa de datos tomó **3 horas y 45 minutos**.
-   **Consumo de Recursos:**
    -   **CPU:** Se mantuvo en un promedio del 75% durante la carga.
    -   **Memoria:** El uso de memoria de la base de datos aumentó en 2 GB.
    -   **Espacio en Disco:** El tamaño de la base de datos creció en 5 GB.
-   **Impacto en Consultas:** Las consultas de lectura en el portal de consulta se ralentizaron en un promedio del **30%** durante el proceso de carga masiva.

## 5. Evidencias

-   **Logs del Proceso Batch:**
    *(Adjuntar un extracto del log mostrando el inicio, progreso y finalización del script de carga)*
    ```
    INFO: Iniciando carga de datos de volumen...
    INFO: Insertando 500,000 alumnos... Completado.
    INFO: Insertando 1,500,000 inscripciones... Completado.
    INFO: Insertando 10,000,000 evaluaciones... Completado.
    INFO: Carga de datos finalizada en 3h 45m 12s.
    ```

-   **Métricas de Rendimiento de la Base de Datos:**
    *(Adjuntar gráficas del sistema de monitoreo de la base de datos mostrando CPU, memoria y I/O durante la prueba)*

## 6. Observaciones y Defectos

-   **Observación 1:** Se detectó que la falta de índices en la tabla `evaluaciones` en la columna `id_inscripcion` causó una degradación significativa del rendimiento durante la inserción.
-   **ID del Defecto:** `BUG-004`
-   **Descripción:** El proceso de carga no es transaccional por lotes, lo que podría dejar datos inconsistentes si falla a la mitad.
-   **Prioridad:** Media.
-   **Asignado a:** `[Equipo de Desarrollo]`
