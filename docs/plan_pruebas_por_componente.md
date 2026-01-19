# Plan de Pruebas por Módulo

## 1. Introducción
Este documento describe el plan de pruebas para los módulos clave del sistema SEP-MUSES. El objetivo es definir los tipos de prueba, los casos de uso a cubrir y los criterios de aceptación para cada componente funcional.

## 2. Módulo de Recepción de Datos (API)

| Tipo de Prueba | Objetivo | Casos de Prueba Clave | Criterio de Aceptación |
|---|---|---|---|
| **Pruebas Unitarias** | Validar la lógica interna del API de recepción. | - `test_validar_csv_correcto`: Probar con un archivo CSV que cumple el layout.<br>- `test_rechazar_csv_con_columnas_incorrectas`: Probar con un CSV que no cumple el layout.<br>- `test_publicar_mensaje_cola`: Verificar que un archivo válido resulta en un mensaje publicado en la cola. | 95% de cobertura de código en los controladores y validadores de archivos. |
| **Pruebas de Integración** | Asegurar que la API se comunica correctamente con la cola de mensajes. | - `test_flujo_completo_recepcion`: Enviar un archivo CSV válido y verificar que un mensaje con la ruta al archivo aparece en la cola. | Un mensaje enviado por la API debe ser consumible por un worker de prueba. |
| **Pruebas de Carga** | Medir el rendimiento bajo estrés. | - Simular 500 peticiones por segundo durante 5 minutos. | El tiempo de respuesta promedio debe mantenerse por debajo de 500ms y la tasa de error debe ser < 0.1%. |

## 3. Módulo de Procesamiento (Worker)

| Tipo de Prueba | Objetivo | Casos de Prueba Clave | Criterio de Aceptación |
|---|---|---|---|
| **Pruebas Unitarias** | Validar la lógica de negocio de forma aislada. | - `test_validar_curp_exitosa`: Probar con una CURP válida (usando un mock de RENAPO).<br>- `test_validar_curp_fallida`: Probar con una CURP inválida.<br>- `test_transformar_datos_inscripcion`: Verificar que los datos crudos se mapean correctamente al modelo de la BD central. | 85% de cobertura de código en los servicios de validación y transformación. |
| **Pruebas de Integración** | Verificar la correcta interacción con las bases de datos y servicios externos. | - `test_procesar_inscripcion_completa`: Consumir un mensaje de la cola, validarlo contra mocks de RENAPO/CCT y verificar que se escribe en la BD Staging y Central.<br>- `test_manejo_error_validacion`: Consumir un mensaje con datos inválidos y verificar que se registra el error en la BD Staging. | Un registro procesado debe reflejarse correctamente en las bases de datos según el resultado de la validación. |

## 4. Módulo de Consulta (Frontend y API de Consulta)

| Tipo de Prueba | Objetivo | Casos de Prueba Clave | Criterio de Aceptación |
|---|---|---|---|
| **Pruebas Unitarias (Frontend)** | Validar componentes de la UI de forma aislada. | - `test_renderizar_formulario_busqueda`: El componente de búsqueda se muestra correctamente.<br>- `test_validar_input_curp`: El formulario valida el formato de la CURP en tiempo real. | 90% de cobertura en componentes críticos (formularios, tablas de datos). |
| **Pruebas E2E (End-to-End)** | Simular el flujo completo desde la perspectiva del usuario. | - **Escenario 1:** Un usuario inicia sesión, navega a la página de consulta, ingresa una CURP válida, y ve el historial académico del alumno.<br>- **Escenario 2:** Un usuario intenta buscar con una CURP inválida y recibe un mensaje de error. | Todos los escenarios de prueba definidos en la matriz de trazabilidad deben pasar sin errores. |
| **Pruebas de Usabilidad** | Evaluar la facilidad de uso de la interfaz. | - Observar a un usuario de control escolar mientras intenta realizar una consulta. | El usuario debe ser capaz de completar la tarea en menos de 2 minutos sin necesidad de asistencia. |