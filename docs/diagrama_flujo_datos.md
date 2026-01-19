# Diagrama de Flujo de Datos (DFD)

## 1. Introducción

Este documento presenta el Diagrama de Flujo de Datos (DFD) de Nivel 0 para el sistema **Matrícula Única de Educación Superior (SEP-MUSES)**. El DFD se enfoca en cómo se mueve la información a través del sistema, identificando los procesos principales que transforman los datos, los almacenes de datos donde reside la información y las entidades externas que interactúan con el sistema.

## 2. Diagrama de Flujo de Datos - Nivel 0

```mermaid
graph TD
    %% Entidades Externas
    subgraph "Entidades Externas"
        A["Subsistema EMS<br>(Fuente de Datos)"]
        B["Usuario<br>(Control Escolar / Admin SEP)"]
        C["RENAPO"]
        S["SIGED"]
    end

    %% Procesos del Sistema
    subgraph "Procesos SEP-MUSES"
        P1("1.0<br>Recibir y Procesar Inicialmente")
        P2("2.0<br>Consolidar y Validar Datos (ETL)")
        P3("3.0<br>Gestionar Consultas y Reportes")
        P4("4.0<br>Notificar a Sistemas Externos")
    end

    %% Almacenes de Datos
    subgraph "Almacenes de Datos"
        S1[("DS1<br>Cola de Mensajes")]
        S3[("DS2<br>BD Central (sep_muses)")]
    end

    %% Flujos de Datos
    A -- "Archivo de Trayectoria (CSV)" --> P1
    P1 -- "Ruta de Archivo" --> S1

    S1 -- "Datos a Procesar" --> P1
    P1 -- "Datos Crudos" --> S3

    P1 -- "Solicitud de Validación CURP" --> C
    C -- "Respuesta de Validación CURP" --> P1

    S3 -- "Datos Crudos de TBAE*" --> P2
    P2 -- "Datos Validados" --> S3

    B -- "Solicitud de Consulta" --> P3
    P3 -- "Consulta a TBMU*" --> S3
    S3 -- "Resultados de Consulta" --> P3
    P3 -- "Reporte / Vista de Datos" --> B

    S3 -- "Datos Consolidados de TBMU*" --> P4
    P4 -- "Notificación de Evento" --> S
```

## 3. Descripción de los Flujos

1.  **Recepción y Procesamiento Inicial:**
    *   Un **Subsistema Externo** envía un archivo **CSV** al proceso **1.0 Recibir y Procesar Inicialmente**.
    *   Este proceso utiliza una **Cola de Mensajes (DS1)** para gestionar la carga de forma asíncrona.
    *   Realiza validaciones externas consultando a **RENAPO** y almacena los datos crudos en las tablas de intercambio (`TBAE*`) de la **BD Central (DS2)**.

2.  **Consolidación y Validación (ETL):**
    *   El proceso **2.0 Consolidar y Validar Datos** opera enteramente dentro de la **BD Central (DS2)**.
    *   Lee los datos de las tablas de intercambio, los valida contra los catálogos internos (`CTMU*`) y los transforma.
    *   Guarda los datos limpios y normalizados en las tablas núcleo (`TBMU*`).

3.  **Consultas y Reportes:**
    *   Un **Usuario** solicita información a través del proceso **3.0 Gestionar Consultas y Reportes**.
    *   Este proceso consulta las tablas núcleo (`TBMU*`) de la **BD Central (DS2)** y devuelve los resultados al usuario.

4.  **Notificación a Sistemas Externos:**
    *   El proceso **4.0 Notificar a Sistemas Externos** lee datos consolidados de las tablas núcleo (`TBMU*`) en la **BD Central (DS2)**.
    *   Envía la información requerida a entidades externas como **SIGED**.
