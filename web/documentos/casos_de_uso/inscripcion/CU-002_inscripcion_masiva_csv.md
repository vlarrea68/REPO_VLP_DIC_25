# CU-002 Inscripción masiva mediante archivo CSV

## Identificación
- **Nombre**: Inscripción masiva mediante archivo CSV
- **Actor primario**: Personal administrativo de control escolar
- **Actores secundarios**: Sistema SEP MUSES, Servicio de almacenamiento de archivos, Procesador de lotes de inscripción
- **Tipo**: Esencial
- **Prioridad**: Alta

## Breve descripción
Automatiza el registro de estudiantes a partir de la carga de un archivo CSV con los datos requeridos. El sistema valida únicamente la estructura del archivo (encabezados y formato), procesa cada registro de forma progresiva, muestra una tabla con los resultados, persiste el avance en el navegador y permite consultar un detalle completo por registro. La validación de datos se realiza en la capa de back-end.

## Precondiciones
- El usuario administrativo inició sesión con permisos para ejecutar cargas masivas.
- Se cuenta con la plantilla CSV oficial y las instrucciones de llenado disponibles desde la pantalla.
- Los grupos destino tienen cupo disponible.
- Existe conectividad hacia el servicio back-end encargado de validar y persistir los registros.

## Postcondiciones
- Se registran los estudiantes válidos en el sistema y se asocian a los grupos indicados.
- Se genera un resumen en pantalla con registros aceptados/rechazados y el progreso alcanzado.
- El último lote procesado queda disponible temporalmente en el navegador para continuar la revisión sin repetir la carga.

## Flujo principal
1. El usuario accede a la sección "Inscripción masiva".
2. El sistema muestra un resumen del proceso, botón de ayuda "Antes de comenzar" (modal con requisitos) y enlace para descargar la plantilla CSV.
3. El usuario selecciona y carga un archivo CSV desde su equipo.
4. El sistema valida la estructura del archivo (encabezados, codificación, delimitadores) y muestra los metadatos (nombre, tamaño, filas estimadas).
5. El usuario confirma el procesamiento del archivo.
6. El sistema procesa cada registro de forma progresiva, actualiza la barra de progreso y expone mensajes del servicio (p. ej. "Lote 3 de 10").
7. El sistema guarda el avance en `localStorage` y muestra una tabla con el resultado para cada estudiante (éxito o error con detalle resumido) incluyendo filtros y paginación.
8. El usuario puede seleccionar un registro para visualizar todos los campos capturados en una vista de detalle.
9. El sistema ofrece acciones para cancelar el procesamiento o limpiar la selección y reiniciar el flujo.

## Flujos alternos
- **FA1: Estructura de archivo inválida**
  1. En el paso 4, el sistema detecta que la estructura del archivo no coincide con la plantilla.
  2. El sistema muestra una alerta y evita continuar con el procesamiento.
  3. El flujo regresa al paso 3 para permitir subir un archivo válido.

- **FA2: Errores parciales en registros**
  1. Durante el paso 6, el back-end devuelve respuestas de error para algunos registros (CURP duplicada, campos vacíos, grupo sin cupo).
  2. El sistema marca dichos registros como rechazados en la tabla de resultados, muestra el motivo resumido y lo almacena en el lote local.
  3. El usuario puede exportar o consultar un reporte detallado (pendiente de integración) y corregir los datos para una carga posterior.
- **FA3: Cancelación voluntaria**
  1. El usuario presiona "Cancelar procesamiento" durante el paso 6.
  2. El sistema detiene la lectura del archivo, muestra el estado de cancelación y limpia el avance almacenado en el navegador.
  3. El flujo regresa al paso 2 para permitir una nueva carga.

## Requerimientos especiales
- Soportar archivos CSV en codificación UTF-8 con delimitador de coma.
- Validar un tamaño máximo del archivo (por ejemplo, 5 MB) y cantidad máxima de registros por lote.
- Mostrar barra de progreso y estado del procesamiento en tiempo real con mensajes emitidos por el servicio de carga.
- Almacenar el avance en `localStorage` para permitir reanudación después de refrescar el navegador.
- Garantizar idempotencia: si se procesa el mismo archivo dos veces, no deben duplicarse registros válidos.

## Reglas de negocio
- RB-004: Los registros con errores no se importan y deben quedar identificados en el reporte.
- RB-005: El folio de inscripción se genera de manera automática para cada estudiante registrado.
- RB-006: El sistema debe registrar trazabilidad de la carga (usuario, fecha, versión de la plantilla).
- RB-007: La validación de campos y catálogos se delega al back-end, el front-end solo bloquea archivos con encabezados incorrectos.

## Suposiciones
- El personal administrativo realiza una validación previa del archivo antes de cargarlo.
- Los servicios de almacenamiento y procesamiento cuentan con disponibilidad y escalabilidad adecuadas.
