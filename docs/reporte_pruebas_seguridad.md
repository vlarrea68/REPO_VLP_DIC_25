# Reporte de Ejecución de Pruebas de Seguridad

## 1. Propósito

Este documento resume los hallazgos de las pruebas de seguridad realizadas sobre el sistema SIGED, con el objetivo de identificar y mitigar vulnerabilidades potenciales que puedan comprometer la confidencialidad, integridad y disponibilidad de los datos.

## 2. Resumen de la Ejecución

-   **Versión del Software:** `[Indicar la versión, ej. v1.0.0-alpha]`
-   **Fecha de Ejecución:** `AAAA-MM-DD`
-   **Herramientas Utilizadas:** `[Ej. OWASP ZAP, Burp Suite, Nmap]`
-   **Responsable de la Ejecución:** `[Especialista de Seguridad / Equipo de Red Team]`

## 3. Alcance de las Pruebas

-   **Análisis de Vulnerabilidades (Escaneo Automatizado):** Se escanearon los endpoints de la API en busca de vulnerabilidades conocidas (OWASP Top 10).
-   **Pruebas de Penetración (Manual):** Se intentó explotar manualmente las vulnerabilidades encontradas y se probaron los controles de acceso y autorización.
-   **Revisión de Configuración de Seguridad:** Se verificó la configuración de los servidores, el API Gateway y la base de datos.

## 4. Resumen de Hallazgos

| Criticidad | Número de Vulnerabilidades |
| :--- | :--- |
| Crítica | 0 |
| Alta | 1 |
| Media | 2 |
| Baja | 5 |
| **Total** | **8** |

## 5. Vulnerabilidades Críticas y Altas

-   **ID de la Vulnerabilidad:** `VULN-001`
-   **Descripción:** **(Alta)** Se detectó una vulnerabilidad de Inyección SQL en el endpoint de consulta `/api/consultas/alumnos` a través de un parámetro de filtro no sanitizado. Un atacante podría manipular la consulta para extraer datos no autorizados.
-   **Prueba de Concepto (PoC):** `GET /api/consultas/alumnos?ciclo_escolar=' OR 1=1; --`
-   **Recomendación:** Implementar consultas parametrizadas (prepared statements) en toda la capa de repositorios para evitar la inyección de SQL.
-   **Asignado a:** `[Equipo de Desarrollo]`

## 6. Evidencias

-   **Reporte de OWASP ZAP:**
    *(Adjuntar enlace o extracto del reporte generado por la herramienta de escaneo)*

-   **Captura de Pantalla de la Explotación:**
    *(Adjuntar captura de pantalla que demuestre la explotación exitosa de la vulnerabilidad)*

## 7. Plan de Mitigación

Todas las vulnerabilidades de criticidad Alta y Media deben ser resueltas antes del pase a Producción. Las vulnerabilidades de criticidad Baja serán añadidas al backlog para ser atendidas en futuras iteraciones.
