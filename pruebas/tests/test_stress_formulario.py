"""Casos unitarios para las utilidades del script de estrés."""

from __future__ import annotations

import ssl

import pytest

from pruebas import stress_formulario_masivo as stress


class TestParseHeaderEntries:
    """Verifica la interpretación de encabezados personalizados."""

    def test_convierte_lista_valida_en_diccionario(self) -> None:
        headers = stress._parse_header_entries(["X-Trace-Id:abc", "Env : qa "])  # type: ignore[attr-defined]
        assert headers == {"X-Trace-Id": "abc", "Env": "qa"}

    def test_rechaza_formato_invalido(self) -> None:
        with pytest.raises(ValueError):
            stress._parse_header_entries(["SinSeparador"])  # type: ignore[attr-defined]


class TestBuildPayload:
    """Valida la construcción de cuerpos multipart."""

    def test_agrega_encabezados_con_longitud_correcta(self) -> None:
        contenido = b"folio_control,curp\nMU-1,TEST010101HDFABC01"
        body, headers = stress._build_payload(  # type: ignore[attr-defined]
            csv_bytes=contenido,
            filename="plantilla.csv",
            field_name="archivo",
        )

        assert headers["Content-Type"].startswith("multipart/form-data; boundary=")
        boundary = headers["Content-Type"].split("boundary=")[1]
        assert body.startswith(f"--{boundary}\r\n".encode("utf-8"))
        assert body.endswith(b"--\r\n")
        assert headers["Content-Length"] == str(len(body))


class TestPercentile:
    """Evalúa el cálculo de percentiles sobre muestras controladas."""

    @pytest.mark.parametrize(
        ("values", "percentile", "expected"),
        [
            ([100.0], 95, 100.0),
            ([100.0, 200.0, 300.0], 50, 200.0),
            ([10.0, 20.0, 30.0, 40.0], 75, 32.5),
        ],
    )
    def test_percentiles_con_listas_ordenadas(self, values, percentile, expected) -> None:
        assert pytest.approx(stress._percentile(values, percentile)) == expected  # type: ignore[attr-defined]

    def test_rechaza_percentil_fuera_de_rango(self) -> None:
        with pytest.raises(ValueError):
            stress._percentile([1.0, 2.0], 120)  # type: ignore[attr-defined]


class TestCreateSSLContext:
    """Confirma la configuración del contexto TLS flexible."""

    def test_no_crea_contexto_si_no_se_solicita(self) -> None:
        assert stress._create_ssl_context(False) is None  # type: ignore[attr-defined]

    def test_contexto_relaja_validacion_cuando_se_activa(self) -> None:
        ctx = stress._create_ssl_context(True)  # type: ignore[attr-defined]
        assert isinstance(ctx, ssl.SSLContext)
        assert ctx.verify_mode == ssl.CERT_NONE
        assert ctx.check_hostname is False
