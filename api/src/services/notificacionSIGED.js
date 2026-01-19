// api/src/services/notificacionSIGED.js
const { Pool } = require('pg');
const axios = require('axios');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'user',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'sep_muses',
});

const obtenerDatosConsolidados = async () => {
  console.log("Conectando a la base de datos para leer datos consolidados...");
  let client;
  try {
    client = await pool.connect();

    // Consulta para inscripciones no notificadas
    const inscripcionesQuery = `
      SELECT 'INSCRIPCION' as tipo_evento, i.id_inscripcion as id, p.curp, i.cct
      FROM muses_dev.tbmu006_inscripcion i
      JOIN muses_dev.tbmu020_alumno a ON i.id_alumno = a.id_alumno
      JOIN muses_dev.tbmu002_persona p ON a.id_alumno = p.id_persona
      WHERE i.notificado_siged = false
      LIMIT 5;`;

    // Consulta para bajas no notificadas
    const bajasQuery = `
      SELECT 'BAJA' as tipo_evento, b.id_baja as id, p.curp, b.cct
      FROM muses_dev.tbmu013_bajas b
      JOIN muses_dev.tbmu002_persona p ON b.id_persona = p.id_persona
      WHERE b.notificado_siged = false
      LIMIT 5;`;

    const [inscripcionesResult, bajasResult] = await Promise.all([
      client.query(inscripcionesQuery),
      client.query(bajasQuery)
    ]);

    const eventos = [...inscripcionesResult.rows, ...bajasResult.rows];
    console.log(`Se encontraron ${eventos.length} registros en la base de datos.`);
    return eventos;

  } catch (error) {
    console.error("Error al conectar o consultar la base de datos:", error.message);
    console.log("Usando datos simulados para continuar con el flujo.");
    return [
      { id: 101, tipo_evento: "INSCRIPCION", curp: "XXXX010101HXXXXXX1", cct: "09PBH0001X" },
      { id: 102, tipo_evento: "BAJA", curp: "YYYY020202MYYYYYY2", cct: "15PBH0002Y" },
    ];
  } finally {
    if (client) {
      client.release();
    }
  }
};

const notificarSIGED = async (evento) => {
  const urlSIGED = process.env.SIGED_API_URL || 'https://jsonplaceholder.typicode.com/posts';
  console.log(`Enviando evento ID ${evento.id} (${evento.tipo_evento}) a SIGED en ${urlSIGED}...`);
  try {
    const payload = { idOperacion: evento.id, tipo: evento.tipo_evento, datosAlumno: { curp: evento.curp, cct: evento.cct } };
    const respuesta = await axios.post(urlSIGED, payload);
    console.log(`Respuesta de SIGED para evento ID ${evento.id}: Estado ${respuesta.status}`);
    return { exito: true, data: respuesta.data };
  } catch (error) {
    console.error(`Error al notificar a SIGED para evento ID ${evento.id}:`, error.message);
    return { exito: false, error: error.message };
  }
};

const actualizarEstadoNotificacion = async (eventoId, tipoEvento) => {
  console.log(`Actualizando estado del evento ID ${eventoId} (${tipoEvento}) a 'notificado' en la BD...`);
  let client;
  let query;

  if (tipoEvento === 'INSCRIPCION') {
    query = 'UPDATE muses_dev.tbmu006_inscripcion SET notificado_siged = true WHERE id_inscripcion = $1;';
  } else if (tipoEvento === 'BAJA') {
    query = 'UPDATE muses_dev.tbmu013_bajas SET notificado_siged = true WHERE id_baja = $1;';
  } else {
    console.error('Tipo de evento no reconocido para actualización:', tipoEvento);
    return;
  }

  try {
    client = await pool.connect();
    await client.query(query, [eventoId]);
    console.log(`Evento ID ${eventoId} (${tipoEvento}) actualizado correctamente.`);
  } catch (error) {
    console.error(`Error al actualizar el estado para el evento ID ${eventoId} (${tipoEvento}):`, error.message);
  } finally {
    if (client) {
      client.release();
    }
  }
};

const procesarNotificaciones = async () => {
  try {
    const eventos = await obtenerDatosConsolidados();
    if (eventos.length === 0) {
      console.log("No hay eventos pendientes de notificar a SIGED.");
      return;
    }

    console.log(`Se encontraron ${eventos.length} eventos para notificar.`);

    for (const evento of eventos) {
      const resultado = await notificarSIGED(evento);
      if (resultado.exito) {
        await actualizarEstadoNotificacion(evento.id, evento.tipo_evento);
      }
    }

    console.log("Proceso de notificación a SIGED completado.");
  } catch (error) {
    console.error("Error en el proceso de notificación a SIGED:", error);
  }
};

module.exports = {
  procesarNotificaciones
};
