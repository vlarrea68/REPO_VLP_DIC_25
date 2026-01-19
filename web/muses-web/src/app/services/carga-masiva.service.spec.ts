import {
  TestBed,
  fakeAsync,
  flush,
  flushMicrotasks,
} from '@angular/core/testing';
import {
  CargaMasivaService,
  EventoCargaMasiva,
  RegistroCargaMasivaError,
} from './carga-masiva.service';

function crearArchivoCsv(contenido: string, nombre = 'registros.csv'): File {
  return new File([contenido], nombre, { type: 'text/csv' });
}

describe('CargaMasivaService', () => {
  let service: CargaMasivaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CargaMasivaService);
  });

  it('debería procesar un archivo CSV válido', fakeAsync(() => {
    const encabezado =
      'folio_control,flujo,ciclo_escolar,curp,primer_apellido,segundo_apellido,nombre,fecha_nacimiento,grado,grupo,correo_electronico';
    const registros = [
      'FOLIO-0001,I,2024-2025,CURP010203HDFRRL01,García,Pérez,María,2006-08-17,5,A,maria@example.edu.mx',
      'FOLIO-0002,R,2024-2025,CURP010203HDFRRL02,López,,Juan,2005-01-05,6,B,',
    ];
    const archivo = crearArchivoCsv([encabezado, ...registros].join('\n'));
    const emisiones: EventoCargaMasiva[] = [];

    service
      .procesarArchivo(archivo)
      .subscribe((evento) => emisiones.push(evento));

    flushMicrotasks();
    flush();

    const final = emisiones.at(-1);
    expect(final?.estado).toBe('completado');
    expect(final?.resumen?.totalRegistros).toBe(2);
    expect(final?.resumen?.errores.length).toBe(0);
    expect(final?.resumen?.registrosValidos.length).toBe(2);
    const registrosEmitidos = emisiones
      .filter((evento) => evento.nuevosRegistros?.length)
      .flatMap((evento) => evento.nuevosRegistros ?? []);
    expect(registrosEmitidos.length).toBe(2);
    expect(emisiones.some((evento) => evento.porcentajeAvance > 0)).toBeTrue();
  }));

  it('debería reportar error cuando faltan encabezados obligatorios', fakeAsync(() => {
    const archivo = crearArchivoCsv(
      'folio_control,curp\nFOLIO-0001,CURP010203HDFRRL01',
    );
    const emisiones: EventoCargaMasiva[] = [];

    service
      .procesarArchivo(archivo)
      .subscribe((evento) => emisiones.push(evento));

    flushMicrotasks();
    flush();

    const final = emisiones.at(-1);
    expect(final?.estado).toBe('error');
    expect(final?.mensajeError).toContain('encabezados');
    expect(final?.mensajeError).toContain('Faltan los campos');
  }));

  it('debería limitar el tamaño máximo de registros permitidos', fakeAsync(() => {
    const encabezado =
      'folio_control,flujo,ciclo_escolar,curp,primer_apellido,segundo_apellido,nombre,fecha_nacimiento,grado,grupo,correo_electronico';
    const registros = Array.from(
      { length: 5001 },
      (_, indice) =>
        `FOLIO-${indice.toString().padStart(5, '0')},I,2024-2025,CURP010203HDFRRL${(
          indice % 90
        )
          .toString()
          .padStart(
            2,
            '0',
          )},Apellido,Segundo,Nombre,2006-01-01,5,A,capturista${indice}@example.edu.mx`,
    );
    const archivo = crearArchivoCsv([encabezado, ...registros].join('\n'));
    const emisiones: EventoCargaMasiva[] = [];

    service
      .procesarArchivo(archivo)
      .subscribe((evento) => emisiones.push(evento));

    flushMicrotasks();
    flush();

    const final = emisiones.at(-1);
    expect(final?.estado).toBe('error');
    expect(final?.mensajeError).toContain('máximo permitido');
    expect(final?.totalRegistros).toBeGreaterThan(5000);
  }));

  it('debería procesar los registros en lotes de 200 elementos', fakeAsync(() => {
    const encabezado =
      'folio_control,flujo,ciclo_escolar,curp,primer_apellido,segundo_apellido,nombre,fecha_nacimiento,grado,grupo,correo_electronico';
    const registros = Array.from({ length: 450 }, (_, indice) => {
      const consecutivo = indice.toString().padStart(5, '0');
      return `FOLIO-${consecutivo},I,2024-2025,CURP${consecutivo},Apellido,Segundo,Nombre ${indice},2006-01-01,5,A,correo${indice}@example.edu.mx`;
    });
    const archivo = crearArchivoCsv([encabezado, ...registros].join('\n'));
    const emisiones: EventoCargaMasiva[] = [];

    service
      .procesarArchivo(archivo)
      .subscribe((evento) => emisiones.push(evento));

    flushMicrotasks();
    flush();

    const lotes = emisiones
      .filter((evento) => evento.nuevosRegistros?.length)
      .map((evento) => ({
        cantidad: evento.nuevosRegistros?.length ?? 0,
        loteActual: evento.loteActual,
      }));

    expect(lotes.map((lote) => lote.cantidad)).toEqual([200, 200, 50]);
    expect(lotes.map((lote) => lote.loteActual)).toEqual([1, 2, 3]);

    const final = emisiones.at(-1);
    expect(final?.estado).toBe('completado');
    expect(final?.totalLotes).toBe(3);
    expect(final?.resumen?.totalRegistros).toBe(450);
  }));

  it('debería generar la plantilla de ejemplo con encabezados obligatorios', () => {
    const plantilla = service.generarPlantillaEjemplo();
    expect(plantilla.split('\n')[0]).toContain('folio_control');
    expect(plantilla.split('\n').length).toBeGreaterThan(1);
  });

  it('debería generar un CSV con el detalle de errores', () => {
    const errores: RegistroCargaMasivaError[] = [
      {
        linea: 2,
        errores: ['La CURP es obligatoria.'],
        contenido: 'FOLIO-0002,R,,,,,',
      },
      {
        linea: 5,
        errores: ['El flujo es obligatorio.'],
        contenido: 'FOLIO-0005,,2024-2025,CURP010203HDFRRL03',
      },
    ];

    const csv = service.generarCsvErrores(errores);
    expect(csv).toContain('linea,mensajes,contenido_original');
    expect(csv.split('\n').length).toBe(errores.length + 1);
  });

  it('debería exponer los encabezados esperados', () => {
    expect(service.obtenerEncabezadosEsperados().length).toBeGreaterThan(0);
    expect(service.obtenerEncabezadosEsperados()).toContain('folio_control');
  });

  it('debería almacenar y recuperar el registro seleccionado para el detalle', () => {
    const registro = {
      folioControl: 'FOLIO-0009',
      flujo: 'I',
      cicloEscolar: '2024-2025',
      curp: 'CURP010203HDFRRL09',
      primerApellido: 'Santos',
      segundoApellido: 'García',
      nombre: 'Lucía',
      fechaNacimiento: '2007-02-11',
      grado: '6',
      grupo: 'A',
      correoElectronico: 'lucia@example.edu.mx',
    };

    service.establecerRegistroSeleccionado(registro);
    expect(service.obtenerRegistroSeleccionado()).toEqual(registro);

    service.establecerRegistroSeleccionado(null);
    expect(service.obtenerRegistroSeleccionado()).toBeNull();
  });
});
