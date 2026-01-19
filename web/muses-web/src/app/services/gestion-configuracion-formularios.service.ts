import { Injectable } from '@angular/core';
import { Observable, delay, of } from 'rxjs';
import {
  CampoFormularioConfiguracion,
  InstitucionFormularioConfiguracion,
  InstitucionFormularioResumen,
} from './configuracion-formularios.model';
import { ConfiguracionFormulariosStore } from './configuracion-formularios.store';

export interface GuardarConfiguracionPayload {
  readonly clave: string;
  readonly descripcion?: string | null;
  readonly campos: Record<string, CampoFormularioConfiguracion>;
}

@Injectable({ providedIn: 'root' })
export class GestionConfiguracionFormulariosService {
  private readonly simulatedLatency = 350;

  constructor(private readonly store: ConfiguracionFormulariosStore) {}

  listarInstituciones(): Observable<InstitucionFormularioResumen[]> {
    const instituciones = this.store.getSnapshot().map(({ clave, nombre, descripcion }) => ({
      clave,
      nombre,
      descripcion,
    }));

    return of(instituciones).pipe(delay(this.simulatedLatency));
  }

  obtenerConfiguracionCompleta(
    clave: string
  ): Observable<InstitucionFormularioConfiguracion | null> {
    const configuracion = this.store.getConfiguracion(clave);

    if (!configuracion) {
      return of(null).pipe(delay(this.simulatedLatency));
    }

    const copia: InstitucionFormularioConfiguracion = {
      ...configuracion,
      campos: { ...configuracion.campos },
    };

    return of(copia).pipe(delay(this.simulatedLatency));
  }

  guardarConfiguracion(
    payload: GuardarConfiguracionPayload
  ): Observable<InstitucionFormularioConfiguracion> {
    const { clave, campos, descripcion } = payload;

    this.store.actualizarConfiguracion(clave, {
      campos,
      descripcion: descripcion ?? null,
    });

    const configuracionActualizada = this.store.getConfiguracion(clave);

    if (!configuracionActualizada) {
      throw new Error('No se pudo actualizar la configuración solicitada.');
    }

    const copia: InstitucionFormularioConfiguracion = {
      ...configuracionActualizada,
      campos: { ...configuracionActualizada.campos },
    };

    return of(copia).pipe(delay(this.simulatedLatency));
  }
}
