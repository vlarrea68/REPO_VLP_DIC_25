# Documentación de pruebas

Esta carpeta concentra la evidencia y el paso a paso para ejecutar las pruebas automatizadas que acompañan a los módulos de carga masiva.

## Panorama actual (octubre 2025)

- Las validaciones automatizadas disponibles se ejecutan en Python 3.11.
- Las suites unitarias utilizan `pytest` sobre las utilidades de `stress_formulario_masivo.py`.
- La campaña de pruebas funcionales se complementa con el script de estrés, sin colecciones de Postman porque aún no se habilitan APIs públicas.
- El material histórico para pruebas Angular se conserva más abajo como referencia para fases futuras.

## Cómo ejecutar las pruebas

### Pruebas unitarias en Python

1. Posiciona la terminal en la raíz del repositorio:
   ```bash
   cd SEP_MUSES
   ```
2. Crea y activa (opcional) un entorno virtual con Python 3.11.
3. Instala `pytest` si aún no está disponible:
   ```bash
   python3 -m pip install --upgrade pip
   python3 -m pip install pytest==7.4.3
   ```
4. Ejecuta la suite unitaria:
   ```bash
   pytest -q pruebas/tests/test_stress_formulario.py
   ```
5. Consulta el reporte generado en `pruebas/reportes/pytest-AAAAmmdd.txt`.

### Script de estrés

1. Posiciona la terminal en la raíz del proyecto web:
   ```bash
   cd web/muses-web
   ```
2. Asegúrate de tener las dependencias instaladas:
   ```bash
   npm install
   ```
3. Si es la primera vez en la máquina (o si aparece el error `No binary for ChromeHeadless browser`), instala un navegador compatible.

   **Ubuntu/Debian**

   ```bash
   sudo apt-get update
   sudo apt-get install -y chromium-browser
   ```

   **Fedora/CentOS**

   ```bash
   sudo dnf install -y chromium
   ```

   **Windows**

   1. Descarga [Google Chrome](https://www.google.com/chrome/) o [Chromium](https://download-chromium.appspot.com/) en formato `.exe`.
   2. Instálalo con permisos de administrador.

   **macOS**

   ```bash
   brew install --cask google-chrome
   ```

   > 💡 Si la máquina no tiene acceso a internet (como en entornos aislados), solicita al administrador el paquete `.deb`, `.rpm` o `.pkg` de Chromium/Chrome y procede con la instalación manual.

4. Expón la ruta del binario para que Karma lo pueda lanzar en modo headless:

   ```bash
   export CHROME_BIN=$(which chromium-browser || which chromium || which google-chrome || which chrome)
   ```

   En Windows PowerShell utiliza:

   ```powershell
   $Env:CHROME_BIN = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
   ```

5. Ejecuta la suite de pruebas unitarias en modo no interactivo:

   ```bash
   npm test -- --watch=false --browsers=ChromeHeadless
   ```

6. Revisa el resultado directamente en la consola. Karma muestra un resumen con el total de pruebas exitosas o fallidas. Si habilitas cobertura, también se generará la carpeta `coverage/`.

## Último resultado obtenido en este entorno

La ejecución más reciente (4 nov 2025, `npm test -- --watch=false --browsers=ChromeHeadless`) terminó con un error porque no se encontró un binario de ChromeHeadless disponible:

```
ERROR [launcher]: No binary for ChromeHeadless browser on your platform.
Please, set "CHROME_BIN" env variable.
```

En este entorno aislado tampoco es posible descargar navegadores mediante `apt-get` o `npm` (el proxy devuelve `403 Forbidden`), por lo que la ejecución queda bloqueada hasta que se provea manualmente el binario. Mientras no exista un navegador compatible en el sistema, las pruebas seguirán fallando en la fase de lanzamiento del navegador, aun cuando el código de los casos de prueba sea válido.

## Prueba de estrés para el formulario de carga masiva

Para evaluar la resiliencia del endpoint `/eventos/carga-masiva` sin depender de
herramientas externas, se incluye el script `pruebas/stress_formulario_masivo.py`.
Permite lanzar múltiples solicitudes concurrentes con un archivo CSV real y
obtener métricas de latencia y tasa de éxitos.

### Ejemplos de ejecución

**PowerShell (Windows):**

```powershell
python pruebas/stress_formulario_masivo.py `
  --endpoint http://localhost:4200/v1/eventos/carga-masiva `
  --csv C:\ANGULAR\SEP_MUSES\pruebas\plantilla-inscripcion-masiva.csv `
  --requests 10 `
  --concurrency 2
```

> El script expande variables de entorno y rutas relativas/absolutas, por lo que puedes usar notación de Windows (`C:\ruta`) o Unix (`/ruta`).

**macOS o Linux:**

```bash
python3 pruebas/stress_formulario_masivo.py \
  --endpoint https://api.qa.muses.sep.gob.mx/v1/eventos/carga-masiva \
  --csv /ruta/al/layout.csv \
  --requests 200 \
  --concurrency 25 \
  --api-key "API_KEY_DE_PRUEBAS"
```

Argumentos relevantes:

- `--requests`: total de peticiones a enviar.
- `--concurrency`: número máximo de hilos simultáneos.
- `--api-key` y `--api-key-header`: credenciales a utilizar (por defecto `X-API-Key`).
- `--header`: agregar encabezados adicionales (`--header "X-Trace-Id:abc123"`).
- `--output`: guarda el resumen en JSON para anexarlo como evidencia.
- `--verbose`: imprime la salida de cada solicitud en `stderr`.

Antes de iniciar la ráfaga, el script valida que el host y el puerto del
endpoint estén escuchando. Si el servicio no está levantado (por ejemplo, si no
has iniciado `ng serve` o el backend QA), la herramienta detendrá la ejecución
con un mensaje similar a `No se pudo establecer conexión con host:puerto`. En
caso de que llegues a ver el resumen con todos los intentos fallidos y la nota
"el endpoint rechazó la conexión", revisa:

1. Que el servidor esté en ejecución y acepte peticiones POST en la ruta `/v1/eventos/carga-masiva`.
2. Que no exista un firewall bloqueando el puerto especificado.
3. Que la URL use el protocolo correcto (`http://` para servicios locales sin TLS, `https://` cuando corresponde).

Si apuntas a `http://localhost:4200` y todas las solicitudes fallan por conexión rechazada, recuerda que ese puerto suele corresponder a `ng serve`; asegúrate de que el servidor de desarrollo esté arriba y que el proxy a la API esté configurado, o bien apunta directamente al backend (por ejemplo `http://localhost:8080`).

Cuando el backend responde con `404` en todos los intentos, el resumen incluye una nota adicional. Si dicha nota menciona que se devolvió la página genérica de Angular (mensaje `Cannot POST /v1/eventos/carga-masiva`), significa que el script está contactando al servidor de `ng serve` y no a la API. Corrige el endpoint hacia la URL del backend real o configura el proxy de Angular para que redirija `/v1/eventos/carga-masiva`. Si la nota solo indica que todas las peticiones obtuvieron 404, valida que el microservicio exponga la ruta y acepte solicitudes POST.

> ⚠️ En entornos QA donde el certificado TLS sea auto-firmado puedes añadir
> `--insecure` para deshabilitar la validación; evita usarlo en producción.

## Próximos pasos sugeridos

Consulta `pruebas/resumen-ejecuciones.md` para ver una síntesis de los comandos ejecutados y los resultados obtenidos hasta el momento.

Consulta `pruebas/plan-siguiente-fases.md` para conocer la ruta recomendada de nuevas suites: configuraciones institucionales, formulario individual, pruebas de interfaz (TestBed/E2E) y ejercicios de rendimiento y resiliencia. Cada sección incluye objetivos, pasos concretos y los archivos donde registrar evidencias.

- Para continuar con el formulario individual, apóyate en la guía `pruebas/formulario-individual.md`.
- Para iniciar la siguiente fase (configuraciones institucionales) sigue los comandos descritos en `pruebas/configuracion-institucional.md`.
