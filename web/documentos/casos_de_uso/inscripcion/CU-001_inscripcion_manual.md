# CU-001 Inscripción manual de estudiante

## Identificación
- **Nombre**: Inscripción manual de estudiante
- **Actor primario**: Personal administrativo de control escolar
- **Actores secundarios**: Sistema SEP MUSES, Servicios de validación de datos (CURP, correo electrónico)
- **Tipo**: Esencial
- **Prioridad**: Alta

## Breve descripción
Permite registrar a un estudiante individual en el sistema mediante un formulario web. El caso de uso contempla validaciones de datos obligatorios, búsqueda de coincidencias para evitar registros duplicados y confirmación del alta exitosa.

## Precondiciones
- El usuario administrativo cuenta con sesión iniciada y permisos para registrar estudiantes.
- El ciclo escolar y el grupo destino del alumno están activos.
- El formulario de inscripción está accesible desde el menú de gestión de estudiantes.

## Postcondiciones
- El estudiante queda registrado y asociado al grupo indicado.
- Se genera un folio de inscripción y se notifica al usuario el resultado.

## Flujo principal
1. El usuario abre el formulario "Inscribir estudiante".
2. El sistema muestra campos obligatorios: datos personales, información de contacto y asignación académica.
3. El usuario captura los datos requeridos.
4. El sistema valida la estructura de los campos (formato de CURP, correo electrónico, teléfono, etc.).
5. El sistema verifica si existe un estudiante con la misma CURP o correo electrónico.
6. El sistema solicita confirmación del usuario para proceder con el registro.
7. El usuario confirma la inscripción.
8. El sistema registra al estudiante, asigna folio y grupo, y guarda la información.
9. El sistema muestra un mensaje de éxito y el resumen de los datos capturados.

## Flujos alternos
- **FA1: Datos obligatorios incompletos**
  1. En el paso 4, el sistema detecta campos faltantes o formatos inválidos.
  2. El sistema muestra mensajes de error indicando los campos a corregir.
  3. El flujo regresa al paso 3.

- **FA2: Estudiante duplicado**
  1. En el paso 5, el sistema detecta un estudiante existente con la misma CURP o correo electrónico.
  2. El sistema muestra la ficha del estudiante existente y pregunta si se desea actualizar la información.
  3. El usuario decide cancelar o actualizar. Si cancela, el caso de uso termina sin registrar un nuevo estudiante. Si elige actualizar, se ejecuta el caso de uso **CU-001a Actualizar datos de estudiante** (fuera de alcance actual).

## Requerimientos especiales
- Validaciones de formato en tiempo real mientras el usuario captura los datos.
- Indicadores visuales de obligatoriedad y progreso.
- Accesibilidad: etiquetas y mensajes compatibles con lectores de pantalla.

## Reglas de negocio
- RB-001: La CURP es el identificador único del estudiante.
- RB-002: Solo se pueden registrar estudiantes en grupos con cupo disponible.
- RB-003: Los campos obligatorios deben completarse antes de permitir la confirmación.

## Suposiciones
- La institución proporciona la lista de grupos con cupo actualizado.
- El personal administrativo conoce los criterios de validación de datos.
