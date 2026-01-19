import { CommonModule } from '@angular/common';
import { Component, DestroyRef, OnInit, inject } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
} from '@angular/forms';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { GestionConfiguracionFormulariosService } from '../../services/gestion-configuracion-formularios.service';
import {
  CampoFormularioConfiguracion,
  InstitucionFormularioConfiguracion,
  InstitucionFormularioResumen,
} from '../../services/configuracion-formularios.service';

interface CampoAdministrable {
  readonly clave: string;
  readonly etiqueta: string;
  readonly requeridoBase: boolean;
  readonly descripcion?: string;
}

interface CampoFormularioValor {
  visible: boolean;
  obligatorio: boolean;
  etiqueta: string;
}

const CAMPOS_ADMINISTRABLES: readonly CampoAdministrable[] = [
  { clave: 'sexo', etiqueta: 'Sexo', requeridoBase: true },
  { clave: 'genero', etiqueta: 'Género', requeridoBase: true },
  { clave: 'lenguaMaterna', etiqueta: 'Lengua materna', requeridoBase: true },
  {
    clave: 'segundaLengua',
    etiqueta: 'Segunda lengua',
    requeridoBase: false,
    descripcion: 'Código de lengua adicional según catálogo ISO 639-2.',
  },
  {
    clave: 'numeroTelefonico',
    etiqueta: 'Número telefónico',
    requeridoBase: false,
    descripcion: 'Captura a 10 dígitos sin espacios ni guiones.',
  },
  {
    clave: 'necesidadEducativa',
    etiqueta: 'Necesidad educativa',
    requeridoBase: true,
  },
  {
    clave: 'tipoDiscapacidad',
    etiqueta: 'Tipo de discapacidad',
    requeridoBase: true,
  },
  {
    clave: 'aptitudSobresaliente',
    etiqueta: 'Aptitud sobresaliente',
    requeridoBase: true,
  },
  {
    clave: 'numeroMatricula',
    etiqueta: 'Número de matrícula',
    requeridoBase: true,
  },
];

@Component({
  selector: 'app-configuracion-instituciones',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './configuracion-instituciones.component.html',
  styleUrl: './configuracion-instituciones.component.scss',
})
export class ConfiguracionInstitucionesComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly gestionService = inject(GestionConfiguracionFormulariosService);
  private readonly destroyRef = inject(DestroyRef);

  instituciones: InstitucionFormularioResumen[] = [];
  institucionesCargando = false;
  configuracionCargando = false;
  guardando = false;
  mensajeGuardado = '';
  mensajeError = '';

  seleccionActual: string | null = null;
  configuracionActual: InstitucionFormularioConfiguracion | null = null;

  readonly camposGroup: FormGroup = this.fb.group({});
  readonly configuracionForm = this.fb.group({
    descripcion: [''],
    campos: this.camposGroup,
  });

  constructor() {
    CAMPOS_ADMINISTRABLES.forEach((campo) => {
      this.camposGroup.addControl(
        campo.clave,
        this.fb.group({
          visible: [true],
          obligatorio: [campo.requeridoBase],
          etiqueta: [''],
        })
      );
    });
  }

  ngOnInit(): void {
    this.cargarInstituciones();
  }

  get camposAdministrables(): readonly CampoAdministrable[] {
    return CAMPOS_ADMINISTRABLES;
  }

  getCampoFormGroup(clave: string): FormGroup {
    return this.camposGroup.get(clave) as FormGroup;
  }

  seleccionarInstitucion(clave: string): void {
    if (!clave || clave === this.seleccionActual) {
      return;
    }

    this.mensajeGuardado = '';
    this.mensajeError = '';
    this.seleccionActual = clave;
    this.configuracionCargando = true;

    this.gestionService
      .obtenerConfiguracionCompleta(clave)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (configuracion) => {
          this.configuracionCargando = false;
          this.configuracionActual = configuracion;
          this.aplicarConfiguracion(configuracion);
        },
        error: () => {
          this.configuracionCargando = false;
          this.mensajeError =
            'Ocurrió un problema al obtener la configuración. Intente nuevamente.';
        },
      });
  }

  guardarCambios(): void {
    if (!this.seleccionActual) {
      return;
    }

    this.guardando = true;
    this.mensajeGuardado = '';
    this.mensajeError = '';

    const camposActualizados = this.calcularOverrides();
    const descripcion = this.configuracionForm.get('descripcion')?.value ?? '';

    this.gestionService
      .guardarConfiguracion({
        clave: this.seleccionActual,
        descripcion: descripcion.trim() || null,
        campos: camposActualizados,
      })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (configuracion) => {
          this.guardando = false;
          this.configuracionActual = configuracion;
          this.mensajeGuardado = 'Los cambios se guardaron correctamente.';
        },
        error: () => {
          this.guardando = false;
          this.mensajeError =
            'No se pudieron guardar los cambios. Verifique la información e intente de nuevo.';
        },
      });
  }

  restablecerCambios(): void {
    this.aplicarConfiguracion(this.configuracionActual);
    this.mensajeGuardado = '';
    this.mensajeError = '';
  }

  private cargarInstituciones(): void {
    this.institucionesCargando = true;

    this.gestionService
      .listarInstituciones()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (instituciones) => {
          this.institucionesCargando = false;
          this.instituciones = instituciones;

          if (!this.seleccionActual && instituciones.length > 0) {
            this.seleccionarInstitucion(instituciones[0].clave);
          }
        },
        error: () => {
          this.institucionesCargando = false;
          this.mensajeError =
            'No fue posible obtener la lista de instituciones. Recargue la página para reintentar.';
        },
      });
  }

  private aplicarConfiguracion(
    configuracion: InstitucionFormularioConfiguracion | null
  ): void {
    const descripcionControl = this.configuracionForm.get('descripcion');
    descripcionControl?.setValue(configuracion?.descripcion ?? '', {
      emitEvent: false,
    });

    CAMPOS_ADMINISTRABLES.forEach((campo) => {
      const grupo = this.getCampoFormGroup(campo.clave);
      const overrides = configuracion?.campos?.[campo.clave];
      const visible = overrides?.visible ?? true;
      const obligatorio =
        overrides?.obligatorio ?? campo.requeridoBase;
      const etiqueta = overrides?.etiqueta ?? '';

      grupo.setValue(
        {
          visible,
          obligatorio,
          etiqueta,
        },
        { emitEvent: false }
      );
    });
  }

  private calcularOverrides(): Record<string, CampoFormularioConfiguracion> {
    const base = { ...(this.configuracionActual?.campos ?? {}) };

    CAMPOS_ADMINISTRABLES.forEach((campo) => {
      const grupo = this.getCampoFormGroup(campo.clave);
      const valor = grupo.value as CampoFormularioValor;
      const etiquetaLimpia = valor.etiqueta.trim();

      const diff: CampoFormularioConfiguracion = {
        ...(valor.visible !== true ? { visible: valor.visible } : {}),
        ...(valor.obligatorio !== campo.requeridoBase
          ? { obligatorio: valor.obligatorio }
          : {}),
        ...(etiquetaLimpia ? { etiqueta: etiquetaLimpia } : {}),
      };

      if (Object.keys(diff).length > 0) {
        base[campo.clave] = diff;
      } else {
        delete base[campo.clave];
      }
    });

    return base;
  }
}
