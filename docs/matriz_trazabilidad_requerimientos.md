# Matriz de Trazabilidad de Requerimientos

## 1. Introducción
Este documento presenta la matriz de trazabilidad que vincula los requerimientos funcionales (RF) con los casos de prueba (CP) diseñados para validarlos. El objetivo es asegurar que todos los requerimientos especificados tengan una cobertura de pruebas adecuada.

## 2. Matriz de Trazabilidad

| ID Requerimiento | Título del Requerimiento | ID Caso de Prueba | Título del Caso de Prueba |
|---|---|---|---|
| **RF-001** | Autenticación de Usuarios | CP-001 | Inicio de sesión exitoso con credenciales válidas. |
| | | CP-002 | Falla de inicio de sesión con contraseña incorrecta. |
| | | CP-003 | Falla de inicio de sesión con usuario inexistente. |
| **RF-002** | Gestión de Usuarios | CP-004 | Administrador crea un nuevo usuario de "Control Escolar". |
| | | CP-005 | Administrador desactiva una cuenta de usuario existente. |
| **RF-003** | Asignación de Roles | CP-006 | Administrador asigna rol "Admin" a un usuario. |
| | | CP-007 | Usuario "Control Escolar" no puede acceder a la pantalla de gestión de usuarios. |
| **RF-004** | Recepción de Datos de Inscripción | CP-008 | API procesa correctamente un lote de 10 inscripciones válidas. |
| | | CP-009 | API rechaza un lote que contiene un registro con formato de fecha inválido. |
| **RF-005** | Recepción de Datos de Baja | CP-010 | API procesa una baja definitiva para un alumno existente. |
| **RF-006** | Recepción de Calificaciones | CP-011 | API procesa un lote de calificaciones para un grupo. |
| **RF-007** | Validación de Datos de Entrada | CP-012 | API rechaza un registro de inscripción con un tipo de dato incorrecto en un campo numérico. |
| **RF-008** | Validación de CURP contra RENAPO | CP-013 | Worker de procesamiento valida exitosamente una CURP existente. |
| | | CP-014 | Worker de procesamiento marca como error un registro con una CURP inexistente. |
| **RF-009** | Validación de CCT | CP-015 | Worker de procesamiento valida exitosamente una CCT existente. |
| | | CP-016 | Worker de procesamiento marca como error un registro con una CCT inválida. |
| **RF-010** | Almacenamiento en BD Staging | CP-017 | Verificar que un registro recibido (válido o inválido) se inserta en `tbae001_inscripcion`. |
| **RF-011** | Almacenamiento en BD Central | CP-018 | Verificar que un registro válido se inserta correctamente en las tablas `tbmu*` correspondientes. |
| | | CP-019 | Verificar que un registro inválido NO se inserta en las tablas `tbmu*`. |
| **RF-012** | Consulta de Trayectoria de Alumno | CP-020 | Usuario busca por CURP y visualiza el historial académico completo y correcto. |
| | | CP-021 | Usuario busca por una CURP sin registros y recibe un mensaje informativo. |
| **RF-013** | Generación de Reporte de Matrícula | CP-022 | Usuario genera un reporte de matrícula y el archivo CSV se descarga con los datos correctos. |
| **RF-014** | Trazabilidad de Errores | CP-023 | Verificar que un registro fallido en la `tbae001_inscripcion` tiene una entrada correspondiente en `tbae010_error` con el motivo correcto. |