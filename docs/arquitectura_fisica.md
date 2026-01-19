# Arquitectura Física (On-Premise)

## Diagrama de Despliegue Físico

```mermaid
graph TD
    subgraph "DMZ (Zona Desmilitarizada)"
        LB(Load Balancer)
        FW1(Firewall)
        API_GW_SERVER(Servidor/Contenedor API Gateway)
    end

    subgraph "Red Interna Segura"
        FW2(Firewall)
        subgraph "Clúster de Aplicaciones"
            APP_SERVER1(Servidor de Aplicaciones 1<br>- Servicio Procesamiento Inicial)
            APP_SERVER2(Servidor de Aplicaciones 2<br>- Servicio Consolidación ETL)
            APP_SERVER3(Servidor de Aplicaciones 3<br>- Frontend App `muses-web`)
        end
        subgraph "Clúster de Base de Datos"
            DB_SERVER_MUSES(Servidor BD Central<br>sep_muses)
        end
    end

    subgraph "Internet / Red Externa"
        CLIENTES(Sistemas Estatales / Clientes API)
        ADMINS(Administradores SEP)
    end

    subgraph "Servicios Externos"
        RENAPO(Servicio RENAPO)
    end

    CLIENTES -- HTTPS --> LB
    ADMINS -- HTTPS --> LB

    LB -- Reenvía tráfico --> FW1
    FW1 -- Permite tráfico a --> API_GW_SERVER

    API_GW_SERVER -- Llama a Servicios --> FW2
    FW2 -- Permite tráfico a --> APP_SERVER1
    FW2 -- Permite tráfico a --> APP_SERVER2
    FW2 -- Permite tráfico a --> APP_SERVER3

    APP_SERVER1 -- Escribe en --> DB_SERVER_MUSES
    APP_SERVER2 -- Lee de/Escribe en --> DB_SERVER_MUSES
    APP_SERVER3 -- Lee de --> DB_SERVER_MUSES

    APP_SERVER1 -- Llama a --> RENAPO

    style LB fill:#f9f,stroke:#333,stroke-width:2px
    style API_GW_SERVER fill:#f9f,stroke:#333,stroke-width:2px
    style APP_SERVER1 fill:#bbf,stroke:#333,stroke-width:2px
    style APP_SERVER2 fill:#bbf,stroke:#333,stroke-width:2px
    style APP_SERVER3 fill:#bbf,stroke:#333,stroke-width:2px
    style DB_SERVER_MUSES fill:#ccf,stroke:#333,stroke-width:2px
```

## Descripción de la Infraestructura

1.  **Zona Desmilitarizada (DMZ):**
    *   **Load Balancer:** Distribuye el tráfico entrante.
    *   **Firewall (FW1):** Primera capa de seguridad.
    *   **Servidor del API Gateway:** Punto de entrada para todas las peticiones.

2.  **Red Interna Segura:**
    *   **Firewall (FW2):** Segunda capa de seguridad que aísla la red de aplicaciones y datos.
    *   **Clúster de Aplicaciones:** Conjunto de servidores donde se ejecutan los microservicios y la interfaz de usuario.
    *   **Clúster de Base de Datos:** Servidores dedicados para la base de datos central `sep_muses`. Se recomienda una configuración con replicación para alta disponibilidad y backups.

3.  **Conectividad Externa:**
    *   El tráfico de los **Sistemas Estatales** y de los **Administradores de la SEP** llega a través de internet.
    *   Las llamadas a servicios externos como **RENAPO** se originan desde los servidores de aplicaciones.
