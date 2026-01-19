# Proyecto MUES
**Matrícula Única de Educación Superior**

## Procesos de la Solución

La solución del proyecto **MUES** se estructura en 5 procesos principales:

- **Captura / Inserción**
  Utiliza una **pantalla de captura** o una **captura masiva** mediante un archivo de texto generado con un layout o **Scripts con Insert** para realizar el llenado de la tabla en la base de datos de origen.

- **Réplica**
  Utiliza un **servicio desarrollado en Node.js**, encargado de detectar las inserciones o modificaciones de datos en las bases de datos de origen y replicarlos en la base de datos central.

- **Validación**
  Una vez replicados los registros en la base de datos central, un componente aplica las **validaciones de negocio** necesarias y actualiza los registros, asignando un estatus: **RECHAZADO, ACEPTADO CON ERROR, o ACEPTADO**.

- **Respuesta**
  Tras la validación, se envían mensajes a un **Servicio de Mensajería** (*RabbitMQ*) o a una **Cola (QUEUE)**, de manera que un componente del lado de la institución procese la respuesta y la almacene en tablas que detallan el resultado de cada registro.

- **Generar Histórico**
  Una vez enviadas las respuestas se realiza la normalizacion de los registros con estatus **ACEPTADO** en la base de datos central y se guardan estos registros en tablas historicas.
