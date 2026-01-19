# Interpretación de la prueba de estrés del formulario masivo

Este documento explica cómo leer los resultados generados por `stress_formulario_masivo.py` y qué acciones tomar ante los escenarios más comunes. Usa esta guía para acompañar la ejecución descrita en `pruebas/README.md` y registrar conclusiones en `resumen-ejecuciones.md`.

## 1. Elementos clave del resumen
El script produce un objeto JSON con métricas generales y, cuando hay fallos, incluye un arreglo `detalle_fallos`. Los campos más relevantes son:

| Campo | Significado | Cómo interpretarlo |
| --- | --- | --- |
| `endpoint` | URL que recibió las solicitudes | Confirma que coincide con el backend esperado (no el servidor de Angular). |
| `total_solicitudes` | Cantidad total de peticiones lanzadas | Debe corresponder al valor pasado en `--requests`. |
| `concurrencia` | Número máximo de hilos simultáneos | Depende de `--concurrency`; si es mayor que las solicitudes, se ajusta automáticamente. |
| `duracion_total_segundos` | Tiempo total de la campaña | Incluye la ejecución completa desde la primera hasta la última petición. |
| `peticiones_por_segundo` | Throughput promedio | Divide `total_solicitudes` entre `duracion_total_segundos`. |
| `exitos` / `fallos` | Conteo de respuestas 2xx frente a errores | Prioriza investigar cuando `fallos` sea mayor que cero. |
| `latencia_*` | Promedios y percentiles (ms) | Evalúa si cumplen con los acuerdos de nivel de servicio. |
| `nota` | Mensaje contextual del script | Aparece cuando todas las solicitudes fallan por una misma causa (p. ej. conexión rechazada, 404 genérico). |
| `detalle_fallos` | Lista de objetos por petición | Incluye índice, estatus HTTP y mensaje de error asociado. |

## 2. Escenarios frecuentes

### 2.1 Conexión rechazada (`WinError 10061`, `Connection refused`)
- **Síntomas**: `status` en `null`, mensaje con “No se puede establecer una conexión…”.
- **Acciones**:
  1. Verifica que el backend esté en ejecución y escuche en el host/puerto indicado.
  2. Si usas `localhost:4200`, confirma que existe un proxy que redirija a la API. De lo contrario, cambia el endpoint a la URL real del servicio (por ejemplo `http://localhost:8080/v1/eventos/carga-masiva`).
  3. Repite la prueba y registra el resultado actualizado.

### 2.2 Respuestas 404 con la página de Angular
- **Síntomas**: `status` 404, cuerpo similar a `Cannot POST /v1/eventos/carga-masiva`, `nota` indica que la URL apunta a `ng serve`.
- **Acciones**:
  1. Ajusta el endpoint al dominio del backend (`/api/v1` según la arquitectura publicada) o configura un proxy inverso en Angular que reenvíe las solicitudes.
  2. Valida con una herramienta como `curl` que el backend responde 200 o 202 antes de volver a lanzar la prueba de estrés.

### 2.3 Respuestas 4xx/5xx del backend real
- **Síntomas**: `status` igual al código HTTP devuelto (400, 401, 422, 500, etc.).
- **Acciones**:
  1. Consulta los logs del backend para identificar validaciones fallidas o errores internos.
  2. Ajusta los datos del CSV (campos obligatorios, formatos, catálogos) y vuelve a ejecutar.
  3. Documenta el comportamiento en `resumen-ejecuciones.md`, incluyendo número de registros fallidos.

### 2.4 Éxitos parciales
- **Síntomas**: `exitos` > 0 pero `fallos` también > 0.
- **Acciones**:
  1. Revisa `detalle_fallos` para aislar filas con errores.
  2. Si el backend expone un reporte de errores por registro, descárgalo y correlaciona con el índice (`index`) mostrado por el script.
  3. Ajusta el CSV o reglas de negocio según corresponda y ejecuta de nuevo para confirmar el remediado.

### 2.5 Éxito total
- **Síntomas**: `fallos` = 0, `exitos` = `total_solicitudes`, percentiles dentro del umbral aceptado.
- **Acciones**:
  1. Guarda el resumen JSON (`--output`) y adjúntalo en la evidencia de QA.
  2. Actualiza `resumen-ejecuciones.md` con el throughput alcanzado y cualquier observación relevante (por ejemplo, uso de recursos).

## 3. Registro de resultados
1. Copia el objeto JSON impreso en la terminal.
2. Pega el contenido en la sección correspondiente de `pruebas/resumen-ejecuciones.md`, agregando fecha, entorno, parámetros (`requests`, `concurrency`, `timeout`) y conclusiones.
3. Anexa capturas de monitoreo o métricas externas si forman parte de la evidencia de la campaña.

## 4. Buenas prácticas adicionales
- Ejecuta la prueba sobre entornos controlados para evitar afectar servicios productivos.
- Inicia con cargas pequeñas (`--requests 10`) para validar conectividad antes de escalar.
- Si necesitas más detalle por solicitud, añade `--verbose` y redirige la salida a un archivo (`2> stress.log`).
- Ajusta `--timeout` según el SLA del backend para evitar falsos negativos en operaciones largas.

Con esta guía podrás interpretar los resultados y comunicar hallazgos de manera consistente en las bitácoras de QA.
