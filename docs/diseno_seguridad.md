# Diseño de Seguridad Detallado del Sistema SEP-MUSES

## 1. Propósito

Este documento detalla la arquitectura y las estrategias de seguridad que se implementarán en el sistema SEP-MUSES (backend y frontend) para proteger la integridad, confidencialidad y disponibilidad de los datos.

## 2. Autenticación y Autorización

### 2.1. Autenticación de Sistemas (API del Gateway)

*   **Mecanismo:** Se utilizará un esquema de **API Key**.
*   **Flujo:**
    1.  A cada sistema estatal autorizado para consumir el Gateway se le asignará una API Key única, generada y gestionada por los administradores de la SEP.
    2.  El sistema cliente deberá incluir esta API Key en la cabecera HTTP `X-API-Key` en cada petición.
    3.  El API Gateway validará la existencia y el estado (activo/inactivo) de la API Key antes de procesar cualquier petición.
    4.  Las peticiones sin una API Key válida serán rechazadas con un código de estado `401 Unauthorized`.
*   **Gestión de Keys:** Las API Keys se almacenarán de forma segura en la base de datos o en un servicio de gestión de secretos (ver sección 3), asociadas al sistema estatal correspondiente.

### 2.2. Autenticación de Usuarios (Aplicación `muses-web`)

*   **Mecanismo:** Se implementará un flujo de autenticación estándar de la industria basado en **OpenID Connect (OIDC) 1.0**, que opera sobre **OAuth 2.0**. Se utilizará un Proveedor de Identidad (IdP) centralizado como **Keycloak** (opción de código abierto recomendada) o Azure AD.

*   **Flujo de Autenticación (Authorization Code Flow):** Este flujo es el más seguro para aplicaciones web y garantiza que las credenciales del usuario nunca sean expuestas directamente al frontend.

    ```mermaid
    sequenceDiagram
        participant Usuario
        participant Frontend (muses-web)
        participant IdP (Keycloak)
        participant Backend (API de Consulta)

        Usuario->>Frontend (muses-web): 1. Accede a la aplicación
        Frontend (muses-web)->>Usuario: 2. Redirige al IdP para login

        activate Usuario
        Usuario->>IdP (Keycloak): 3. Ingresa credenciales (usuario/contraseña)
        IdP (Keycloak)-->>Usuario: 4. Autenticación exitosa, redirige de vuelta al Frontend con un `authorization_code`
        deactivate Usuario

        Frontend (muses-web)->>IdP (Keycloak): 5. Intercambia el `authorization_code` por tokens (ID Token, Access Token)
        IdP (Keycloak)-->>Frontend (muses-web): 6. Devuelve los tokens (JWT)

        activate Frontend (muses-web)
        Frontend (muses-web)-->>Frontend (muses-web): 7. Almacena los tokens de forma segura y establece la sesión del usuario
        deactivate Frontend (muses-web)

        Usuario->>Frontend (muses-web): 8. Realiza una acción (ej. consultar trayectoria)
        Frontend (muses-web)->>Backend (API de Consulta): 9. Llama a la API incluyendo el `Access Token` (JWT) en la cabecera `Authorization: Bearer <token>`

        activate Backend (API de Consulta)
        Backend (API de Consulta)-->>Backend (API de Consulta): 10. Valida la firma y los `claims` del JWT
        Backend (API de Consulta)-->>Frontend (muses-web): 11. Devuelve los datos solicitados
        deactivate Backend (API de Consulta)
    ```

*   **Detalles de Implementación:**
    1.  **Redirección al IdP:** Cuando un usuario no autenticado intente acceder a una ruta protegida, el frontend lo redirigirá a la página de login del IdP (Keycloak).
    2.  **Intercambio de Código por Tokens:** Tras el login exitoso, el IdP redirige al usuario de vuelta a la aplicación con un `authorization_code` de un solo uso. El frontend realiza una llamada segura "back-channel" al IdP para intercambiar este código por un `ID Token` (con información del usuario) y un `Access Token` (para autorizar llamadas a la API).
    3.  **Almacenamiento de Tokens:** Los tokens se almacenarán de forma segura en el navegador, preferiblemente en memoria o, si se requiere persistencia entre sesiones, utilizando mecanismos seguros que mitiguen ataques XSS.
    4.  **Llamadas a la API:** En cada petición a la **API de Consulta**, el `Access Token` (JWT) se incluirá en la cabecera `Authorization` como un `Bearer Token`.
    5.  **Validación en el Backend:** La API de Consulta estará configurada para validar los JWT entrantes. Verificará la firma del token contra la clave pública del IdP, el `issuer`, la `audience` y la fecha de expiración para garantizar su autenticidad y validez.

### 2.3. Autorización y Control de Acceso Basado en Roles (RBAC)

Se definirán los siguientes roles dentro de `muses-web`:

*   **`rol_capturista_estatal`**:
    *   **Permisos:** Puede acceder a los módulos de Inscripción, Bajas y Evaluaciones. Puede ver y capturar datos únicamente para los CCT asociados a su entidad.
*   **`rol_admin_estatal`**:
    *   **Permisos:** Hereda los permisos de `rol_capturista_estatal`. Además, puede gestionar los siguientes catálogos locales de su entidad: Género, Materias, Programas y Planes de Estudio.
*   **`rol_admin_sep`**:
    *   **Permisos:** Acceso total. Puede gestionar los catálogos nacionales (ej. CCT, Motivos de Baja) y administrar usuarios y roles a nivel de todo el sistema.
*   **Implementación:**
    *   En el **frontend**, los roles contenidos en el JWT se utilizarán para mostrar u ocultar dinámicamente las opciones del menú y los componentes (guardas de ruta de Angular).
    *   En el **backend**, aunque la API se autentica por sistema, se pueden implementar endpoints administrativos que requieran una validación de rol adicional si fuera necesario en el futuro.

## 3. Gestión de Secretos

*   **API Keys, Contraseñas de BD, Secretos de JWT:** Todos los secretos de la aplicación NO deben estar hardcodeados en el código fuente ni en los archivos de configuración del repositorio.
*   **Solución:** Se utilizará un servicio de gestión de secretos como **HashiCorp Vault** o el gestor de secretos nativo del proveedor de nube (ej. AWS Secrets Manager, Azure Key Vault).
*   **Flujo:**
    1.  En el arranque, las aplicaciones (Gateway, microservicios) se autenticarán con el servicio de secretos.
    2.  Obtendrán las credenciales necesarias (contraseñas de BD, etc.) y las cargarán en memoria como variables de entorno.

## 4. Seguridad en la Comunicación

*   **Cifrado en Tránsito:** Toda la comunicación entre el cliente y el servidor (API y web) y entre los microservicios internos deberá ser cifrada utilizando **TLS 1.2 o superior (HTTPS)**.
*   **Cabeceras de Seguridad:** La aplicación `muses-web` deberá incluir cabeceras de seguridad HTTP para mitigar ataques comunes de XSS, clickjacking, etc. (ej. `Content-Security-Policy`, `Strict-Transport-Security`, `X-Frame-Options`).

## 5. Prevención de Vulnerabilidades Comunes (OWASP Top 10)

*   **Inyección (SQL, etc.):** Todas las consultas a la base de datos deben utilizar **consultas parametrizadas (prepared statements)**. Se debe evitar la construcción de consultas mediante la concatenación de strings.
*   **Exposición de Datos Sensibles:** La API nunca debe devolver información sensible en los mensajes de error (ej. stack traces). Los logs no deben contener datos personales como CURP o nombres completos en texto plano; se deben enmascarar.
*   **Validación de Datos:** Se implementará una validación estricta de todos los datos de entrada tanto en el frontend como en el backend, siguiendo el principio de "nunca confiar de la entrada del usuario".

## 6. Auditoría y Monitoreo

*   **Logs de Auditoría:** El sistema registrará eventos de seguridad clave en un log separado, incluyendo:
    *   Intentos de login exitosos y fallidos.
    *   Acceso a recursos críticos.
    *   Cambios en la configuración o en los roles de usuario.
*   **Monitoreo de Seguridad:** Se configurarán alertas para detectar actividades sospechosas, como un alto volumen de errores de autenticación desde una misma IP.
