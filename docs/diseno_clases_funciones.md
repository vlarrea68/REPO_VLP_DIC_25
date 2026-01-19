# Diseño de Componentes del Backend (Node.js & GraphQL)

## 1. Propósito

Este documento describe el diseño de los componentes de software clave que implementarán la lógica de negocio del backend de SEP-MUSES, basado en una arquitectura de **API Unificada con GraphQL** sobre **Node.js** y workers desacoplados.

---

### 2. Diseño de la API Unificada (GraphQL)

El corazón del backend será un único servidor **Apollo Server** sobre **Express (Node.js)**.

#### 2.1. Schema de GraphQL

*   **Queries:** `alumno(curp: String!)`, `catalogos`
*   **Mutations:** `cargarArchivo(archivo: Upload!)`
*   **Types:** Alineados con el modelo de datos de `sep_muses`.

#### 2.2. Resolvers

*   **`Query.alumno`:** Llama a `MusesRepository.getAlumnoCompleto`.
*   **`Mutation.cargarArchivo`:** Guarda el archivo, lo valida estructuralmente y publica un evento en la cola de mensajes.

#### 2.3. Data Sources

*   **`MusesDBDataSource`:** Encapsula toda la lógica de acceso a la base de datos `sep_muses`, tanto para las tablas de staging (`tbae*`) como para las tablas núcleo (`tbmu*`).

---

### 3. Diseño de los Servicios de Procesamiento (Workers)

#### 3.1. Worker de Procesamiento Inicial

*   **Propósito:** Consumir mensajes de la cola, procesar cada fila del CSV y realizar validaciones.
*   **Componentes Clave:**
    *   **`MessageConsumer`:** Escucha y consume mensajes de la cola.
    *   **`CsvProcessor`:** Lee el archivo CSV línea por línea.
    *   **`RowValidator`:** Valida cada fila (CURP contra RENAPO, etc.).
    *   **`StagingRepository`:** Guarda cada fila (cruda) junto con su estado de validación en las **tablas de intercambio (`tbae*`)** de la base de datos `sep_muses`.

#### 3.2. Worker de Consolidación (ETL)

*   **Propósito:** Mover y transformar los datos desde las tablas de intercambio a las tablas núcleo, todo dentro de `sep_muses`.
*   **Componentes Clave:**
    *   **`EtlOrchestrator`:** Un proceso programado que inicia el ETL.
    *   **`DataTransformer`:** Contiene la lógica para transformar los datos del modelo de staging (`tbae*`) al modelo normalizado de las tablas núcleo (`tbmu*`).
    *   **`MusesRepository`:** Encapsula las operaciones de escritura en las tablas núcleo de `sep_muses`.

---

### 4. Estructura de Proyecto Sugerida (Monorepo)

```
/packages
  /api-graphql      # El servidor principal de Apollo Server
  /worker-inicial   # El worker de procesamiento inicial
  /worker-etl       # El worker de consolidación
  /common           # Código compartido
```
