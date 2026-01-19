# Pruebas unitarias en Python

- **Ubicación del código probado:** `pruebas/stress_formulario_masivo.py`
- **Suite de pruebas:** `pruebas/tests/test_stress_formulario.py`
- **Herramienta:** [pytest 7.4](https://docs.pytest.org/) ejecutado con Python 3.11.
- **Última ejecución:** 28 de octubre de 2025 (`pytest -q pruebas/tests/test_stress_formulario.py`).

## Casos cubiertos

| Identificador | Descripción | Resultado esperado |
| --- | --- | --- |
| `headers/valido` | Convertir la lista de encabezados adicionales en un diccionario limpio. | Diccionario con claves normalizadas sin espacios residuales. |
| `headers/invalido` | Invocar el parser con un encabezado sin separador `:`. | Se levanta `ValueError` indicando el formato incorrecto. |
| `payload/multipart` | Construir el cuerpo multipart/form-data a partir de la plantilla CSV. | Cadena delimitada por `--SEP-MUSES-STRESS-*` y encabezados con longitud consistente. |
| `percentil/p95` | Calcular percentiles p50, p75 y p95 sobre muestras controladas de latencias. | Resultados acordes con la fórmula de interpolación lineal. |
| `percentil/rango` | Solicitar percentiles fuera de `[0, 100]`. | Se levanta `ValueError` al validar el rango permitido. |
| `tls/desactivado` | Solicitar contexto TLS sin la bandera `--insecure`. | Devuelve `None`, manteniendo la validación por defecto. |
| `tls/insecure` | Generar contexto TLS ignorando la validación de certificados. | Objeto `SSLContext` con `verify_mode=CERT_NONE` y `check_hostname=False`. |
| `payload/headers` | Validar los encabezados de `Content-Type` y `Content-Length`. | Valores coherentes con el tamaño real del cuerpo generado. |

## Evidencia de ejecución

```text
pytest -q pruebas/tests/test_stress_formulario.py
.........                                                     [100%]
9 passed in 0.09s
```

Los reportes detallados se adjuntan en `pruebas/reportes/pytest-20251028.txt`. De manera complementaria, cualquier error o ajuste requerido en las utilidades del script se documenta en la bitácora de incidencias de QA.
