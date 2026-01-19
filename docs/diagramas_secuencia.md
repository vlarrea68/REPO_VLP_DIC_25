# Diagramas de Secuencia de Flujos de Trabajo Clave

## 1. Propósito

Este documento contiene diagramas de secuencia en formato Mermaid que ilustran los flujos de trabajo más importantes del sistema SEP-MUSES, alineados con la arquitectura de base de datos centralizada.

---

## 2. Flujo de Carga Masiva de Eventos y Notificación

Este diagrama muestra la secuencia de interacciones desde que un subsistema envía un archivo CSV hasta que la información es consolidada en la base de datos central `sep_muses` y notificada a SIGED.

### 2.1. Descripción del Flujo

El flujo de trabajo es asíncrono y se desarrolla de la siguiente manera:

1.  **Recepción y Acuse (Pasos 1-6):**
    *   Un **Subsistema Externo** (que utiliza su propia BD local `sep_ides`) envía un archivo **CSV** al **API Gateway**.
    *   El **API de Recepción** valida la estructura del archivo y publica un mensaje en la **Cola de Mensajes**.
    *   Se devuelve un acuse de recibo (`HTTP 202 Accepted`) al subsistema.

2.  **Procesamiento y Almacenamiento en Staging (Pasos 7-9):**
    *   El **Servicio de Procesamiento Inicial** consume el mensaje.
    *   Realiza validaciones externas (ej. CURP vs RENAPO).
    *   Guarda los registros del archivo en las **Tablas de Intercambio (TBAE*)** dentro de la **BD Central (`sep_muses`)**.

3.  **Consolidación ETL Interna (Pasos 10-12):**
    *   El **Servicio de Consolidación (ETL)** se ejecuta de forma programada.
    *   Lee los registros de las tablas `TBAE*` dentro de `sep_muses`.
    *   Los valida contra los **Catálogos (CTMU*)** y los transforma.
    *   Guarda los datos consolidados en las **Tablas Núcleo (TBMU*)** dentro de la misma `sep_muses`.

4.  **Notificación a SIGED (Pasos 13-15):**
    *   El **Servicio de Notificación a SIGED** lee los eventos consolidados de las tablas `TBMU*`.
    *   Envía la notificación al **WebService de SIGED**.
    *   Actualiza el estado del registro a "Notificado" en las tablas `TBMU*`.

```mermaid
sequenceDiagram
    participant Subsistema Externo
    participant API Gateway
    participant API Recepción
    participant Cola de Mensajes
    participant Serv. Procesamiento Inicial
    participant Serv. Consolidación (ETL)
    participant BD_Central as "BD Central (sep_muses)"
    participant Serv. Notificación a SIGED
    participant WebService SIGED

    Subsistema Externo->>API Gateway: 1. POST /v1/eventos/carga-masiva (CSV)
    API Gateway->>API Recepción: 2. Reenvía petición

    activate API Recepción
    API Recepción-->>API Recepción: 3. Valida estructura del CSV
    API Recepción->>Cola de Mensajes: 4. Publica mensaje
    API Recepción-->>Subsistema Externo: 5. HTTP 202 Accepted
    deactivate API Recepción

    Cola de Mensajes->>Serv. Procesamiento Inicial: 6. Entrega mensaje
    activate Serv. Procesamiento Inicial
    Serv. Procesamiento Inicial-->>Serv. Procesamiento Inicial: 7. Valida CURP y CCT
    Serv. Procesamiento Inicial->>BD_Central: 8. Guarda registros en Tablas de Intercambio (TBAE*)
    deactivate Serv. Procesamiento Inicial

    Note right of Serv. Consolidación (ETL): Proceso Asíncrono / Batch

    activate Serv. Consolidación (ETL)
    Serv. Consolidación (ETL)->>BD_Central: 9. Lee de TBAE*, valida con CTMU*
    Serv. Consolidación (ETL)->>BD_Central: 10. Consolida en Tablas Núcleo (TBMU*)
    deactivate Serv. Consolidación (ETL)

    Note right of Serv. Notificación a SIGED: Proceso Asíncrono / Trigger

    activate Serv. Notificación a SIGED
    Serv. Notificación a SIGED->>BD_Central: 11. Lee evento consolidado de TBMU*
    Serv. Notificación a SIGED->>WebService SIGED: 12. Envía notificación de evento
    Serv. Notificación a SIGED->>BD_Central: 13. Actualiza estado a "Notificado" en TBMU*
    deactivate Serv. Notificación a SIGED
```
