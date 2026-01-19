# Pruebas unitarias — Configuración institucional

Este instructivo detalla los comandos necesarios para preparar y ejecutar la suite de pruebas del módulo de configuraciones institucionales. Sigue cada bloque en orden para levantar los dobles de prueba, correr la suite y documentar los resultados.

## 1. Preparación del entorno

### 1.1 Posiciona la terminal en el proyecto

- **Windows (PowerShell):**
  ```powershell
  Set-Location "C:\ruta\al\repositorio\SEP_MUSES\web\muses-web"
  ```
- **Windows (CMD):**
  ```cmd
  cd C:\ruta\al\repositorio\SEP_MUSES\web\muses-web
  ```
- **Linux/macOS:**
  ```bash
  cd /ruta/al/repositorio/SEP_MUSES/web/muses-web
  ```

> Sustituye `ruta\al\repositorio` por el directorio real donde clonaste el proyecto.

### 1.2 Instala dependencias (solo la primera vez o tras cambios en `package.json`)

```bash
npm install
```

### 1.3 Expón el navegador para Karma

- **Windows (PowerShell):**
  ```powershell
  $Env:CHROME_BIN = "C:\Program Files\Google\Chrome\Application\chrome.exe"
  # Opcional: persistir en el perfil de usuario
  setx CHROME_BIN "C:\Program Files\Google\Chrome\Application\chrome.exe"
  ```
- **Windows (CMD):**
  ```cmd
  set CHROME_BIN=C:\Program Files\Google\Chrome\Application\chrome.exe
  rem Opcional: persistir en el perfil
  setx CHROME_BIN "C:\Program Files\Google\Chrome\Application\chrome.exe"
  ```
- **Linux/macOS:**
  ```bash
  export CHROME_BIN=$(which chromium-browser || which chromium || which google-chrome || which chrome)
  ```

## 2. Inspección rápida de los archivos a cubrir

Revisa el código objetivo antes de escribir las pruebas.

- **Windows (PowerShell):**
  ```powershell
  Get-ChildItem src/app/components/configuracion-instituciones
  Get-Content src/app/components/configuracion-instituciones/configuracion-instituciones.component.ts -TotalCount 160
  Get-ChildItem src/app/services | Where-Object { $_.Name -match 'configuracion' }
  Get-Content src/app/services/gestion-configuracion-formularios.service.ts -TotalCount 160
  Get-Content src/app/services/configuracion-formularios.service.ts -TotalCount 200
  ```
- **Windows (CMD):**
  ```cmd
  dir src\app\components\configuracion-instituciones
  powershell -Command "Get-Content src/app/components/configuracion-instituciones/configuracion-instituciones.component.ts -TotalCount 160"
  dir src\app\services | findstr configuracion
  powershell -Command "Get-Content src/app/services/gestion-configuracion-formularios.service.ts -TotalCount 160"
  powershell -Command "Get-Content src/app/services/configuracion-formularios.service.ts -TotalCount 200"
  ```
- **Linux/macOS:**
  ```bash
  ls src/app/components/configuracion-instituciones
  sed -n '1,160p' src/app/components/configuracion-instituciones/configuracion-instituciones.component.ts
  ls src/app/services | grep configuracion
  sed -n '1,160p' src/app/services/gestion-configuracion-formularios.service.ts
  sed -n '1,200p' src/app/services/configuracion-formularios.service.ts
  ```

## 3. Crear el archivo de pruebas del componente

1. Crea (o abre) el archivo `src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts`.
   - **Windows (PowerShell):**
     ```powershell
     New-Item -ItemType File src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts -Force
     notepad src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts
     ```
   - **Windows (CMD):**
     ```cmd
     type nul > src\app\components\configuracion-instituciones\configuracion-instituciones.component.spec.ts
     notepad src\app\components\configuracion-instituciones\configuracion-instituciones.component.spec.ts
     ```
   - **Linux/macOS:**
     ```bash
     touch src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts
     nano src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts
     ```

2. Copia este esqueleto como punto de partida y ajústalo según las reglas de negocio (campos obligatorios, restablecimiento, mensajes, etc.):

   ```typescript
   import { ComponentFixture, TestBed } from '@angular/core/testing';
   import { ReactiveFormsModule } from '@angular/forms';
   import { provideHttpClient } from '@angular/common/http';
   import { provideHttpClientTesting } from '@angular/common/http/testing';
   import { of, throwError } from 'rxjs';

   import { ConfiguracionInstitucionesComponent } from './configuracion-instituciones.component';
   import { GestionConfiguracionFormulariosService } from '../../services/gestion-configuracion-formularios.service';
   import {
     InstitucionFormularioConfiguracion,
     InstitucionFormularioResumen,
   } from '../../services/configuracion-formularios.service';

   const institucionesMock: InstitucionFormularioResumen[] = [
     { clave: 'A1', nombre: 'Institución A' },
     { clave: 'B2', nombre: 'Institución B' },
   ];

   const configuracionMock: InstitucionFormularioConfiguracion = {
     clave: 'A1',
     descripcion: 'Configuración demo',
     campos: {},
   };

   describe('ConfiguracionInstitucionesComponent', () => {
     let fixture: ComponentFixture<ConfiguracionInstitucionesComponent>;
     let component: ConfiguracionInstitucionesComponent;
     let gestionServiceSpy: jasmine.SpyObj<GestionConfiguracionFormulariosService>;

     beforeEach(async () => {
       gestionServiceSpy = jasmine.createSpyObj<GestionConfiguracionFormulariosService>(
         'GestionConfiguracionFormulariosService',
         ['listarInstituciones', 'obtenerConfiguracionCompleta', 'guardarConfiguracion']
       );

       gestionServiceSpy.listarInstituciones.and.returnValue(of(institucionesMock));
       gestionServiceSpy.obtenerConfiguracionCompleta.and.returnValue(of(configuracionMock));
       gestionServiceSpy.guardarConfiguracion.and.returnValue(of(configuracionMock));

       await TestBed.configureTestingModule({
         imports: [ConfiguracionInstitucionesComponent, ReactiveFormsModule],
         providers: [
           { provide: GestionConfiguracionFormulariosService, useValue: gestionServiceSpy },
           provideHttpClient(),
           provideHttpClientTesting(),
         ],
       }).compileComponents();

       fixture = TestBed.createComponent(ConfiguracionInstitucionesComponent);
       component = fixture.componentInstance;
       fixture.detectChanges();
     });

     it('debe crear el componente', () => {
       expect(component).toBeTruthy();
     });

     it('debe cargar instituciones al inicializarse', () => {
       expect(component.instituciones).toEqual(institucionesMock);
       expect(gestionServiceSpy.listarInstituciones).toHaveBeenCalled();
     });

     it('debe manejar errores al cargar configuraciones', () => {
       gestionServiceSpy.obtenerConfiguracionCompleta.and.returnValue(throwError(() => new Error('error')));

       component.seleccionarInstitucion('A1');

       expect(component.mensajeError).toContain('Ocurrió un problema al obtener la configuración');
     });

     it('debe mostrar mensaje de guardado exitoso', () => {
       component.seleccionarInstitucion('A1');
       component.guardarCambios();

       expect(component.mensajeGuardado).toContain('Los cambios se guardaron correctamente');
       expect(gestionServiceSpy.guardarConfiguracion).toHaveBeenCalled();
     });

     it('debe propagar mensaje de error si falla el guardado', () => {
       gestionServiceSpy.guardarConfiguracion.and.returnValue(throwError(() => new Error('fallo')));

       component.seleccionarInstitucion('A1');
       component.guardarCambios();

       expect(component.mensajeError).toContain('No se pudieron guardar los cambios');
     });
   });
   ```

## 4. Crear las pruebas del servicio de configuración

1. Crea el archivo `src/app/services/configuracion-formularios.service.spec.ts`.
   - **Windows (PowerShell):**
     ```powershell
     New-Item -ItemType File src/app/services/configuracion-formularios.service.spec.ts -Force
     notepad src/app/services/configuracion-formularios.service.spec.ts
     ```
   - **Windows (CMD):**
     ```cmd
     type nul > src\app\services\configuracion-formularios.service.spec.ts
     notepad src\app\services\configuracion-formularios.service.spec.ts
     ```
   - **Linux/macOS:**
     ```bash
     touch src/app/services/configuracion-formularios.service.spec.ts
     nano src/app/services/configuracion-formularios.service.spec.ts
     ```

2. Copia el siguiente esqueleto y añade casos adicionales para `guardarConfiguracion`, errores `4xx/5xx` y validaciones específicas del negocio:

   ```typescript
   import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
   import { TestBed } from '@angular/core/testing';
   import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

   import { ConfiguracionFormulariosService, InstitucionFormularioResumen } from './configuracion-formularios.service';

   describe('ConfiguracionFormulariosService', () => {
     let service: ConfiguracionFormulariosService;
     let httpMock: HttpTestingController;

     beforeEach(() => {
       TestBed.configureTestingModule({
         providers: [
           ConfiguracionFormulariosService,
           provideHttpClient(withInterceptorsFromDi()),
           provideHttpClientTesting(),
         ],
       });

       service = TestBed.inject(ConfiguracionFormulariosService);
       httpMock = TestBed.inject(HttpTestingController);
     });

     afterEach(() => {
       httpMock.verify();
     });

     it('debe recuperar el listado de instituciones', () => {
       const mockRespuesta: InstitucionFormularioResumen[] = [
         { clave: 'X1', nombre: 'Institución ejemplo' },
       ];

       service.listarInstituciones().subscribe((respuesta) => {
         expect(respuesta).toEqual(mockRespuesta);
       });

       const req = httpMock.expectOne('/api/configuracion/formularios/instituciones');
       expect(req.request.method).toBe('GET');
       req.flush(mockRespuesta);
     });
   });
   ```

## 5. Ejecutar solo la suite de configuraciones institucionales

Lanza Karma limitando la ejecución a los archivos recién creados:

```bash
npm test -- --watch=false --include "src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts" --include "src/app/services/configuracion-formularios.service.spec.ts" --browsers=ChromeHeadless
```

El mismo comando funciona en PowerShell o CMD. Si no cuentas con un navegador headless instalado, sustituye `ChromeHeadless` por `Chrome` (requiere que Chrome esté abierto) o ejecuta `npm test` sin parámetros para entrar en modo interactivo.

## 6. Registrar resultados en este documento

Una vez obtenida la salida, agrega un bloque con fecha y resumen usando alguno de los siguientes atajos:

- **Windows (PowerShell):**
  ```powershell
  Add-Content pruebas/configuracion-institucional.md "`n## Resultado $(Get-Date -Format 'yyyy-MM-dd HH:mm K')"
  Add-Content pruebas/configuracion-institucional.md "`n`````"
  npm test -- --watch=false --include "src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts" --include "src/app/services/configuracion-formularios.service.spec.ts" --browsers=ChromeHeadless 2>&1 | Tee-Object -FilePath pruebas/ultimo-ejecucion-configuracion.log
  Get-Content pruebas/ultimo-ejecucion-configuracion.log | Add-Content pruebas/configuracion-institucional.md
  Add-Content pruebas/configuracion-institucional.md "`````"
  ```
- **Linux/macOS:**
  ```bash
  date +'## Resultado %Y-%m-%d %H:%M %Z' >> pruebas/configuracion-institucional.md
  echo '\n````\n' >> pruebas/configuracion-institucional.md
  npm test -- --watch=false --include "src/app/components/configuracion-instituciones/configuracion-instituciones.component.spec.ts" --include "src/app/services/configuracion-formularios.service.spec.ts" --browsers=ChromeHeadless >> pruebas/configuracion-institucional.md 2>&1
  echo '\n````\n' >> pruebas/configuracion-institucional.md
  ```

Repite la sección de resultados cada vez que ejecutes la suite para mantener el historial actualizado. Si prefieres adjuntar solo un resumen manual, sustituye el bloque anterior por texto libre describiendo la fecha, comando lanzado y estado observado.
