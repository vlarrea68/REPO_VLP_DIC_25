// api/src/index.js

const express = require('express');
const { procesarNotificaciones } = require('./services/notificacionSIGED');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Endpoint para iniciar manualmente el proceso de notificación a SIGED.
// En un escenario real, esto podría ser un proceso cronometrado (cron job)
// o activado por un evento en la base de datos.
app.post('/notificar', async (req, res) => {
  console.log("Se recibió una solicitud para iniciar el proceso de notificación a SIGED.");

  // Se ejecuta el proceso de forma asíncrona y se responde inmediatamente
  // para no bloquear la solicitud HTTP.
  procesarNotificaciones();

  res.status(202).json({
    mensaje: "El proceso de notificación a SIGED ha sido iniciado. Revisa los logs del servidor para ver el progreso."
  });
});

app.listen(PORT, () => {
  console.log(`Servidor de SEP-MUSES API escuchando en el puerto ${PORT}`);
});
