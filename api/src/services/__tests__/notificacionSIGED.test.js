// api/src/services/__tests__/notificacionSIGED.test.js

const mockClient = {
  // Simulación avanzada: devuelve diferentes valores según la consulta SQL.
  query: jest.fn().mockImplementation((queryText, values) => {
    if (queryText.includes('SELECT')) {
      return Promise.resolve({ rows: [
        { id: 201, tipo_evento: "INSCRIPCION_TEST", curp: "TESTCURP1", cct: "TESTCCT1" },
        { id: 202, tipo_evento: "BAJA_TEST", curp: "TESTCURP2", cct: "TESTCCT2" },
      ]});
    }
    if (queryText.includes('UPDATE')) {
      return Promise.resolve({});
    }
    return Promise.reject(new Error("Consulta no simulada"));
  }),
  release: jest.fn(),
};
const mockPool = {
  connect: jest.fn().mockResolvedValue(mockClient),
};

jest.mock('pg', () => {
  return { Pool: jest.fn(() => mockPool) };
});
jest.mock('axios');

const logSpy = jest.spyOn(console, 'log').mockImplementation(() => {});
const errorSpy = jest.spyOn(console, 'error').mockImplementation(() => {});

describe('Servicio de Notificación a SIGED con Mocks', () => {

  beforeEach(() => {
    jest.clearAllMocks();
    jest.resetModules();
  });

  test('debería actualizar el estado en la BD después de una notificación exitosa', async () => {
    const { procesarNotificaciones } = require('../notificacionSIGED');
    const { Pool } = require('pg');
    const axios = require('axios');
    axios.post.mockResolvedValue({ status: 201 });

    await procesarNotificaciones();

    expect(mockClient.query).toHaveBeenCalledTimes(3); // 1 SELECT + 2 UPDATE
    expect(mockClient.query).toHaveBeenCalledWith(
      expect.stringContaining('UPDATE'),
      [201]
    );
    expect(errorSpy).not.toHaveBeenCalled();
  });

  test('NO debería actualizar el estado en la BD si la notificación falla', async () => {
    const { procesarNotificaciones } = require('../notificacionSIGED');
    const { Pool } = require('pg');
    const axios = require('axios');
    axios.post.mockRejectedValue(new Error('Error de red'));

    await procesarNotificaciones();

    expect(mockClient.query).toHaveBeenCalledTimes(1); // Solo el SELECT
    expect(mockClient.query).not.toHaveBeenCalledWith(
      expect.stringContaining('UPDATE'),
      expect.any(Array)
    );
    expect(errorSpy).toHaveBeenCalledWith(
      expect.stringContaining('Error al notificar a SIGED para evento ID 201'),
      'Error de red'
    );
  });
});
