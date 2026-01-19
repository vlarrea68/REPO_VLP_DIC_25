# Plan de Trabajo: Actividades por Componente

| Componente | Actividad Clave | Tareas Detalladas | Dependencias |
|---|---|---|---|
| **API Gateway y API Unificada**| **Diseño e Implementación del API** | - Definir el schema de GraphQL.<br>- Implementar los resolvers para las queries y mutations.<br>- Configurar el endpoint de carga de archivos.<br>- Implementar la publicación de eventos en la Cola de Mensajes. | Schema GraphQL |
| **Servicio de Procesamiento** | **Implementar Lógica de Validación** | - Desarrollar el consumidor de la Cola de Mensajes.<br>- Implementar la lógica de validación de CURP contra RENAPO.<br>- Escribir los datos crudos en las tablas de intercambio (`tbae*`) de `sep_muses`. | Acceso a RENAPO, BD Central |
| | **Implementar Proceso ETL** | - Desarrollar el `DataTransformer` para mapear datos de `tbae*` a `tbmu*`.<br>- Implementar el orquestador que mueva los datos dentro de `sep_muses`.<br>- Desarrollar la lógica para el manejo de errores y reintentos. | BD Central |
| **Base de Datos** | **Diseño e Implementación** | - Crear y mantener los scripts DDL para `sep_muses` (incluyendo `tbae*`, `ctmu*`, `tbmu*`).<br>- Diseñar e implementar los índices necesarios.<br>- Cargar los datos iniciales de los catálogos. | Diseño de Datos (ER) |
| | **Operaciones y Mantenimiento** | - Configurar el plan de backups automáticos.<br>- Desarrollar y programar el script de purga para las tablas `tbae*`. | Infraestructura |
| **Frontend Web** | **Desarrollo de Interfaz de Carga** | - Crear el formulario para la carga manual de eventos.<br>- Desarrollar el componente para la carga masiva de archivos CSV. | API Unificada |
| | **Desarrollo de Interfaz de Consulta** | - Crear la vista para consultar la trayectoria de un alumno.<br>- Integrar la consulta con la API GraphQL. | API Unificada |
