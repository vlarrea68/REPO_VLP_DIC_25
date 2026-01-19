# Ruta de pruebas recomendadas

Este plan ordena las siguientes actividades sugeridas para ampliar la cobertura de calidad después de validar `CargaMasivaService` y `CargaMasivaComponent`.

## 1. Pruebas unitarias — configuraciones institucionales

**Objetivo:** Asegurar que los componentes y servicios encargados de administrar configuraciones institucionales validen reglas de negocio, manejo de catálogos y persistencia en `localStorage` o API.

**Pasos sugeridos**
1. Identificar los módulos involucrados (`web/muses-web/src/app/components/configuracion-instituciones` y servicios asociados).
2. Revisar qué dependencias externas requieren dobles de prueba (por ejemplo, `HttpClient`, `MatDialog`).
3. Crear o actualizar los archivos `*.spec.ts` para cubrir:
   - Validación de formularios y campos obligatorios.
   - Carga y guardado de configuraciones.
   - Manejo de errores cuando la API responde con códigos `4xx/5xx`.
4. Ejecutar la suite siguiendo los comandos detallados en `pruebas/configuracion-institucional.md`, usando filtros de Jasmine (`fdescribe`/`fit`) hasta estabilizar los casos.
5. Registrar resultados en `pruebas/configuracion-institucional.md`.

## 2. Pruebas unitarias — formulario individual

**Objetivo:** Validar el flujo completo del formulario individual, contemplando validaciones de campos, anexos y persistencia temporal.

**Pasos sugeridos**
1. Ubicar el componente (`web/muses-web/src/app/components/formulario-individual`).
2. Mapear las reglas de negocio: campos obligatorios, dependencias entre secciones, límites de tamaño para archivos.
3. En los archivos `formulario-individual.component.spec.ts`:
   - Simular entradas válidas e inválidas.
   - Verificar que se emitan eventos o llamadas a servicios esperadas.
   - Asegurar que el formulario se reinicia correctamente tras enviar o cancelar.
4. Incluir pruebas de servicios auxiliares (por ejemplo, `FormularioIndividualService`).
5. Documentar en `pruebas/formulario-individual.md` los escenarios cubiertos y el último resultado.

## 3. Pruebas de interfaz (TestBed) y end-to-end

**Objetivo:** Confirmar que los flujos principales funcionan en conjunto desde la interfaz, integrando componentes, rutas y servicios.

**Pasos sugeridos**
1. Configurar suites con `TestBed` que ensamblen módulos reales y stubs de API (usar `HttpClientTestingModule`).
2. Cubrir navegación y guardado de datos claves en configuraciones y formularios individuales.
3. Preparar pruebas end-to-end con Cypress o Playwright (directorio sugerido: `web/muses-web/e2e/`).
4. Definir scripts en `package.json` (`"e2e": "ng e2e"` o equivalente).
5. Capturar evidencias (capturas de pantalla, videos) y consignarlas en `pruebas/e2e.md` junto con instrucciones de ejecución.

## 4. Pruebas de rendimiento y resiliencia

**Objetivo:** Evaluar la aplicación bajo carga y situaciones adversas (latencia, interrupción de servicios, límites de almacenamiento).

**Pasos sugeridos**
1. Identificar endpoints críticos en `docs/api_specification.yml`.
2. Crear escenarios de carga con herramientas como JMeter, k6 o Gatling (pueden ubicarse en `pruebas/performance/`).
3. Simular errores de red y límites de almacenamiento (`localStorage` y `sessionStorage`).
4. Medir tiempos de respuesta, uso de memoria y tolerancia a fallos.
5. Resumir hallazgos en `pruebas/rendimiento-resiliencia.md`, indicando métricas y acciones de mitigación.

## Registro y seguimiento

- Cada nueva suite debe tener su documento de evidencia en la carpeta `pruebas/`.
- Actualiza `pruebas/README.md` con enlaces a los reportes creados.
- Incluye en cada documento: objetivo, dependencias, comando de ejecución, resultado más reciente y pendientes.

Siguiendo este orden tendrás una visión progresiva: primero afianzar reglas de negocio individuales, luego validar la interacción entre componentes y finalmente medir comportamiento bajo estrés.
