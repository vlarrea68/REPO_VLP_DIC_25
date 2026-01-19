import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

export interface InscripcionMasivaRegistro {
  folioControl: string;
  flujo: string;
  cicloEscolar: string;
  curp: string;
  primerApellido: string;
  segundoApellido?: string;
  nombre: string;
  fechaNacimiento: string;
  grado: string;
  grupo: string;
  correoElectronico?: string;
}

export interface RegistroCargaMasivaError {
  linea: number;
  errores: string[];
  contenido?: string;
}

export interface ResumenCargaMasiva {
  totalRegistros: number;
  registrosValidos: InscripcionMasivaRegistro[];
  errores: RegistroCargaMasivaError[];
}

export type EstadoCargaMasiva = 'pendiente' | 'procesando' | 'completado' | 'error' | 'cancelado';

export interface EventoCargaMasiva {
  estado: EstadoCargaMasiva;
  porcentajeAvance: number;
  registrosProcesados: number;
  totalRegistros: number;
  resumen?: ResumenCargaMasiva;
  mensajeError?: string;
  nuevosRegistros?: InscripcionMasivaRegistro[];
  mensajeProgreso?: string;
  loteActual?: number;
  totalLotes?: number;
}

@Injectable({
  providedIn: 'root',
})
export class CargaMasivaService {
  private readonly encabezadosEsperados: readonly string[] = [
    'folio_control',
    'flujo',
    'ciclo_escolar',
    'curp',
    'primer_apellido',
    'segundo_apellido',
    'nombre',
    'fecha_nacimiento',
    'grado',
    'grupo',
    'correo_electronico',
  ];

  private readonly maximoRegistros = 5000;
  private readonly tamanoLote = 200;
  private registroSeleccionado: InscripcionMasivaRegistro | null = null;

  obtenerEncabezadosEsperados(): readonly string[] {
    return this.encabezadosEsperados;
  }

  establecerRegistroSeleccionado(registro: InscripcionMasivaRegistro | null): void {
    this.registroSeleccionado = registro;
  }

  obtenerRegistroSeleccionado(): InscripcionMasivaRegistro | null {
    return this.registroSeleccionado;
  }

  procesarArchivo(file: File): Observable<EventoCargaMasiva> {
    return new Observable<EventoCargaMasiva>((subscriber) => {
      let cancelado = false;

      const notificar = (evento: EventoCargaMasiva): void => {
        if (cancelado || subscriber.closed) {
          return;
        }
        subscriber.next(evento);
      };

      notificar({
        estado: 'procesando',
        porcentajeAvance: 0,
        registrosProcesados: 0,
        totalRegistros: 0,
        mensajeProgreso: 'Preparando archivo…',
      });

      this.leerArchivoComoTexto(file).then((texto) => {
          if (cancelado || subscriber.closed) {
            return;
          }
          try {
            notificar({
              estado: 'procesando',
              porcentajeAvance: 0,
              registrosProcesados: 0,
              totalRegistros: 0,
              mensajeProgreso: 'Validando encabezados…',
            });

            const lineas = this.obtenerLineas(texto);
            if (lineas.length <= 1) {
              notificar({
                estado: 'error',
                porcentajeAvance: 0,
                registrosProcesados: 0,
                totalRegistros: 0,
                mensajeError:
                  'El archivo no contiene registros válidos. Verifica que incluyas el encabezado y al menos una fila.',
                mensajeProgreso: 'No se encontraron registros en el archivo.',
              });
              subscriber.complete();
              return;
            }

            const encabezados = this.parsearLinea(lineas[0]);
            const erroresEncabezado = this.validarEncabezados(encabezados);
            if (erroresEncabezado.length) {
              notificar({
                estado: 'error',
                porcentajeAvance: 0,
                registrosProcesados: 0,
                totalRegistros: 0,
                mensajeError: erroresEncabezado.join(' '),
                mensajeProgreso: 'Encabezados inválidos.',
              });
              subscriber.complete();
              return;
            }

            const totalRegistros = lineas.length - 1;
            if (totalRegistros > this.maximoRegistros) {
              notificar({
                estado: 'error',
                porcentajeAvance: 0,
                registrosProcesados: 0,
                totalRegistros,
                mensajeError: `El archivo supera el máximo permitido de ${this.maximoRegistros} registros.`,
                mensajeProgreso: 'El archivo excede el límite permitido.',
              });
              subscriber.complete();
              return;
            }

            const registrosValidos: InscripcionMasivaRegistro[] = [];
            let procesados = 0;
            const totalLotes = totalRegistros
              ? Math.ceil(totalRegistros / this.tamanoLote)
              : 0;

            notificar({
              estado: 'procesando',
              porcentajeAvance: 0,
              registrosProcesados: 0,
              totalRegistros,
              mensajeProgreso: totalRegistros
                ? `Procesando ${totalRegistros} registro${totalRegistros === 1 ? '' : 's'}…`
                : 'Procesando registros…',
            });

            const procesarLote = (indiceInicio: number): void => {
              if (cancelado || subscriber.closed) {
                return;
              }

              const indiceFin = Math.min(indiceInicio + this.tamanoLote, totalRegistros);
              const nuevosRegistros: InscripcionMasivaRegistro[] = [];
              for (let i = indiceInicio; i < indiceFin; i += 1) {
                const cruda = lineas[i + 1];
                const columnas = this.parsearLinea(cruda);
                const registro = this.crearRegistro(encabezados, columnas);
                registrosValidos.push(registro);
                nuevosRegistros.push(registro);

                procesados += 1;
              }

              const porcentaje = totalRegistros
                ? Math.min(100, Math.round((procesados / totalRegistros) * 100))
                : 100;
              const loteActual = totalRegistros ? Math.ceil(procesados / this.tamanoLote) : 0;

              notificar({
                estado: procesados >= totalRegistros ? 'completado' : 'procesando',
                porcentajeAvance: porcentaje,
                registrosProcesados: procesados,
                totalRegistros,
                nuevosRegistros,
                loteActual: procesados ? loteActual : undefined,
                totalLotes: totalLotes || undefined,
                mensajeProgreso:
                  procesados >= totalRegistros
                    ? 'Procesamiento completado.'
                    : totalLotes
                      ? `Enviando lote ${loteActual} de ${totalLotes}…`
                      : 'Procesando registros…',
                resumen:
                  procesados >= totalRegistros
                    ? {
                        totalRegistros,
                        registrosValidos,
                        errores: [],
                      }
                    : undefined,
              });

              if (procesados >= totalRegistros) {
                subscriber.complete();
                return;
              }

              setTimeout(() => procesarLote(indiceFin), 0);
            };

            procesarLote(0);
          } catch (error) {
            notificar({
              estado: 'error',
              porcentajeAvance: 0,
              registrosProcesados: 0,
              totalRegistros: 0,
              mensajeError:
                error instanceof Error
                  ? error.message
                  : 'No fue posible procesar el archivo. Intenta nuevamente.',
              mensajeProgreso: 'Ocurrió un error al procesar el archivo.',
            });
            subscriber.complete();
          }
        })
        .catch(() => {
          notificar({
            estado: 'error',
            porcentajeAvance: 0,
            registrosProcesados: 0,
            totalRegistros: 0,
            mensajeError: 'No fue posible leer el archivo. Verifica que sea un CSV válido.',
            mensajeProgreso: 'No fue posible leer el archivo.',
          });
          subscriber.complete();
        });

      return () => {
        cancelado = true;
      };
    });
  }

  generarPlantillaEjemplo(): string {
    const encabezado = this.encabezadosEsperados.join(',');
    const ejemplo = [
      'FOLIO-0001,I,2024-2025,CURP010203HDFRRL01,García,Pérez,María Fernanda,2006-08-17,5,A,maria.fernanda@example.edu.mx',
      'FOLIO-0002,R,2024-2025,CURP040506MDFRRL02,López,,Juan,2005-01-05,6,B,',
    ];
    return [encabezado, ...ejemplo].join('\n');
  }

  generarCsvErrores(errores: RegistroCargaMasivaError[]): string {
    const encabezado = 'linea,mensajes,contenido_original';
    const filas = errores.map((error) => {
      const mensajes = error.errores.map((mensaje) => mensaje.replace(/"/g, '""')).join(' | ');
      const contenido = (error.contenido ?? '').replace(/"/g, '""');
      return `"${error.linea}","${mensajes}","${contenido}"`;
    });
    return [encabezado, ...filas].join('\n');
  }

  private obtenerLineas(texto: string): string[] {
    return texto
      .split(/\r?\n/)
      .map((linea) => linea.replace(/\uFEFF/g, ''))
      .filter((linea, indice, arreglo) => indice === arreglo.length - 1 || linea.trim().length > 0);
  }

  private parsearLinea(linea: string): string[] {
    const resultado: string[] = [];
    let acumulado = '';
    let dentroDeComillas = false;

    for (let i = 0; i < linea.length; i += 1) {
      const caracter = linea[i];

      if (caracter === '"') {
        if (dentroDeComillas && linea[i + 1] === '"') {
          acumulado += '"';
          i += 1;
        } else {
          dentroDeComillas = !dentroDeComillas;
        }
      } else if (caracter === ',' && !dentroDeComillas) {
        resultado.push(acumulado.trim());
        acumulado = '';
      } else {
        acumulado += caracter;
      }
    }

    resultado.push(acumulado.trim());
    return resultado;
  }

  private validarEncabezados(encabezados: string[]): string[] {
    const encabezadosNormalizados = encabezados.map((encabezado) => encabezado.trim().toLowerCase());
    const faltantes = this.encabezadosEsperados.filter(
      (esperado) => !encabezadosNormalizados.includes(esperado)
    );

    if (faltantes.length) {
      return [
        `El archivo debe contener los encabezados: ${this.encabezadosEsperados.join(', ')}.`,
        `Faltan los campos: ${faltantes.join(', ')}.`,
      ];
    }

    return [];
  }

  private crearRegistro(encabezados: string[], columnas: string[]): InscripcionMasivaRegistro {
    const mapa: Record<string, string> = {};
    encabezados.forEach((encabezado, indice) => {
      mapa[encabezado.trim().toLowerCase()] = columnas[indice]?.trim() ?? '';
    });

    return {
      folioControl: mapa['folio_control'] ?? '',
      flujo: mapa['flujo'] ?? '',
      cicloEscolar: mapa['ciclo_escolar'] ?? '',
      curp: mapa['curp'] ?? '',
      primerApellido: mapa['primer_apellido'] ?? '',
      segundoApellido: mapa['segundo_apellido'] ?? '',
      nombre: mapa['nombre'] ?? '',
      fechaNacimiento: mapa['fecha_nacimiento'] ?? '',
      grado: mapa['grado'] ?? '',
      grupo: mapa['grupo'] ?? '',
      correoElectronico: mapa['correo_electronico'] ?? '',
    };
  }

  private leerArchivoComoTexto(file: File): Promise<string> {
    return file.arrayBuffer().then((buffer) => this.decodificarContenido(buffer));
  }

  private decodificarContenido(buffer: ArrayBuffer): string {
    const codificaciones: readonly { etiqueta: string; fatal: boolean }[] = [
      { etiqueta: 'utf-8', fatal: true },
      { etiqueta: 'iso-8859-1', fatal: false },
      { etiqueta: 'windows-1252', fatal: false },
    ];

    const caracterReemplazo = String.fromCharCode(0xfffd);

    for (const codificacion of codificaciones) {
      try {
        const decoder = new TextDecoder(codificacion.etiqueta, {
          fatal: codificacion.fatal,
        });
        const texto = decoder.decode(buffer);

        if (!texto.includes(caracterReemplazo)) {
          return texto;
        }
      } catch (error) {
        continue;
      }
    }

    return new TextDecoder().decode(buffer);
  }
}
