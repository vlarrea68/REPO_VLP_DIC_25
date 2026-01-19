# Arquitectura Detallada del Frontend (Angular) - SEP-MUSES

## 1. Introducción y Principios Arquitectónicos
... (Contenido sin cambios) ...

## 4. Módulos Principales
-   **CoreModule**: Provee servicios singleton (configuración, autenticación, logging).
-   **SharedModule**: Componentes reutilizables sin estado (formularios, tablas, etc.).
-   **Feature Modules** (cargados con lazy loading):
    -   `InscripcionesModule`: Formularios para captura manual y componente para carga masiva.
    -   `BajasModule`: Lógica y vistas para el registro de bajas de alumnos.
    -   `CargaMasivaModule`: Vistas para monitorear el progreso y resultados de cargas masivas.
    -   `CatalogosModule`: **Gestiona únicamente los catálogos locales permitidos ('Genero', 'Materias', 'Programas', 'Planes de estudio').**
    -   `AdminModule`: Gestión de usuarios, roles y auditoría.

## 5. Patrones de Diseño Detallados
### 5.1. Gestión de Estado (Signals y Persistencia Local)
... (Contenido sin cambios) ...

### 5.2. Gestión de Datos y Catálogos
-   **Modelo de Catálogos Híbrido**: El sistema distingue entre dos tipos de catálogos:
    -   **Catálogos Centrales/Externos**: La gran mayoría de los catálogos (ej. Planteles CCT, Carreras, Países, Entidades Federativas, Motivos de Baja) son consumidos desde la API del backend. El frontend los trata como datos de solo lectura y los cachea localmente para mejorar el rendimiento.
    -   **Catálogos de Gestión Local**: La gestión local (crear, editar, eliminar a través de la UI) se limita **exclusivamente** a cuatro catálogos: **'Género', 'Materias', 'Programas' y 'Planes de estudio'**.
-   **Servicios de Catálogos**: Un `CatalogoService` centralizado se encarga de obtener y cachear los catálogos externos. Un servicio separado podría manejar las operaciones CRUD para los cuatro catálogos locales.
... (Resto del contenido sin cambios) ...
