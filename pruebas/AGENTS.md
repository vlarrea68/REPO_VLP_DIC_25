# Guía para Agentes de IA (SEP-MUSES)

Este documento proporciona directrices y principios clave para los agentes de IA que trabajen en este repositorio.

## 1. Principios Fundamentales

*   **Idioma de Comunicación:** La comunicación con el usuario debe ser siempre en **español**.
*   **Fuente de la Verdad:**
    *   Para la arquitectura de la base de datos, los archivos `bd/ddl_*.sql` y `docs/diseno_detallado_er.md` son las fuentes de la verdad. Cualquier otra documentación debe alinearse con ellos.
    *   Para la arquitectura general, `docs/arquitectura_componentes.md` es el documento de referencia.
    *   Para los contratos de la API, `docs/api_specification.yml` es la referencia.
*   **Consistencia es Clave:** Al modificar un documento, siempre se debe considerar el impacto en otros documentos para mantener la consistencia en toda la documentación.

## 2. Arquitectura del Proyecto

Es crucial entender la arquitectura del sistema antes de realizar cambios:

*   **Microservicios:** El backend está basado en una arquitectura de microservicios. Los componentes principales son: `API de Recepción`, `Servicio de Procesamiento Inicial`, `Servicio de Consolidación (ETL)` y `API de Consulta`. El diseño de clases se encuentra en `docs/diseno_clases_funciones.md`.
*   **Flujo de Datos Multi-Etapa:**
    1.  Los datos crudos se reciben en la base de datos `sep_ides`.
    2.  Un proceso ETL los transfiere al área de staging (`tbae*`) *dentro de* la base de datos `sep_muses`.
    3.  Finalmente, se consolidan en las tablas núcleo (`tbmu*`) de `sep_muses`.
    Este flujo está documentado en un ADR y en un diagrama de secuencia.

## 3. Flujo de Trabajo

*   **Pull Requests:** Todo el trabajo se debe realizar en ramas descriptivas (ej. `feat/nueva-funcionalidad`, `fix/corregir-bug`) y enviarse a través de Pull Requests a la rama `main`. No se debe hacer push directamente a `main`.
*   **Commits Semánticos:** Los mensajes de commit deben seguir la convención de Commits Semánticos.
*   Para más detalles sobre el flujo de trabajo, consulta el archivo `CONTRIBUTING.md`.

## 4. Estilo y Formato

*   **Documentación:** Los documentos de texto deben estar en formato Markdown.
*   **Diagramas:** Todos los diagramas (E-R, componentes, secuencia) deben crearse usando **Mermaid**.
*   **Nombres de Archivos:** Los nombres de los archivos deben ser descriptivos y no deben contener prefijos numéricos.

Al seguir estas directrices, asegurarás que tu trabajo se alinee con los estándares y la arquitectura del proyecto SEP-MUSES.
