# Reporte de Ejecución de Pruebas Funcionales (API)

## 1. Propósito

Este documento registra los resultados de la ejecución de las pruebas funcionales (End-to-End) realizadas sobre la API del sistema, validando los flujos de negocio completos.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **URL del Entorno de Pruebas:** `[Ej. https://api.qa.siged.gob.mx]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Responsable de la Ejecución:** `[Nombre del equipo o persona de QA]`
-   **Resultado General:** `[PASSED / FAILED]`

## 3. Resultados Detallados

| Endpoint y Escenario | Resultado | Evidencia (ID de Transacción / Captura) |
| :--- | :--- | :--- |
| `POST /api/eventos` - Inscripción exitosa | PASSED | `uuid: a1b2c3d4...` |
| `POST /api/eventos` - Inscripción con CURP inválida | PASSED | `Captura de error 400` |
| `POST /api/eventos` - Inscripción sin token de auth | FAILED | `Captura de error 401` |
| `GET /api/consultas/alumnos?curp=...` - Consulta exitosa | PASSED | `Captura de respuesta 200` |
| `GET /api/consultas/alumnos?curp=...` - Alumno no encontrado | PASSED | `Captura de respuesta 404` |

## 4. Evidencias

-   **Colección de Postman / Script de Pruebas:**
    *(Adjuntar enlace a la colección de Postman o al script utilizado para la ejecución)*

-   **Capturas de Pantalla de Fallos:**
    *(Adjuntar aquí capturas de pantalla de las respuestas de la API para los casos que fallaron)*

    **Fallo en `POST /api/eventos` sin autenticación:**
    ```json
    {
      "error": "No autorizado",
      "mensaje": "El token de autenticación no fue proporcionado o es inválido."
    }
    ```

## 5. Defectos Encontrados

-   **ID del Defecto:** `BUG-002`
-   **Descripción:** El endpoint `/api/eventos` no devuelve un `401 Unauthorized` cuando se le llama sin un token de autenticación, en su lugar devuelve un `500 Internal Server Error`.
-   **Prioridad:** Crítica.
-   **Asignado a:** `[Nombre del desarrollador]`
