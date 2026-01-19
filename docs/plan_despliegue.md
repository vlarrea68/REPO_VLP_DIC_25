# Plan y Checklist de Despliegue a Producción

## 1. Propósito

Este documento describe los pasos, responsables y verificaciones necesarias para realizar un despliegue exitoso y seguro del sistema SEP-MUSES a su entorno productivo.

## 2. Equipo Responsable

| Rol | Nombre(s) |
| :--- | :--- |
| **Líder de Despliegue** | [Nombre del Líder] |
| **Equipo de Infraestructura** | [Nombres] |
| **Equipo de Desarrollo** | [Nombres] |
| **Equipo de QA** | [Nombres] |
| **DBA (Administrador de BD)** | [Nombre] |

## 3. Checklist de Pre-Despliegue

| Tarea | Responsable | Estado |
| :--- | :--- | :--- |
| **Comunicación** | | |
| 1.1. Notificar a los stakeholders sobre la ventana de mantenimiento | Líder de Despliegue | [ ] |
| 1.2. Confirmar la disponibilidad del equipo de despliegue | Todos | [ ] |
| **Entorno** | | |
| 2.1. Verificar que el entorno de producción cumple los requisitos | Infraestructura | [ ] |
| 2.2. Realizar un backup completo de la base de datos de producción | DBA | [ ] |
| 2.3. Asegurar que las credenciales y configuraciones de producción están listas| Infraestructura | [ ] |
| **Calidad y Código** | | |
| 3.1. Confirmar que la versión a desplegar ha pasado todas las pruebas de QA | Líder de QA | [ ] |
| 3.2. Verificar que no hay defectos críticos pendientes | Líder de QA | [ ] |
| 3.3. Fusionar la rama de la versión (`release/vX.X`) a la rama principal (`main`) | Líder de Desarrollo | [ ] |
| 3.4. Crear una etiqueta (tag) de la versión en el repositorio de código | Líder de Desarrollo | [ ] |

## 4. Plan de Ejecución del Despliegue

| Paso | Tarea | Responsable |
| :--- | :--- | :--- |
| 1 | **Iniciar Ventana de Mantenimiento** | Líder de Despliegue |
| 2 | Poner la aplicación en modo mantenimiento (si aplica) | Infraestructura |
| 3 | Ejecutar los scripts de migración de la base de datos (DDL/DML) | DBA |
| 4 | Desplegar los nuevos artefactos de la aplicación (contenedores/binarios) | Infraestructura |
| 5 | Reiniciar los servicios de la aplicación | Infraestructura |
| 6 | **Verificación Post-Despliegue (Smoke Testing)** | |
| | 6.1. Validar la conectividad con la base de datos | Desarrollo / Infra |
| | 6.2. Probar la conectividad con servicios externos (RENAPO) | Desarrollo / Infra |
| | 6.3. Realizar una transacción de prueba de cada tipo (inscripción, baja) | QA |
| | 6.4. Monitorear los logs en busca de errores | Todos |
| 7 | **Finalizar Ventana de Mantenimiento** | |
| | 7.1. Desactivar el modo mantenimiento | Infraestructura |
| | 7.2. Comunicar a los stakeholders que el despliegue ha sido exitoso | Líder de Despliegue |

## 5. Plan de Rollback (Contingencia)

En caso de un fallo crítico durante el despliegue, se seguirán los siguientes pasos:

| Paso | Tarea | Responsable |
| :--- | :--- | :--- |
| 1 | **Decisión de Rollback:** El Líder de Despliegue toma la decisión. | Líder de Despliegue |
| 2 | **Restaurar Base de Datos:** Restaurar el backup de la BD tomado antes del despliegue. | DBA |
| 3 | **Restaurar Aplicación:** Desplegar la versión anterior de la aplicación desde la etiqueta (tag) correspondiente. | Infraestructura |
| 4 | **Verificar:** Realizar una verificación rápida para asegurar que el sistema está operativo en su estado anterior. | QA |
| 5 | **Comunicar:** Notificar a los stakeholders sobre el rollback y el estado del sistema. | Líder de Despliegue |
| 6 | **Análisis Post-Mortem:** Realizar un análisis de la causa raíz del fallo. | Todo el Equipo |
