import { Component } from '@angular/core';
import { InscripcionComponent } from '../inscripcion/inscripcion.component';

@Component({
  selector: 'app-baja',
  standalone: true,
  imports: [InscripcionComponent],
  templateUrl: './baja.component.html',
  styleUrl: './baja.component.scss',
})
export class BajaComponent {}
