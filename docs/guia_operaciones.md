# Guía de Operaciones (Runbook)

## 1. Introducción
Este documento es una guía para el equipo de operaciones y SRE responsable de mantener el sistema SEP-MUSES. Contiene procedimientos para el monitoreo, la resolución de problemas comunes y el mantenimiento rutinario.

## 2. Monitoreo y Alertas

| Métrica Clave | Componente | Descripción | Umbral de Alerta (Warning) | Umbral de Alerta (Critical) |
|---|---|---|---|---|
| **Latencia del Proceso ETL**| Serv. Consolidación | Tiempo promedio desde `TBAE*` hasta `TBMU*` (núcleo). | > 15 minutos | > 45 minutos |
| ... | ... | ... | ... | ... |

## 3. Guía de Troubleshooting

| Síntoma | Causas Probables | Pasos de Resolución |
|---|---|---|
| **Alerta: La cola de mensajes crece sin parar.** | 1. El `Servicio de Procesamiento Inicial` está caído.<br>2. Errores de conexión a la BD `sep_muses`. | 1. **Verificar logs:** Revisar los logs del `Servicio de Procesamiento` en busca de errores.<br>2. **Verificar estado del consumidor:** Asegurarse de que el worker esté activo.<br>3. **Escalar los consumidores:** Aumentar el número de réplicas del servicio. |
| **Alerta: La latencia del ETL está aumentando.** | 1. Consultas lentas en `sep_muses`.<br>2. Sobrecarga de la BD `sep_muses`.<br>3. El `Servicio de Consolidación` está procesando un lote muy grande. | 1. **Analizar logs de BD:** Buscar consultas lentas (`slow query log`).<br>2. **Verificar índices:** Asegurarse de que las tablas `tbae*` y `tbmu*` tengan los índices adecuados. |

## 4. Procedimientos de Mantenimiento

### 4.1. Purga de las Tablas de Intercambio (`TBAE*`)

*   **Propósito:** Las tablas `TBAE*` crecerán indefinidamente. Para controlar su tamaño, los registros ya procesados deben ser archivados o eliminados.
*   **Frecuencia:** Semanal.
*   **Procedimiento:**
    1.  Ejecutar un script que archive los registros de las tablas `TBAE*` con más de **90 días** de antigüedad a un almacenamiento de bajo costo.
    2.  Una vez archivados y verificados, ejecutar un `DELETE` para eliminar esos registros de la base de datos.

### 4.2. Backups de la Base de Datos

| Base de Datos | Herramienta | Tipo de Backup | Frecuencia | Retención | Almacenamiento |
|---|---|---|---|---|---|
| **`sep_muses`** | `pg_dump` | Completo (Full) | Diario (03:30 AM) | 30 días | Almacenamiento S3 encriptado |
