import { CommonModule } from '@angular/common';
import {
  ChangeDetectionStrategy,
  Component,
  computed,
  inject,
  signal,
} from '@angular/core';
import { Router } from '@angular/router';
import {
  CargaMasivaService,
  InscripcionMasivaRegistro,
} from '../../services/carga-masiva.service';

interface CampoDetalle {
  etiqueta: string;
  valor: string;
}

@Component({
  selector: 'app-carga-masiva-detalle',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './carga-masiva-detalle.component.html',
  styleUrl: './carga-masiva-detalle.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CargaMasivaDetalleComponent {
  private readonly router = inject(Router);
  private readonly cargaMasivaService = inject(CargaMasivaService);
  private readonly registroActual = signal<InscripcionMasivaRegistro | null>(null);

  constructor() {
    const navigation = this.router.getCurrentNavigation();
    const registroDesdeEstado = navigation?.extras.state?.['registro'] as
      | InscripcionMasivaRegistro
      | undefined;
    const registro =
      registroDesdeEstado ?? this.cargaMasivaService.obtenerRegistroSeleccionado();

    if (registro) {
      this.cargaMasivaService.establecerRegistroSeleccionado(registro);
      this.registroActual.set(registro);
    }
  }

  readonly registro = computed(() => this.registroActual());

  readonly campos = computed<CampoDetalle[]>(() => {
    const registro = this.registro();
    if (!registro) {
      return [];
    }

    const withDefault = (valor?: string) => (valor && valor.trim().length ? valor : '—');

    return [
      { etiqueta: 'Folio control', valor: withDefault(registro.folioControl) },
      { etiqueta: 'Flujo', valor: withDefault(registro.flujo) },
      { etiqueta: 'Ciclo escolar', valor: withDefault(registro.cicloEscolar) },
      { etiqueta: 'CURP', valor: withDefault(registro.curp) },
      { etiqueta: 'Primer apellido', valor: withDefault(registro.primerApellido) },
      { etiqueta: 'Segundo apellido', valor: withDefault(registro.segundoApellido) },
      { etiqueta: 'Nombre', valor: withDefault(registro.nombre) },
      { etiqueta: 'Fecha de nacimiento', valor: withDefault(registro.fechaNacimiento) },
      { etiqueta: 'Grado', valor: withDefault(registro.grado) },
      { etiqueta: 'Grupo', valor: withDefault(registro.grupo) },
      {
        etiqueta: 'Correo electrónico',
        valor: withDefault(registro.correoElectronico),
      },
    ];
  });

  regresar(): void {
    this.cargaMasivaService.establecerRegistroSeleccionado(this.registro());
    void this.router.navigate(['carga-masiva']);
  }
}
