# Diseño de Componentes y Guía de Estilo para `muses-web`

## 1. Propósito
Este documento establece los patrones de diseño, la estructura de componentes y las guías de estilo para el desarrollo de la aplicación Angular `muses-web`. Su objetivo es asegurar la consistencia, reutilización y mantenibilidad del código.

## 2. Estructura de Módulos y Componentes
La aplicación se organiza en los siguientes tipos de módulos:

- **CoreModule**: Servicios globales y de un solo uso (ej. `AuthService`, `LoggingService`, interceptores HTTP).
- **SharedModule**: Componentes, directivas y pipes reutilizables en toda la aplicación (ej. `LoadingSpinnerComponent`, `PermissionDirective`).
- **Feature Modules**: Módulos por funcionalidad de negocio, cargados de forma diferida (`lazy-loaded`).

Ejemplo de estructura para un _feature module_:
```
/inscripciones
  /components
    /inscripcion-form
      - inscripcion-form.component.ts
      - inscripcion-form.component.html
    /inscripcion-list
      - inscripcion-list.component.ts
      - inscripcion-list.component.html
  /services
    - inscripcion.service.ts
  /models
    - inscripcion.model.ts
  - inscripciones-routing.module.ts
  - inscripciones.module.ts
```

## 3. Arquitectura de Componentes "Smart/Dumb"

Se seguirá el patrón _Smart Components / Dumb Components_ para separar responsabilidades:

- **Smart Components (Contenedores):**
  - **Responsabilidad:** Orquestar la lógica de la vista. Interactúan con servicios, manejan el estado y pasan los datos a los componentes de presentación.
  - **Ejemplo:** `InscripcionListComponent` (un componente de consulta) llamaría a `AlumnoDataService` para obtener los datos. Un `InscripcionFormComponent` (un componente de escritura) llamaría a `EventoService` para enviar un nuevo evento de inscripción.

- **Dumb Components (Presentacionales):**
  - **Responsabilidad:** Mostrar datos y emitir eventos. No tienen conocimiento de los servicios ni del estado de la aplicación.
  - **Características:** Reciben datos a través de `@Input()` y comunican las interacciones del usuario a través de `@Output()`.
  - **Ejemplo:** `TablaGenericaComponent` recibe un array de datos y la configuración de las columnas, y emite un evento cuando se hace clic en una fila.

## 4. Gestión de Estado con NgRx

Para funcionalidades complejas como los formularios de carga masiva o la gestión de catálogos, se utilizará NgRx para una gestión de estado predecible.

- **Estructura del Estado:**
  ```
  /state
    /app.state.ts  (Estado global)
    /inscripciones
      - inscripciones.actions.ts
      - inscripciones.reducer.ts
      - inscripciones.effects.ts
      - inscripciones.selectors.ts
  ```
- **Flujo:**
  1. El componente despacha una **acción** (ej. `[Inscripciones] Cargar Inscripciones`).
  2. Un **efecto** escucha la acción, llama al servicio correspondiente (ej. `EventoService.enviarEvento()` o `AlumnoDataService.getAlumno()`) y despacha una nueva acción de éxito o fallo.
  3. El **reductor** escucha la acción de éxito/fallo y actualiza el estado inmutablemente.
  4. El componente se suscribe a un **selector** para obtener los datos del estado y actualizar la vista.

## 5. Formularios

- **Formularios Reactivos:** Se utilizará `ReactiveFormsModule` para todos los formularios. Ofrece mayor control, facilidad para las pruebas unitarias y manejo de validaciones complejas.
- **Validadores Personalizados:** Las reglas de negocio complejas (ej. validar que una fecha está dentro de un ciclo escolar) se implementarán como validadores personalizados reutilizables.
- **Manejo de Errores:** Se creará un componente `FormControlErrorComponent` que se encargue de mostrar los mensajes de error de un `FormControl` de manera consistente en toda la aplicación.

## 6. Servicios e Interacción con API

- **Servicios por Módulo:** Cada _feature module_ tendrá sus propios servicios para encapsular la lógica de negocio y las llamadas a la API.
- **Interceptor HTTP:** Se implementará un `HttpInterceptor` para:
  - Añadir el token de autenticación JWT a todas las peticiones salientes.
  - Manejar errores HTTP de manera centralizada (ej. redirigir a login en un error 401).
  - Mostrar un indicador de carga global durante las peticiones HTTP.

## 7. Guía de Estilo y Calidad de Código

- **Guía de Estilo Angular:** Se seguirá estrictamente la [Guía de Estilo Oficial de Angular](https://angular.io/guide/styleguide).
- **Linting:** Se utilizará `eslint` con las reglas recomendadas para Angular para asegurar la consistencia del código. El _linter_ se ejecutará automáticamente en cada `commit`.
- **Pruebas Unitarias:**
  - Se utilizará **Jasmine** y **Karma**.
  - Todos los componentes y servicios deben tener pruebas unitarias.
  - Se debe alcanzar una cobertura de código mínima del **80%** por módulo.
- **Pruebas End-to-End (E2E):**
  - Se utilizará **Playwright** para probar los flujos de usuario críticos.
  - Las pruebas E2E se ejecutarán en el pipeline de CI/CD antes de cada despliegue a QA y Producción.

## 8. Consideraciones de Rendimiento

- **Carga Diferida (`Lazy Loading`):** Todos los _feature modules_ deben ser cargados de forma diferida para reducir el tamaño del paquete inicial.
- **Estrategia de Detección de Cambios `OnPush`:** Los componentes de presentación (`dumb components`) deben usar `ChangeDetectionStrategy.OnPush` para optimizar el rendimiento.
- **TrackBy en `*ngFor`:** Utilizar siempre la función `trackBy` en los bucles `*ngFor` para evitar que el DOM se vuelva a renderizar innecesariamente.
- **Virtual Scrolling:** Para listas muy largas (ej. historial de transacciones), se utilizará el `ScrollingModule` del CDK de Angular para renderizar solo los elementos visibles.
