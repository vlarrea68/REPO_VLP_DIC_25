# Criterios de Aceptación

## 1. Propósito

Este documento define los criterios que deben cumplirse para que las funcionalidades clave del sistema SEP-MUSES sean consideradas "completas" y aceptadas. Están directamente ligados a los requerimientos funcionales definidos en el documento de alcance.

---

### **RF-B-01: Recepción de Eventos Educativos (Backend)**

*   **Criterio 1.1 (Carga Exitosa de Archivo):**
    *   **Dado** que un cliente envía una petición POST a `/eventos/carga-masiva` con un archivo CSV válido que cumple con el layout,
    *   **Cuando** la petición es procesada,
    *   **Entonces** el sistema debe responder con un HTTP 202 (Accepted) y un UUID de la transacción de carga.
    *   **Y** un mensaje con la referencia al archivo debe ser publicado en la cola para su procesamiento asíncrono.

*   **Criterio 1.2 (Validación de Estructura del Archivo):**
    *   **Dado** que un cliente envía un archivo CSV con columnas que no coinciden con el layout (ej. falta la columna `curp`),
    *   **Cuando** la petición es procesada por el API de Recepción,
    *   **Entonces** el sistema debe responder con un HTTP 400 (Bad Request) y un mensaje de error claro indicando la inconsistencia en la estructura.

---

### **RF-B-02: Proceso de Transferencia y Consolidación (ETL)**

*   **Criterio 2.1 (ETL Exitoso):**
    *   **Dado** que existe un registro válido y no procesado en la tabla `tbae001_inscripcion_subsis`,
    *   **Cuando** el proceso ETL se ejecuta,
    *   **Entonces** se deben crear los registros correspondientes en las tablas normalizadas de `sep_muses` (ej. `tbmu002_persona`, `tbmu020_alumno`, `tbmu006_inscripcion`).
    *   **Y** el registro original en la BD de recepción debe ser marcado como procesado.

*   **Criterio 2.2 (Manejo de Duplicados):**
    *   **Dado** que el ETL procesa una inscripción para un alumno que ya tiene una inscripción activa en el mismo CCT y ciclo escolar,
    *   **Cuando** intenta insertar el dato en `tbmu006_inscripcion`,
    *   **Entonces** la transacción debe fallar debido a la constraint de unicidad, y el error debe ser registrado en los logs del ETL.

---

### **RF-F-01: Captura Manual de Inscripciones (Frontend)**

*   **Criterio 3.1 (Validación en Frontend):**
    *   **Dado** que un usuario está en el formulario de inscripción en `muses-web`,
    *   **Cuando** intenta ingresar una CURP con un formato incorrecto,
    *   **Entonces** la interfaz debe mostrar un mensaje de error de validación debajo del campo en tiempo real, sin enviar la petición al backend.

---

### **RNF-01: Seguridad**

*   **Criterio 5.1 (Acceso a API sin Key):**
    *   **Dado** que un cliente intenta acceder a cualquier endpoint de la API sin una `X-API-Key` válida,
    *   **Cuando** realiza la petición,
    *   **Entonces** el sistema debe responder con un HTTP 401 (Unauthorized).

*   **Criterio 5.2 (Acceso a Ruta Protegida sin Login):**
    *   **Dado** que un usuario anónimo intenta acceder a la ruta `/inscripciones` en `muses-web`,
    *   **Cuando** navega a esa URL,
    *   **Entonces** la aplicación debe redirigirlo a la página de login.
