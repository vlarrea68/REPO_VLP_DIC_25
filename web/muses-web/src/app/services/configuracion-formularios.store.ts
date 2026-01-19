import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  CampoFormularioConfiguracion,
  InstitucionFormularioConfiguracion,
} from './configuracion-formularios.model';

interface StoredInstitucionConfiguracion
  extends InstitucionFormularioConfiguracion {}

const INITIAL_INSTITUCIONES: readonly StoredInstitucionConfiguracion[] = [
  {
    clave: 'SEP-GENERAL',
    nombre: 'Plantilla nacional de educación superior',
    descripcion:
      'Usa la plantilla general publicada por la SEP sin ajustes adicionales.',
    campos: {},
  },
  {
    clave: 'ITLO-2025',
    nombre: 'Instituto Tecnológico del Occidente',
    descripcion:
      'Mantiene la plantilla nacional pero permite capturar una segunda lengua opcional.',
    campos: {
      segundaLengua: { obligatorio: false },
      numeroTelefonico: { obligatorio: true },
    },
  },
  {
    clave: 'UNIM-301',
    nombre: 'Universidad Metropolitana de Innovación',
    descripcion:
      'Solicita solo el campo de sexo y oculta el campo de género por políticas internas.',
    campos: {
      genero: { visible: false },
      sexo: { obligatorio: true },
    },
  },
  {
    clave: 'INPI-040',
    nombre: 'Instituto Nacional de Pueblos Indígenas',
    descripcion:
      'Requiere detallar lengua indígena y hace opcional el dato de aptitud sobresaliente.',
    campos: {
      lenguaMaterna: { obligatorio: true },
      segundaLengua: {
        obligatorio: true,
        etiqueta: 'Lengua indígena adicional',
      },
      aptitudSobresaliente: { obligatorio: false },
      tipoDiscapacidad: { obligatorio: false },
    },
  },
];

@Injectable({ providedIn: 'root' })
export class ConfiguracionFormulariosStore {
  private readonly institucionesSubject = new BehaviorSubject<
    readonly StoredInstitucionConfiguracion[]
  >(INITIAL_INSTITUCIONES);

  readonly instituciones$ = this.institucionesSubject.asObservable();

  getSnapshot(): readonly StoredInstitucionConfiguracion[] {
    return this.institucionesSubject.value;
  }

  getConfiguracion(clave: string): StoredInstitucionConfiguracion | null {
    return this.getSnapshot().find((inst) => inst.clave === clave) ?? null;
  }

  actualizarConfiguracion(
    clave: string,
    cambios: {
      campos?: Record<string, CampoFormularioConfiguracion>;
      descripcion?: string | null;
      nombre?: string;
    }
  ): void {
    const instituciones = this.getSnapshot();
    const index = instituciones.findIndex((inst) => inst.clave === clave);

    if (index === -1) {
      return;
    }

    const actual = instituciones[index];
    const camposActualizados = cambios.campos
      ? { ...cambios.campos }
      : { ...actual.campos };

    const actualizado: StoredInstitucionConfiguracion = {
      ...actual,
      ...(typeof cambios.descripcion !== 'undefined'
        ? { descripcion: cambios.descripcion ?? undefined }
        : {}),
      ...(cambios.nombre ? { nombre: cambios.nombre } : {}),
      campos: camposActualizados,
    };

    const copia = instituciones.slice();
    copia[index] = actualizado;

    this.institucionesSubject.next(copia);
  }
}
