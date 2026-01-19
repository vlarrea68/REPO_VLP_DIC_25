# REGISTRO DE PRUEBAS CON RESULTADOS OBTENIDOS DURANTE LAS FASES DE PRUEBA FUNCIONAL

**Unidad de Administración y Finanzas**  
**Dirección General de Tecnologías de la Información y Comunicaciones**

---

## Sistema: Reuniones de Actualización Curricular, Aprendizaje Digital y Microcredenciales 2025

**Versión:** 1.1  
**Fecha:** 31 de octubre de 2025

---

## CONTROL DE VERSIONES

| Fecha | Versión | Descripción | Autor |
| --- | --- | --- | --- |
| 31/07/2025 | 1.0 | Documento inicial de registro de pruebas funcionales | José Gpe. Gutiérrez Arévalo |
| 31/10/2025 | 1.1 | Actualización con resultados de pruebas funcionales de octubre 2025 | José Gpe. Gutiérrez Arévalo |

---

## PROPÓSITO DEL DOCUMENTO

Registrar los resultados obtenidos durante las fases de prueba funcional, así como las correcciones de incidencias detectadas.
La evidencia integra:

- Pruebas unitarias en Python descritas en `pruebas/unitarias-python.md`.
- Ensayos de resiliencia con el script `stress_formulario_masivo.py` y reportes JSON.
- Observaciones y seguimiento de incidencias derivadas de la campaña de QA.

> Nota: no se ejecutaron colecciones de Postman porque los endpoints REST y GraphQL aún no están expuestos en esta iteración.

---

## 1. INTRODUCCIÓN

### 1.1 Objetivo general

Confirmar que las utilidades de validación y resiliencia desarrolladas en Python sostienen los flujos de carga masiva antes de exponer APIs públicas, con evidencia ejecutable y trazabilidad a la documentación técnica de pruebas.

### 1.2 Alcance

- Suites unitarias Python documentadas en `pruebas/unitarias-python.md` y respaldadas por `pruebas/tests/test_stress_formulario.py`.
- Prueba de estrés enfocada al endpoint `/v1/eventos/carga-masiva` mediante `pruebas/stress_formulario_masivo.py`.
- Registro de incidencias y acciones correctivas asociadas a los hallazgos de octubre.
- Las consultas y mutaciones GraphQL quedarán cubiertas en la siguiente iteración al habilitarse el gateway correspondiente.

### 1.3 Fuentes de evidencia

| Documento | Descripción |
| --- | --- |
| `pruebas/README.md` | Procedimiento actualizado para ejecutar pytest y el script de estrés. |
| `pruebas/unitarias-python.md` | Detalle de los casos unitarios ejecutados en Python. |
| `pruebas/resumen-ejecuciones.md` | Histórico de comandos y resultados consolidados en octubre. |
| `pruebas/reportes/pytest-20251028.txt` | Bitácora de la sesión `pytest` ejecutada el 28/10/2025. |
| `pruebas/reportes/qa-20251029.json` | Resumen JSON de la prueba de estrés con 200 solicitudes. |
| `pruebas/interpretacion-prueba-estres.md` | Guía de lectura y umbrales de aceptación para la prueba de estrés. |

---

## 2. PLAN Y METODOLOGÍA DE PRUEBAS

### 2.1 Entorno de ejecución

- **Ambiente:** QA-SEP-MUSES (Linux x86_64, Python 3.11.8).
- **Herramientas:** `pytest` 7.4.3, `python3` para el script de estrés, utilidades estándar de red.
- **Datos de prueba:** CSV `pruebas/plantilla-inscripcion-masiva.csv` y parámetros descritos en `interpretacion-prueba-estres.md`.
- **Configuración adicional:** Activación de entorno virtual y variable `PYTHONPATH=.` para importar `pruebas.stress_formulario_masivo`.

### 2.2 Estrategia

1. Ejecutar `pytest -q pruebas/tests/test_stress_formulario.py` para validar parsers, percentiles y contexto TLS.
2. Lanzar la prueba de estrés con 200 solicitudes y concurrencia 20, registrando el resumen JSON.
3. Consolidar resultados en tablas y vincular incidencias con acciones correctivas.
4. Documentar pendientes para la fase de integración GraphQL y la futura exposición de APIs públicas.

---

## 3. RESUMEN EJECUTIVO DE RESULTADOS

| Métrica | Valor | Objetivo | Estado |
| --- | --- | --- | --- |
| Casos unitarios Python ejecutados | 9 | ≥ 6 | ✅ Superado |
| Casos unitarios exitosos | 9 | 100% de la suite | ✅ Cumplido |
| Prueba de estrés | 200 solicitudes exitosas / 0 fallos | ≥ 95% de éxito | ✅ Exitoso |
| Incidencias corregidas | 2 | Todas las detectadas | ✅ Cerradas |

---

## 4. REGISTRO DETALLADO DE PRUEBAS

### 4.1 Pruebas unitarias Python (pytest)

| ID | Módulo | Objetivo | Resultado |
| --- | --- | --- | --- |
| PY-HDR-01 | `_parse_header_entries` | Normalizar encabezados adicionales y detectar formatos inválidos. | ✅ Diccionario limpio y `ValueError` en el caso negativo (ref. `pruebas/unitarias-python.md`). |
| PY-PAY-02 | `_build_payload` | Generar cuerpo multipart/form-data y encabezados coherentes con el CSV oficial. | ✅ Payload delimitado por `--SEP-MUSES-STRESS-*` y `Content-Length` exacto. |
| PY-PER-03 | `_percentile` | Calcular percentiles p50, p75 y p95 para latencias simuladas. | ✅ Resultados conforme a la interpolación lineal documentada. |
| PY-TLS-04 | `_create_ssl_context` | Proveer contexto TLS relajado para entornos QA y validar modo estricto por omisión. | ✅ `SSLContext` con `CERT_NONE` al activar `--insecure` y `None` en modo seguro. |

> Las ejecuciones se consolidan en `pytest -q pruebas/tests/test_stress_formulario.py` (9 casos exitosos, 0 fallos).

### 4.2 Prueba de estrés del formulario masivo

- **Script:** `pruebas/stress_formulario_masivo.py`.  
- **Parámetros:** `--requests 200 --concurrency 20 --timeout 30s --endpoint https://qa.muses.sep.gob.mx/v1/eventos/carga-masiva`.  
- **Resultado:** 200 éxitos, 0 fallos, latencia p95 = 740 ms, throughput promedio = 6.1 req/s.
- **Evidencia:** Resumen JSON adjunto al expediente (`resumen-ejecuciones.md`, entrada 2025-10-29) y análisis en `pruebas/interpretacion-prueba-estres.md`.

### 4.3 Observaciones relevantes

- Las suites de pytest garantizan que los encabezados personalizados y la construcción multipart mantengan compatibilidad con el backend previsto.
- El cálculo de percentiles controlados sirve como baseline para comparar futuras ejecuciones con APIs reales.
- La prueba de estrés evidenció que el endpoint mantiene la disponibilidad incluso cuando se cancelan manualmente dos hilos; el script reintenta sin degradar el throughput general.

---

## 5. INCIDENCIAS DETECTADAS Y CORREGIDAS

| ID | Descripción | Impacto | Acción correctiva | Estado |
| --- | --- | --- | --- | --- |
| INC-2025-10-01 | El parser de encabezados permitía cadenas sin separador `:` y fallaba silenciosamente. | Medio | Se endureció la validación en `_parse_header_entries` y se documentó el caso negativo en `pruebas/unitarias-python.md`. | ✅ Cerrada |
| INC-2025-10-02 | El resumen de estrés ignoraba escenarios con 100 % de fallos por conexión rechazada. | Alto | Se agregaron notas automáticas en `stress_formulario_masivo.py` y una prueba que cubre la rama de conexión rechazada. | ✅ Cerrada |

---

## 6. PENDIENTES Y SIGUIENTES PASOS

1. Habilitar los endpoints REST/GraphQL y preparar colecciones de Postman para la próxima iteración (estimado noviembre 2025).
2. Extender la prueba de estrés a escenarios de 1 000 solicitudes y monitoreo externo (APM) para validar SLAs.
3. Documentar evidencias de pruebas end-to-end (Cypress/Playwright) conforme al plan `pruebas/plan-siguiente-fases.md`.

---

**Elaboró:**  
José Guadalupe Gutiérrez Arévalo  
<joseg.gutierrez@nube.sep.gob.mx>

**Revisó:**  
David León Gómez  
<david.leon@nube.sep.gob.mx>

---
