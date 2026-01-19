# Pruebas de `CargaMasivaService`

- **Ubicación del código probado:** `web/muses-web/src/app/services/carga-masiva.service.ts`
- **Suite de pruebas:** `web/muses-web/src/app/services/carga-masiva.service.spec.ts`
- **Objetivo:** Validar la ingestión y procesamiento de archivos CSV que alimentan la carga masiva de alumnos.

## Casos de prueba cubiertos

| Identificador | Descripción | Resultado esperado |
| --- | --- | --- |
| `procesar archivo CSV válido` | Procesa un archivo con encabezados completos y dos registros válidos. | Evento final con estado `completado`, resumen con 2 registros válidos y avance mayor a 0. |
| `faltan encabezados obligatorios` | Envía un CSV sin los encabezados requeridos. | El flujo termina en estado `error` con mensaje indicando encabezados faltantes. |
| `límite de 5 000 registros` | Crea un archivo con 5 001 filas de datos. | El servicio cancela el proceso informando que se superó el máximo permitido. |
| `procesamiento en lotes de 200` | Alimenta 450 registros válidos. | Se emiten tres lotes (200, 200 y 50) y el estado final es `completado` con 3 lotes totales. |
| `generar plantilla` | Solicita el CSV de ejemplo. | Se devuelve un texto con encabezados obligatorios y al menos una fila de ejemplo. |
| `generar CSV de errores` | Construye un detalle de errores simulados. | El resultado contiene encabezado `linea,mensajes,contenido_original` y tantas filas como errores. |
| `encabezados esperados` | Consulta la lista de encabezados. | Devuelve un arreglo no vacío que incluye `folio_control`. |
| `selección para detalle` | Guarda y limpia un registro seleccionado. | Permite persistir un registro en memoria y limpiarlo (obteniendo `null`). |

## Evidencia de ejecución

La última ejecución con `npm test -- --watch=false --browsers=ChromeHeadless` no pudo completarse porque el entorno carece de un binario de ChromeHeadless. Es necesario configurar `CHROME_BIN` o instalar un navegador compatible para obtener resultados exitosos.
