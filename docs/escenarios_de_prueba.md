**Escenarios y Datos de Prueba por Módulo – Proyecto SIGED Interoperable**

---

### Módulo: Registro de Inscripciones

**Escenario 1: Inscripción válida completa**
- CURP: LOPE800101HMNXXX01
- CCT: 09DPR1234Z
- Nivel educativo: Primaria
- Ciclo escolar: 2025-2026
- Resultado esperado: Acuse generado con UUID y sello de tiempo

**Escenario 2: CURP inválida**
- CURP: LOPE800101HMN123 (incompleta)
- Resultado esperado: Rechazo con mensaje de error de CURP

**Escenario 3: CCT inactivo**
- CCT: 09XXX0000X
- Resultado esperado: Rechazo con mensaje de CCT no válido

---

### Módulo: Reporte de Bajas

**Escenario 1: Baja con motivo válido**
- CURP: GARC920101HDFABC04
- Fecha de baja: 2025-11-15
- Motivo: 02 (Cambio de domicilio)
- Resultado esperado: Acuse de baja con UUID

**Escenario 2: Motivo inválido**
- Motivo: 99 (no catalogado)
- Resultado esperado: Rechazo por valor fuera de catálogo

**Escenario 3: CURP sin inscripción previa**
- CURP: MORA900101MPLXXX05
- Resultado esperado: Error de referencia a inscripción inexistente

---

### Módulo: Evaluaciones

**Escenario 1: Evaluación parcial válida**
- CURP: RAMI950630HDFXXX02
- Clave de asignatura: MAT2
- Tipo de evaluación: Parcial
- Calificación: 8.5
- Resultado esperado: Acuse de evaluación aceptada

**Escenario 2: Calificación fuera de rango**
- Calificación: 11
- Resultado esperado: Rechazo por validación numérica

**Escenario 3: Evaluación duplicada**
- CURP y asignatura ya registradas
- Resultado esperado: Error por duplicidad

---

### Módulo: Certificación

**Escenario 1: Certificado con promedio válido y firma digital**
- CURP: PERE910101HDFXXX08
- Promedio: 9.2
- Firma digital: válida
- Resultado esperado: Registro exitoso con UUID

**Escenario 2: Firma digital inválida**
- Firma alterada o vencida
- Resultado esperado: Rechazo por integridad documental

**Escenario 3: Folio duplicado**
- Folio previamente usado
- Resultado esperado: Error por violación de unicidad

---

### Módulo: Titulación

**Escenario 1: Titulación completa válida**
- CURP: LOZO860101MCMXXX00
- Carrera: Técnico en Informática
- Fecha de titulación: 2026-07-01
- Firma digital: válida
- Resultado esperado: Acuse de titulación con UUID

**Escenario 2: CURP sin certificado previo**
- Resultado esperado: Rechazo por dependencia incumplida

---

### Módulo: Catálogos

**Escenario 1: Publicación válida de catálogo actualizado**
- Versión: 2.0
- Tipo: Motivos de baja
- Formato: JSON
- Resultado esperado: Aceptación y registro en validador

**Escenario 2: Formato incorrecto**
- Archivo con error de sintaxis JSON
- Resultado esperado: Rechazo con detalle estructural

**Escenario 3: Versión duplicada**
- Intento de republicar versión 1.0
- Resultado esperado: Error de conflicto de versión

---

**Notas finales:**
- Todos los escenarios deben ejecutarse con datos sintéticos controlados.
- Se debe generar evidencia con capturas de peticiones/respuestas para cada escenario.
- Estos casos son referencia para pruebas automatizadas y manuales en las iteraciones del ciclo de vida RUP.
