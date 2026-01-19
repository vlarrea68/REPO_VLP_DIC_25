# Arquitectura propuesta para el front-end Angular de SEP-MUSES

## 1. Contexto y alcance
La plataforma SEP-MUSES debe exponer flujos administrativos de inscripción, bajas, evaluaciones, certificaciones y actualización de catálogos en línea con el modelo nacional SIGED. El front-end Angular orquestará la captura manual y masiva de estos eventos, aplicando las reglas descritas en los layouts oficiales y consumiendo los catálogos normativos centralizados.

La arquitectura cubre:
- Aplicación Angular moderna y fluida, orientada a módulos funcionales.
- Integración con APIs de orquestación y validación.
- Gestión de estado y sincronización con catálogos y reglas.
- Observabilidad, seguridad y estrategia de entrega continua.

## 2. Principios arquitectónicos
1. **Modularidad de dominio**: cada evento administrativo se encapsula en un _feature module_ (Inscripción, Bajas, Evaluaciones, Certificación, Catálogos). Permite desplegar funcionalidades de forma incremental y controlar dependencias.
2. **Componentes declarativos y reutilizables**: formularios, tablas y asistentes de carga aprovechan librerías de UI (Angular Material, CDK) con componentes _standalone_ para validaciones y manejo de errores.
3. **Validación en origen**: se aplican reglas del layout desde el front-end mediante validadores compartidos y directivas que reflejan la lógica documentada.
4. **Estado centralizado**: NgRx (o alternativa basada en signals) para sincronizar formularios, catálogos y resultados de cargas masivas, permitiendo auditoría y reintentos.
5. **Interoperabilidad segura**: comunicación vía HTTPS con autenticación JWT/Keycloak y firma de eventos, alineada a la infraestructura propuesta para el sistema.
6. **Documentación viva**: cada módulo incluye _README_ y diagramas actualizables, versionados junto con el código para mantener la trazabilidad.

## 3. Capas lógicas
| Capa | Responsabilidades | Artefactos clave |
| --- | --- | --- |
| Presentación | Componentes Angular, rutas, guardas, internacionalización y accesibilidad. | `feature/*/components`, `app-routing`, traducciones. |
| Aplicación | Servicios de caso de uso, _facades_ NgRx, validadores compartidos. | `feature/*/services`, `state/*`. |
| Dominio | Modelos TipScript, reglas de negocio, mapeadores al layout SIGED. | `core/domain`, bibliotecas compartidas. |
| Infraestructura | Gateways HTTP, interceptores, manejo de errores, caching de catálogos. | `core/http`, `shared/data-access`. |

## 4. Módulos principales
- **CoreModule**: inicialización (configuración de entorno, interceptores, proveedores globales).
- **SharedModule**: componentes atómicos (inputs, selects, stepper, visor de errores) y pipes reutilizables.
- **Feature modules**:
  - `InscripcionesModule`: formulario dinámico, carga CSV basada en layout, historial de acuses.
  - `BajasModule`: formulario condicionado por tipo y motivo de baja, integración con historial académico.
  - `EvaluacionesModule`: captura de parciales/finales, importación desde sistemas locales.
  - `CertificacionModule`: emisión y seguimiento de certificados digitales, consulta de folios.
  - `CatalogosModule`: administración de catálogos, importaciones y reconciliación con catálogos externos.
- **AdminModule**: gestión de usuarios, roles, bitácoras y auditoría.

Cada módulo expone rutas hijas cargadas de forma diferida para optimizar tiempos de carga y facilitar despliegues parciales.

## 5. Gestión de datos y catálogos
- **Modelos tipados**: interfaces TypeScript alineadas con los campos del layout.
- **Servicios de catálogos**: caching local con expiración configurable; sincronización con catálogos nacionales.
- **Transformadores**: adaptadores para convertir formularios en payloads compatibles con las APIs y CSVs oficiales.
- **Bitácora de validaciones**: estructura común para registrar errores por campo, tanto en captura manual como masiva.

## 6. Integración con back-end
- **API de Recepción de Eventos**: Para el envío de datos (inscripciones, bajas, etc.), el frontend interactuará con un único endpoint de eventos: `POST /api/v1/eventos`. Un servicio genérico `EventoService` en Angular se encargará de construir el payload correcto según la acción del usuario.
- **API de Consulta**: Para la visualización de datos consolidados, el frontend consumirá endpoints específicos de lectura, como `GET /api/v1/alumnos/{curp}`. Un `AlumnoDataService` se encargará de estas llamadas.
- **Seguridad**: interceptores añaden tokens JWT y manejan refresh; guardas de ruta validan permisos (RBAC).
- **Observabilidad**: servicio `LoggingService` envía eventos relevantes a la plataforma de monitoreo.
- **Resiliencia**: reintentos exponenciales para catálogos, colas para cargas masivas (notificaciones de progreso por WebSocket).

## 7. Entornos y despliegue
- Configuraciones separadas (`environment.ts`) para _dev_, _qa_, _prod_.
- _Pipeline_ CI/CD (GitHub Actions) que ejecuta lint, pruebas unitarias y E2E (Playwright).
- Estrategia de despliegue _blue-green_ en hosting estático o contenedores.

## 8. Trazabilidad y documentación
- Documentar decisiones arquitectónicas con _ADR_.
- Automatizar generación de diagramas para mantener consistencia.
- Mantener enlaces cruzados con los documentos de requisitos para asegurar trazabilidad.

## 9. Próximas extensiones
- Implementar _micro frontends_ si otros equipos desarrollan módulos adicionales.
- Integrar analítica de uso para priorizar mejoras de UX.
- Incorporar mecanismos de _offline first_ para planteles con conectividad limitada.
