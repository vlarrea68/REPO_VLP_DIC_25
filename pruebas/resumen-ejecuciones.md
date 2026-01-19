# Resumen de pruebas ejecutadas

Este documento consolida los intentos de ejecución registrados durante el refuerzo de pruebas del módulo de carga masiva.

## Comandos utilizados

| Fecha | Comando | Objetivo | Resultado |
| --- | --- | --- | --- |
| 2025-10-28 | `pytest -q pruebas/tests/test_stress_formulario.py` | Validar las utilidades del script de estrés (parsers, percentiles y contexto TLS). | ✅ 9 pruebas aprobadas en 0.09 s. |
| 2025-10-29 | `python3 pruebas/stress_formulario_masivo.py --endpoint https://qa.muses.sep.gob.mx/v1/eventos/carga-masiva --csv pruebas/plantilla-inscripcion-masiva.csv --requests 200 --concurrency 20 --timeout 30 --output pruebas/reportes/qa-20251029.json` | Ejecutar la prueba de estrés con la plantilla oficial. | ✅ Resumen generado con 200/200 éxitos y latencia p95 de 0.74 s. |

## Paquetes y scripts cubiertos

- `pruebas/tests/test_stress_formulario.py`
  - Conversión de encabezados personalizados a diccionarios.
  - Armado de payload multipart/form-data.
  - Cálculo de percentiles (p50, p75, p95) para latencias simuladas.
  - Creación de contexto TLS relajado para entornos QA.
- `pruebas/stress_formulario_masivo.py`
  - Envío concurrente de solicitudes con CSV válido.
  - Registro de métricas de latencia y throughput.
  - Exportación del resumen en formato JSON para anexarlo como evidencia.

## Situación actual

Las suites unitarias en Python quedaron integradas al repositorio y pueden ejecutarse en entornos sin interfaz gráfica. Las pruebas de estrés siguen dependiendo de la disponibilidad del endpoint QA, por lo que se documentan recomendaciones de red y credenciales en `interpretacion-prueba-estres.md`.
