# Pruebas de `CargaMasivaComponent`

- **Ubicación del componente:** `web/muses-web/src/app/components/carga-masiva/carga-masiva.component.ts`
- **Suite de pruebas:** `web/muses-web/src/app/components/carga-masiva/carga-masiva.component.spec.ts`
- **Objetivo:** Asegurar la interacción correcta de la interfaz para carga de archivos CSV, filtrado, paginación y manejo de almacenamiento local.

## Casos de prueba cubiertos

| Identificador | Descripción | Resultado esperado |
| --- | --- | --- |
| `creación del componente` | Verifica la instanciación inicial. | El componente se crea satisfactoriamente. |
| `botón deshabilitado sin archivo` | Evalúa el estado del botón de envío cuando no hay archivo seleccionado. | El botón permanece deshabilitado. |
| `procesamiento del archivo` | Simula la selección y envío de un CSV. | Se invoca `procesarArchivo` y se almacenan dos registros. |
| `persistencia en localStorage` | Almacena registros procesados. | Se guarda la clave `cargaMasivaRegistros` y contiene dos registros. |
| `restaurar registros previos` | Inicializa el componente con datos en localStorage. | Carga los registros almacenados durante `ngOnInit`. |
| `descarga de plantilla` | Solicita la plantilla CSV desde el servicio. | Se llama al servicio y se dispara la descarga. |
| `ver detalle` | Selecciona un registro para navegar al detalle. | Se invoca `establecerRegistroSeleccionado` y se navega a la ruta `carga-masiva/detalle`. |
| `modal de requisitos` | Abre y cierra el diálogo informativo. | El estado interno cambia a `true`/`false` según la acción. |
| `limpiar registros guardados` | Limpia datos persistidos manualmente. | El arreglo de registros queda vacío y se reinicia el estado del componente. |
| `filtrado por término y flujo` | Aplica filtros combinados. | Reduce la lista según flujo y coincidencias del término de búsqueda. |
| `paginación` | Cambia tamaño de página y navega entre páginas. | Calcula páginas totales, permite avanzar e ir a la última página. |
| `limpiar selección` | Resetea formulario y filtros. | Formulario vuelve a valores por defecto, sin mensajes de error ni término de búsqueda. |
| `cancelar procesamiento` | Cancela una suscripción activa. | Se invoca `unsubscribe`, cambia el estado a `cancelado` y muestra mensaje de cancelación. |
| `localStorage corrupto` | Simula datos inválidos en almacenamiento. | No se cargan registros y se muestra mensaje de error de recuperación. |
| `sin espacio en localStorage` | Fuerza `QuotaExceededError` al guardar. | Se informa que no fue posible guardar los registros en el navegador. |

## Evidencia de ejecución

La ejecución de `npm test -- --watch=false --browsers=ChromeHeadless` no finalizó porque falta el binario de ChromeHeadless en el entorno actual. Se debe instalar un navegador compatible o exponer la variable `CHROME_BIN` para obtener resultados.
