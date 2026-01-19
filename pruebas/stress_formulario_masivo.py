#!/usr/bin/env python3
"""Herramienta de prueba de estrés para el formulario de carga masiva.

Este script envía múltiples solicitudes concurrentes al endpoint de carga masiva
(definido en la especificación `/eventos/carga-masiva`) para medir latencias,
porcentaje de respuestas exitosas y rendimiento general. Está pensado como una
utilidad de línea de comandos que no depende de paquetes externos.
"""
from __future__ import annotations

import argparse
import concurrent.futures
import json
import math
import os
import socket
import ssl
import sys
import threading
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional, Tuple


@dataclass
class RequestResult:
    """Representa el resultado de una petición individual."""

    index: int
    latency: float
    status: Optional[int]
    ok: bool
    error: Optional[str] = None


def _parse_header_entries(entries: Iterable[str]) -> Dict[str, str]:
    headers: Dict[str, str] = {}
    for raw in entries:
        if ":" not in raw:
            raise ValueError(
                f"El encabezado personalizado '{raw}' debe tener el formato Clave:Valor"
            )
        key, value = raw.split(":", 1)
        key = key.strip()
        value = value.strip()
        if not key:
            raise ValueError(
                f"El encabezado personalizado '{raw}' no define una clave válida"
            )
        headers[key] = value
    return headers


def _build_payload(
    csv_bytes: bytes,
    filename: str,
    field_name: str,
) -> Tuple[bytes, Dict[str, str]]:
    boundary = f"----SEP-MUSES-STRESS-{time.time_ns()}"
    head = (
        f"--{boundary}\r\n"
        f"Content-Disposition: form-data; name=\"{field_name}\"; filename=\"{filename}\"\r\n"
        "Content-Type: text/csv\r\n\r\n"
    ).encode("utf-8")
    tail = f"\r\n--{boundary}--\r\n".encode("utf-8")
    body = head + csv_bytes + tail
    headers = {
        "Content-Type": f"multipart/form-data; boundary={boundary}",
        "Content-Length": str(len(body)),
    }
    return body, headers


def _percentile(values: List[float], percentile: float) -> float:
    if not values:
        return float("nan")
    if not 0 <= percentile <= 100:
        raise ValueError("El percentil debe estar entre 0 y 100")
    if len(values) == 1:
        return values[0]
    ordered = sorted(values)
    k = (len(ordered) - 1) * (percentile / 100)
    f = math.floor(k)
    c = math.ceil(k)
    if f == c:
        return ordered[int(k)]
    d0 = ordered[f] * (c - k)
    d1 = ordered[c] * (k - f)
    return d0 + d1


def _create_ssl_context(insecure: bool) -> Optional[ssl.SSLContext]:
    if not insecure:
        return None
    context = ssl.create_default_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE
    return context


def _send_request(
    index: int,
    endpoint: str,
    timeout: float,
    common_headers: Dict[str, str],
    payload: bytes,
    payload_headers: Dict[str, str],
    ssl_context: Optional[ssl.SSLContext],
) -> RequestResult:
    request = urllib.request.Request(endpoint, method="POST", data=payload)
    for key, value in {**common_headers, **payload_headers}.items():
        request.add_header(key, value)

    start = time.perf_counter()
    try:
        with urllib.request.urlopen(request, timeout=timeout, context=ssl_context) as resp:
            # Consumir el cuerpo para liberar la conexión.
            resp.read()
            latency = time.perf_counter() - start
            return RequestResult(
                index=index,
                latency=latency,
                status=resp.status,
                ok=200 <= resp.status < 300,
            )
    except urllib.error.HTTPError as exc:
        error_body = exc.read(1024).decode("utf-8", errors="replace")
        latency = time.perf_counter() - start
        return RequestResult(
            index=index,
            latency=latency,
            status=exc.code,
            ok=False,
            error=f"HTTPError {exc.code}: {error_body.strip()}",
        )
    except Exception as exc:  # pylint: disable=broad-except
        latency = time.perf_counter() - start
        return RequestResult(
            index=index,
            latency=latency,
            status=None,
            ok=False,
            error=str(exc),
        )


def ejecutar_prueba(args: argparse.Namespace) -> Dict[str, object]:
    endpoint = args.endpoint.rstrip("/")
    parsed = urllib.parse.urlparse(endpoint)
    if parsed.scheme not in {"http", "https"}:
        raise ValueError("El endpoint debe iniciar con http:// o https://")

    if not parsed.hostname:
        raise ValueError("El endpoint proporcionado no contiene un hostname válido")

    port = parsed.port or (443 if parsed.scheme == "https" else 80)
    try:
        with socket.create_connection((parsed.hostname, port), timeout=args.timeout):
            pass
    except OSError as exc:
        sugerencia = ""
        if parsed.hostname in {"localhost", "127.0.0.1"} and port == 4200:
            sugerencia = (
                " Detecté que estás apuntando a localhost:4200; este puerto suele "
                "corresponder al servidor de desarrollo de Angular. Asegúrate de "
                "que `ng serve` esté en ejecución o utiliza la URL directa del "
                "backend (por ejemplo http://localhost:8080)."
            )
        raise ConnectionError(
            "No se pudo establecer conexión con "
            f"{parsed.hostname}:{port}. Verifica que el servicio esté en ejecución "
            "y que el firewall permita el acceso." + sugerencia
        ) from exc

    csv_path = Path(os.path.expandvars(args.csv)).expanduser()
    if csv_path.is_dir():
        raise IsADirectoryError(
            f"La ruta proporcionada apunta a un directorio, no a un archivo CSV: {csv_path}"
        )
    if not csv_path.is_file():
        raise FileNotFoundError(f"No se encontró el archivo CSV: {csv_path}")

    csv_bytes = csv_path.read_bytes()
    if not csv_bytes:
        raise ValueError("El archivo CSV está vacío, no se puede ejecutar la prueba")

    payload, payload_headers = _build_payload(
        csv_bytes=csv_bytes,
        filename=csv_path.name,
        field_name=args.field_name,
    )

    common_headers: Dict[str, str] = {}
    if args.api_key:
        common_headers[args.api_key_header] = args.api_key
    common_headers.update(_parse_header_entries(args.header or []))

    ssl_context = _create_ssl_context(args.insecure)

    total_solicitudes = args.requests
    concurrencia = max(1, min(args.concurrency, total_solicitudes))
    resultados: List[RequestResult] = []
    lock = threading.Lock()

    inicio = time.perf_counter()

    def _task(idx: int) -> RequestResult:
        res = _send_request(
            index=idx,
            endpoint=endpoint,
            timeout=args.timeout,
            common_headers=common_headers,
            payload=payload,
            payload_headers=payload_headers,
            ssl_context=ssl_context,
        )
        if args.verbose:
            estado = res.status if res.status is not None else "N/D"
            mensaje = "OK" if res.ok else res.error or "Error desconocido"
            print(
                f"[{idx:04d}] estado={estado} latencia={res.latency*1000:.1f} ms -> {mensaje}",
                file=sys.stderr,
            )
        with lock:
            resultados.append(res)
        return res

    with concurrent.futures.ThreadPoolExecutor(max_workers=concurrencia) as executor:
        futures = [executor.submit(_task, i + 1) for i in range(total_solicitudes)]
        for future in concurrent.futures.as_completed(futures):
            future.result()

    duracion_total = time.perf_counter() - inicio

    latencias = [r.latency for r in resultados]
    exitos = [r for r in resultados if r.ok]
    fallos = [r for r in resultados if not r.ok]

    resumen = {
        "endpoint": endpoint,
        "total_solicitudes": total_solicitudes,
        "concurrencia": concurrencia,
        "duracion_total_segundos": duracion_total,
        "peticiones_por_segundo": total_solicitudes / duracion_total if duracion_total else float("inf"),
        "exitos": len(exitos),
        "fallos": len(fallos),
        "latencia_promedio_ms": (sum(latencias) / len(latencias) * 1000) if latencias else float("nan"),
        "latencia_min_ms": (min(latencias) * 1000) if latencias else float("nan"),
        "latencia_max_ms": (max(latencias) * 1000) if latencias else float("nan"),
        "latencia_p90_ms": (_percentile(latencias, 90) * 1000) if latencias else float("nan"),
        "latencia_p95_ms": (_percentile(latencias, 95) * 1000) if latencias else float("nan"),
        "latencia_p99_ms": (_percentile(latencias, 99) * 1000) if latencias else float("nan"),
        "detalle_fallos": [
            {
                "index": r.index,
                "status": r.status,
                "error": r.error,
            }
            for r in fallos
        ],
    }

    connection_refused_markers = (
        "connection refused",
        "no se puede establecer una conexión",
        "winerror 10061",
        "errno 111",
    )
    angular_404_markers = ("cannot post", "angular", "<!doctype html>")
    if fallos and len(fallos) == total_solicitudes:
        if all(
            (
                r.status is None
                and r.error
                and any(marker in r.error.lower() for marker in connection_refused_markers)
            )
            for r in fallos
        ):
            mensaje = (
                "Todas las solicitudes fallaron porque el endpoint rechazó la conexión. "
                "Asegúrate de que el backend esté disponible en "
                f"{parsed.hostname}:{port} y que acepten solicitudes POST a la ruta indicada."
            )
            if parsed.hostname in {"localhost", "127.0.0.1"} and port == 4200:
                mensaje += (
                    " En entornos locales este puerto suele usarlo Angular (`ng serve`). "
                    "Verifica que el servidor de desarrollo esté activo y que exista un proxy "
                    "hacia la API o utiliza directamente la URL del backend."
                )
            resumen["nota"] = mensaje
        elif all(r.status == 404 for r in fallos):
            if all(r.error and any(marker in r.error.lower() for marker in angular_404_markers) for r in fallos):
                resumen[
                    "nota"
                ] = (
                    "El servidor respondió 404 a todas las peticiones y devolvió la página genérica del "
                    "servidor de Angular. Usa la URL del backend real (por ejemplo http://localhost:8080) "
                    "o configura un proxy que redirija /v1/eventos/carga-masiva hacia la API."
                )
            else:
                resumen[
                    "nota"
                ] = (
                    "Todas las solicitudes obtuvieron 404. Verifica que la ruta /v1/eventos/carga-masiva exista "
                    "y que el backend acepte peticiones POST en ese endpoint."
                )

    if args.output:
        with open(args.output, "w", encoding="utf-8") as handler:
            json.dump(resumen, handler, ensure_ascii=False, indent=2)

    return resumen


def crear_argumentos() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Ejecuta una prueba de estrés contra el formulario de carga masiva",
    )
    parser.add_argument(
        "--endpoint",
        required=True,
        help="URL completa del endpoint /eventos/carga-masiva (http/https)",
    )
    parser.add_argument(
        "--csv",
        required=True,
        help="Ruta al archivo CSV que se enviará en cada solicitud",
    )
    parser.add_argument(
        "--requests",
        type=int,
        default=50,
        help="Número total de solicitudes a enviar (default: 50)",
    )
    parser.add_argument(
        "--concurrency",
        type=int,
        default=10,
        help="Número máximo de solicitudes concurrentes (default: 10)",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=30.0,
        help="Tiempo máximo de espera por solicitud en segundos (default: 30)",
    )
    parser.add_argument(
        "--api-key",
        help="Valor del encabezado X-API-Key u otra credencial requerida",
    )
    parser.add_argument(
        "--api-key-header",
        default="X-API-Key",
        help="Nombre del encabezado para enviar la API key (default: X-API-Key)",
    )
    parser.add_argument(
        "--header",
        action="append",
        help=(
            "Encabezados adicionales en formato Clave:Valor. "
            "Puede declararse múltiples veces."
        ),
    )
    parser.add_argument(
        "--field-name",
        default="archivo",
        help="Nombre del campo multipart utilizado por el backend (default: archivo)",
    )
    parser.add_argument(
        "--output",
        help="Ruta de archivo JSON donde guardar el resumen de la ejecución",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Imprime el resultado de cada solicitud en stderr",
    )
    parser.add_argument(
        "--insecure",
        action="store_true",
        help="Deshabilita la verificación TLS (solo entornos de prueba)",
    )
    return parser.parse_args()


def main() -> None:
    try:
        args = crear_argumentos()
        resumen = ejecutar_prueba(args)
    except KeyboardInterrupt:
        print("Prueba cancelada por el usuario", file=sys.stderr)
        sys.exit(130)
    except Exception as exc:  # pylint: disable=broad-except
        print(f"Error al ejecutar la prueba: {exc}", file=sys.stderr)
        sys.exit(1)

    print("== Resumen de la prueba de estrés ==")
    print(json.dumps(resumen, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
