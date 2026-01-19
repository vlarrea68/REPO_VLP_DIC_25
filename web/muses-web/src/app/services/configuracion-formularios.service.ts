import { Injectable } from '@angular/core';
import { Observable, delay, of } from 'rxjs';
import {
  CampoFormularioConfiguracion,
  InstitucionFormularioConfiguracion,
  InstitucionFormularioResumen,
} from './configuracion-formularios.model';
import { ConfiguracionFormulariosStore } from './configuracion-formularios.store';

@Injectable({ providedIn: 'root' })
export class ConfiguracionFormulariosService {
  private readonly simulatedLatency = 250;

  constructor(private readonly store: ConfiguracionFormulariosStore) {}

  getInstituciones(): Observable<InstitucionFormularioResumen[]> {
    const resumen = this.store.getSnapshot().map(({ clave, nombre, descripcion }) => ({
      clave,
      nombre,
      descripcion,
    }));

    return of(resumen).pipe(delay(this.simulatedLatency));
  }

  getConfiguracionPorClaveInstitucion(
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
}

export type {
  CampoFormularioConfiguracion,
  InstitucionFormularioConfiguracion,
  InstitucionFormularioResumen,
} from './configuracion-formularios.model';
