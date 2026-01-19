import { Injectable } from '@angular/core';
import { of } from 'rxjs';

/**
 * NOTA DE ARQUITECTURA:
 * Este servicio es un stub temporal. En la implementación final, la mayoría de
 * estos catálogos (ej. Motivos de Baja, Entidades Federativas) deberán ser
 * consumidos desde una API central para asegurar la consistencia.
 *
 * La gestión local (CRUD a través de la UI) se limitará estrictamente a los
 * cuatro catálogos definidos: 'Genero', 'Materias', 'Programas' y 'Planes de estudio'.
 */

@Injectable({
  providedIn: 'root'
})
export class CatalogosService {

  constructor() { }

  // Ejemplo de cómo se podría obtener un catálogo desde el backend.
  // El resto de los métodos deberían seguir este patrón.
  getMotivosBaja() {
    // En una implementación real, esto sería una llamada HTTP:
    // return this.http.get('/api/catalogos/motivos-baja');

    // Datos de ejemplo temporales:
    const motivosBaja = [
      { clave: '1', causa: 'Baja por situación académica' },
      { clave: '2', causa: 'Baja por situación administrativa' },
    ];
    return of(motivosBaja);
  }

  // Ejemplo para un catálogo de gestión local
  getGeneros() {
    // Este método podría obtener los datos de una API o de una fuente local,
    // y estaría asociado a una funcionalidad de gestión en el 'CatalogosModule'.
    const generos = [
      { clave: 'H', descripcion: 'Hombre' },
      { clave: 'M', descripcion: 'Mujer' },
      { clave: 'X', descripcion: 'No binario' },
    ];
    return of(generos);
  }
}
