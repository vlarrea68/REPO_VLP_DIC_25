# 1. Decisión: Arquitectura de Base de Datos Centralizada con Staging Interno

*   **Fecha:** 2025-11-04
*   **Estado:** Aceptado

## Contexto

Durante la fase inicial de diseño, se consideraron dos enfoques para la arquitectura de la base de datos:

1.  **BD Multi-Etapa:** Un enfoque con dos bases de datos centrales separadas: una `sep_ides` para la recepción de datos crudos y una `sep_muses` para los datos consolidados.
2.  **BD Centralizada con Staging Interno:** Un enfoque con una única base de datos central (`sep_muses`) que contiene esquemas o grupos de tablas lógicamente separados para el staging (`tbae*`), los catálogos (`ctmu*`) y los datos núcleo (`tbmu*`).

La documentación inicial era ambigua y contenía elementos de ambos enfoques, lo que generaba inconsistencias. Se necesitaba una decisión clara para unificar el diseño.

## Decisión

Se ha decidido adoptar formalmente el enfoque de **Base de Datos Centralizada con Staging Interno**.

La base de datos `sep_muses` será la única base de datos central del sistema. El flujo de datos será el siguiente:
1.  Los datos crudos de los subsistemas se cargarán en las tablas de intercambio (`tbae*`) dentro de `sep_muses`.
2.  Un proceso ETL operará *dentro* de `sep_muses`, validando los datos de las tablas `tbae*` contra los catálogos (`ctmu*`).
3.  Los datos limpios y normalizados se almacenarán en las tablas núcleo (`tbmu*`).

El término `sep_ides` se referirá exclusivamente a las bases de datos locales que existen en los Sistemas Externos (Subsistemas), y no a un componente de la plataforma central SEP-MUSES.

## Consecuencias

*   **Positivas:**
    *   **Simplificación Operativa:** Gestionar, respaldar y monitorear una sola base de datos es más sencillo que gestionar dos.
    *   **Consistencia:** Elimina la posibilidad de inconsistencias entre la documentación de alto nivel y el diseño detallado.
    *   **Rendimiento en ETL:** Las transferencias de datos entre las etapas de staging y núcleo son más rápidas, ya que ocurren dentro de la misma instancia de base de datos, evitando la sobrecarga de red.
*   **Negativas:**
    *   **Carga en la BD Central:** Todo el procesamiento de datos (recepción, validación, consolidación) recae sobre la misma instancia de base de datos. Esto requerirá un monitoreo cuidadoso del rendimiento para asegurar que la carga de datos no impacte las operaciones de consulta.
*   **Acción Requerida:**
    *   Toda la documentación del proyecto debe ser auditada y actualizada para reflejar esta decisión. Se deben eliminar las referencias a `sep_ides` como una base de datos de recepción central.
