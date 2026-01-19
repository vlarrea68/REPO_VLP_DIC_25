# Guía de pruebas unitarias — formulario individual

Esta guía documenta cómo preparar, ejecutar y registrar las pruebas del formulario individual de inscripción/baja que vive en `web/muses-web/src/app/components/inscripcion`. Incluye atajos para Windows (PowerShell y CMD) y alternativas para macOS/Linux.

## 1. Preparación del entorno

1. Abre una terminal y sitúate en la raíz del proyecto web:
   - **Windows (PowerShell)**
     ```powershell
     Set-Location "C:\\ruta\\al\\repositorio\\SEP_MUSES\\web\\muses-web"
     ```
   - **Windows (CMD)**
     ```cmd
     cd C:\\ruta\\al\\repositorio\\SEP_MUSES\\web\\muses-web
     ```
   - **macOS/Linux**
     ```bash
     cd /ruta/al/repositorio/SEP_MUSES/web/muses-web
     ```
   > Sustituye `ruta\\al\\repositorio` por el directorio real donde clonaste el proyecto.
2. Instala las dependencias si aún no lo has hecho:
   ```bash
   npm install
   ```
3. Verifica que existe un navegador compatible para Karma. Si usas Windows y ya cuentas con Google Chrome, expón la ruta antes de correr las pruebas:
   - **Windows (PowerShell)**
     ```powershell
     $Env:CHROME_BIN = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
     ```
   - **Windows (CMD)**
     ```cmd
     set CHROME_BIN=C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe
     ```
   - **macOS/Linux**
     ```bash
     export CHROME_BIN=$(which chromium-browser || which chromium || which google-chrome || which chrome)
     ```

## 2. Inspección del código a cubrir

1. Revisa el componente principal: `src/app/components/inscripcion/inscripcion.component.ts`. Identifica:
   - La construcción del `FormGroup` con validaciones y campos condicionados (`modoBaja`, `camposOpcionales`).
   - El manejo de catálogos (`CatalogosService`) y carga dinámica de opciones.
   - La persistencia local (`registrosGuardados`, `mensajeGuardado`) y la navegación (`Router`).
2. Ubica el `spec` existente en `src/app/components/inscripcion/inscripcion.component.spec.ts`. Actualmente valida la creación del componente, los campos de baja y la navegación entre flujos; úsalo como punto de partida para extender los casos.
3. Si existen servicios auxiliares (por ejemplo `src/app/services/configuracion-formularios.service.ts` o `gestion-configuracion-formularios.service.ts`), revisa qué métodos son invocados durante el guardado o la recuperación de configuraciones.

## 3. Generación o actualización de pruebas

1. Abre el archivo `inscripcion.component.spec.ts` y añade escenarios con `describe/it` o `describe.each` que cubran:
   - Validaciones de campos obligatorios y formateo de CURP, CCT y fechas.
   - Habilitación/deshabilitación dinámica según la configuración institucional aplicada.
   - Persistencia en `localStorage`: simulación de lecturas exitosas, datos corruptos y falta de espacio.
   - Mensajes de error o navegación condicionada al flujo (`inscripción`, `baja`, `reincorporación`).
2. Para aislar dependencias, usa `TestBed` con stubs:
   ```typescript
   const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
   await TestBed.configureTestingModule({
     imports: [RouterTestingModule.withRoutes([]), InscripcionComponent],
     providers: [{ provide: Router, useValue: routerSpy }],
   }).compileComponents();
   ```
3. Si necesitas generar archivos de prueba adicionales, apóyate en el CLI de Angular (opcional). Ejemplo desde PowerShell/CMD/Linux:
   ```bash
   npx ng generate service services/formulario-individual --skip-tests=false
   ```
   (Sustituye la ruta según el servicio real que debas cubrir.)

## 4. Ejecución focalizada mientras desarrollas casos

1. Durante el ajuste de los casos, utiliza `fdescribe` o `fit` para enfocarte en escenarios específicos.
2. Lanza la suite en modo no interactivo (el comando es el mismo en todas las plataformas una vez configurado `CHROME_BIN`):
   ```bash
   npm test -- --watch=false --browsers=ChromeHeadless --main=src/app/components/inscripcion/inscripcion.component.spec.ts
   ```
   Ajusta la ruta del `--main` si decides dividir los casos en varios archivos.
3. Si Karma sigue sin localizar el navegador, cambia temporalmente a modo gráfico:
   ```bash
   npm test -- --watch=false --browsers=Chrome
   ```
   (Angular abrirá la ventana de Chrome instalada en el sistema.)

## 5. Documentación de resultados

1. Tras cada ejecución, registra la evidencia en esta misma guía en la sección "Evidencia de ejecución" (añádela al final). Incluye fecha, comando lanzado y salida relevante.
2. Resume los escenarios cubiertos (pases y fallos) junto con pendientes o hipótesis detectadas.
3. En caso de fallas por falta de navegador o dependencias externas, documenta los mensajes exactos para facilitar su reproducción.

## 6. Próximos pasos

Una vez estabilizada la suite de formulario individual y documentadas las ejecuciones recientes, regresa a `pruebas/plan-siguiente-fases.md` para continuar con las pruebas de interfaz (TestBed integrador y end-to-end) y, posteriormente, con los ejercicios de rendimiento y resiliencia.

---

### Evidencia de ejecución (ejemplo a completar)

| Fecha | Comando | Resultado |
| --- | --- | --- |
| _Pendiente_ | `npm test -- --watch=false --browsers=ChromeHeadless --main=src/app/components/inscripcion/inscripcion.component.spec.ts` | _Documenta aquí el resumen de la salida (pases/fallas o errores de entorno)._ |

Actualiza la tabla conforme obtengas resultados reales en tu entorno.
