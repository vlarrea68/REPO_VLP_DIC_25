# Reporte de Ejecución de Pruebas de Integración

## 1. Propósito

Este documento registra los resultados de la ejecución de las pruebas de integración, que verifican la correcta colaboración entre los componentes internos del sistema.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Responsable de la Ejecución:** `[Nombre del equipo o persona de QA]`
-   **Resultado General:** `[PASSED / FAILED]`

## 3. Resultados Detallados

| Flujo de Integración Probado | Total de Casos | Casos Exitosos | Casos Fallidos |
| :--- | :--- | :--- | :--- |
| `Servicio de Registro -> Repositorio -> BD` | 5 | 5 | 0 |
| `Servicio de Validación -> Cliente RENAPO (Mock)` | 3 | 3 | 0 |
| `Servicio de Consulta -> Repositorio` | 4 | 4 | 0 |
| **Total** | **12** | **12** | **0** |

## 4. Evidencias

-   **Log de Ejecución de Pruebas:**
    *(Adjuntar aquí el log de la herramienta de pruebas, mostrando la ejecución de los casos de prueba de integración)*

    ```
    INFO: Running integration test suite...
    TEST: test_registro_service_guarda_en_db ... PASSED
    TEST: test_validacion_service_con_renapo ... PASSED
    ...
    ----------------------------------------------------------------------
    Ran 12 tests in 15.345s

    OK
    ```

## 5. Defectos Encontrados

-   **ID del Defecto:** `N/A`
-   **Descripción:** No se encontraron defectos en esta ejecución.
-   **Prioridad:** N/A
-   **Asignado a:** N/A
