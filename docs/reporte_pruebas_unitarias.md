# Reporte de Ejecución de Pruebas Unitarias

## 1. Propósito

Este documento registra los resultados de la ejecución de las pruebas unitarias para una versión específica del software. Sirve como evidencia del cumplimiento de la calidad a nivel de componente.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Responsable de la Ejecución:** `[Nombre del desarrollador o del pipeline]`
-   **Resultado General:** `[PASSED / FAILED]`

## 3. Resultados Detallados

| Módulo/Clase Probada | Total de Pruebas | Pruebas Exitosas | Pruebas Fallidas | Cobertura de Código |
| :--- | :--- | :--- | :--- | :--- |
| `ValidacionService` | 15 | 15 | 0 | 98% |
| `RegistroService` | 8 | 8 | 0 | 100% |
| `InscripcionRepository`| 12 | 11 | 1 | 95% |
| **Total** | **35** | **34** | **1** | **97%** |

## 4. Evidencias

-   **Captura de Pantalla de la Consola:**
    *(Adjuntar aquí una captura de pantalla o un log de la salida del framework de pruebas, ej. pytest)*

    ```
    ============================= test session starts ==============================
    ...
    tests/services/test_registro_service.py::test_registro_falla_db FAILED
    ========================= 1 failed, 34 passed in 5.80s =========================
    ```

-   **Reporte de Cobertura:**
    *(Adjuntar aquí una captura de pantalla o un enlace al reporte de cobertura de código, ej. de Codecov o similar)*

## 5. Defectos Encontrados

-   **ID del Defecto:** `BUG-001`
-   **Descripción:** La prueba `test_guardar_falla_si_duplicado` en `InscripcionRepository` no maneja correctamente la excepción de violación de unicidad.
-   **Prioridad:** Alta.
-   **Asignado a:** `[Nombre del desarrollador]`
