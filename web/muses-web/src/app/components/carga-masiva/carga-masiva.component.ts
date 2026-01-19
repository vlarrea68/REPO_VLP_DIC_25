import { CommonModule } from '@angular/common';
import {
  ChangeDetectionStrategy,
  Component,
  DestroyRef,
  ElementRef,
  OnInit,
  ViewChild,
  computed,
  inject,
  signal,
} from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import {
  CargaMasivaService,
  EventoCargaMasiva,
  InscripcionMasivaRegistro,
} from '../../services/carga-masiva.service';

interface ArchivoMetadata {
  size: number;
  lastModified: number;
  filasEstimadas: number | null;
  calculandoFilas: boolean;
}

@Component({
  selector: 'app-carga-masiva',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './carga-masiva.component.html',
  styleUrl: './carga-masiva.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CargaMasivaComponent implements OnInit {
  @ViewChild('fileInput', { static: false })
  fileInput?: ElementRef<HTMLInputElement>;

  private readonly fb = inject(FormBuilder);
  private readonly cargaMasivaService = inject(CargaMasivaService);
  private readonly destroyRef = inject(DestroyRef);
  private readonly router = inject(Router);

  private readonly tamanoPaginaPorDefecto = 25;
  readonly opcionesTamanoPagina = [10, 25, 50, 100];
  readonly urlDocumentacion = 'https://www.gob.mx/sep';

  readonly formulario = this.fb.group({
    archivo: this.fb.control<File | null>(null, Validators.required),
    reemplazarExistentes: this.fb.control(true),
  });

  readonly eventoActual = signal<EventoCargaMasiva | null>(null);
  private readonly mensajeError = signal<string | null>(null);
  private readonly archivoSeleccionado = signal<File | null>(null);
  private readonly registrosAcumulados = signal<InscripcionMasivaRegistro[]>(
    [],
  );
  private readonly archivoMetadataSignal = signal<ArchivoMetadata | null>(null);
  private readonly mensajeProgresoSignal = signal<string | null>(null);
  private readonly terminoBusquedaSignal = signal('');
  private readonly flujoSeleccionadoSignal = signal<string>('todos');
  private readonly tamanoPaginaSignal = signal<number>(
    this.tamanoPaginaPorDefecto,
  );
  private readonly paginaActualSignal = signal(1);
  private readonly ultimaActualizacionSignal = signal<Date | null>(null);
  private readonly mostrarModalRequisitosSignal = signal(false);
  private readonly storageKey = 'cargaMasivaRegistros';
  private lecturaArchivoId = 0;
  private procesamientoSub: Subscription | null = null;

  readonly porcentajeAvance = computed(
    () => this.eventoActual()?.porcentajeAvance ?? 0,
  );
  readonly estado = computed(() => this.eventoActual()?.estado ?? 'pendiente');
  readonly estaProcesando = computed(
    () =>
      this.estado() === 'procesando' &&
      (this.eventoActual()?.registrosProcesados ?? 0) >= 0,
  );
  readonly estaCancelado = computed(() => this.estado() === 'cancelado');
  readonly registrosProcesados = computed(
    () => this.eventoActual()?.registrosProcesados ?? 0,
  );
  readonly totalRegistros = computed(
    () => this.eventoActual()?.totalRegistros ?? 0,
  );
  readonly nombreArchivoSeleccionado = computed(
    () => this.archivoSeleccionado()?.name ?? '',
  );
  readonly tieneArchivo = computed(() => !!this.archivoSeleccionado());
  readonly mensajeDeError = computed(() => this.mensajeError());
  readonly registros = computed(() => this.registrosAcumulados());
  readonly detalleArchivoSeleccionado = computed(() => {
    const metadata = this.archivoMetadataSignal();
    if (!metadata) {
      return null;
    }

    return {
      tamano: this.formatearBytes(metadata.size),
      fecha: metadata.lastModified ? new Date(metadata.lastModified) : null,
      filas: metadata.filasEstimadas,
      calculandoFilas: metadata.calculandoFilas,
    };
  });
  readonly mensajeDeProgreso = computed(() => this.mensajeProgresoSignal());
  readonly terminoBusqueda = computed(() => this.terminoBusquedaSignal());
  readonly flujoSeleccionado = computed(() => this.flujoSeleccionadoSignal());
  readonly tamanoPaginaActual = computed(() => this.tamanoPaginaSignal());
  readonly paginaActual = computed(() => {
    const total = this.totalPaginas();
    const pagina = this.paginaActualSignal();
    return Math.min(Math.max(1, pagina), total);
  });
  readonly ultimaActualizacion = computed(() =>
    this.ultimaActualizacionSignal(),
  );
  readonly flujosDisponibles = computed(() => {
    const conjunto = new Set<string>();
    this.registros().forEach((registro) => {
      if (registro.flujo.trim()) {
        conjunto.add(registro.flujo);
      }
    });
    return Array.from(conjunto).sort();
  });
  readonly registrosFiltrados = computed(() => {
    const termino = this.terminoBusquedaSignal().trim().toLowerCase();
    const flujo = this.flujoSeleccionadoSignal();
    const registros = this.registros();

    return registros.filter((registro) => {
      if (flujo !== 'todos' && registro.flujo !== flujo) {
        return false;
      }

      if (!termino) {
        return true;
      }

      const valores = [
        registro.folioControl,
        registro.flujo,
        registro.cicloEscolar,
        registro.curp,
        registro.primerApellido,
        registro.segundoApellido ?? '',
        registro.nombre,
      ]
        .join(' ')
        .toLowerCase();

      return valores.includes(termino);
    });
  });
  readonly totalPaginas = computed(() => {
    const registros = this.registrosFiltrados().length;
    if (!registros) {
      return 1;
    }
    return Math.max(1, Math.ceil(registros / this.tamanoPaginaSignal()));
  });
  readonly registrosPaginados = computed(() => {
    const registros = this.registrosFiltrados();
    const tamano = this.tamanoPaginaSignal();
    const pagina = this.paginaActual();
    const inicio = (pagina - 1) * tamano;
    return registros.slice(inicio, inicio + tamano);
  });
  readonly hayRegistrosGuardados = computed(() => this.registros().length > 0);
  readonly encabezadosEsperados =
    this.cargaMasivaService.obtenerEncabezadosEsperados();
  readonly mostrarModalRequisitos = computed(
    () => this.mostrarModalRequisitosSignal(),
  );

  ngOnInit(): void {
    this.cargarRegistrosGuardados();
  }

  onSubmit(event: Event): void {
    event.preventDefault();
    const archivo = this.formulario.controls.archivo.value;
    if (!archivo) {
      this.formulario.controls.archivo.markAsTouched();
      return;
    }

    this.procesarArchivo(archivo);
  }

  onArchivoSeleccionado(event: Event): void {
    const input = event.target as HTMLInputElement;
    const archivo = input.files?.[0] ?? null;
    if (!archivo) {
      this.formulario.controls.archivo.setValue(null);
      this.archivoSeleccionado.set(null);
      this.archivoMetadataSignal.set(null);
      return;
    }

    this.formulario.controls.archivo.setValue(archivo);
    this.archivoSeleccionado.set(archivo);
    this.mensajeError.set(null);
    this.mensajeProgresoSignal.set(null);
    this.actualizarArchivoMetadata(archivo);
  }

  onArchivoSoltado(event: DragEvent): void {
    event.preventDefault();
    if (!event.dataTransfer?.files?.length) {
      return;
    }

    const archivo = event.dataTransfer.files[0];
    this.formulario.controls.archivo.setValue(archivo);
    this.archivoSeleccionado.set(archivo);
    this.mensajeError.set(null);
    this.mensajeProgresoSignal.set(null);
    this.actualizarArchivoMetadata(archivo);

    if (this.fileInput?.nativeElement) {
      this.fileInput.nativeElement.files = event.dataTransfer.files;
    }
  }

  onArrastreSobreZona(event: DragEvent): void {
    event.preventDefault();
  }

  limpiarSeleccion(): void {
    this.cancelarProcesamiento(false);
    this.formulario.reset({ archivo: null, reemplazarExistentes: true });
    this.eventoActual.set(null);
    this.mensajeError.set(null);
    this.archivoSeleccionado.set(null);
    this.archivoMetadataSignal.set(null);
    this.registrosAcumulados.set([]);
    this.actualizarAlmacenamiento([]);
    this.terminoBusquedaSignal.set('');
    this.flujoSeleccionadoSignal.set('todos');
    this.tamanoPaginaSignal.set(this.tamanoPaginaPorDefecto);
    this.paginaActualSignal.set(1);
    this.mensajeProgresoSignal.set(null);
    if (this.fileInput?.nativeElement) {
      this.fileInput.nativeElement.value = '';
    }
  }

  procesarArchivo(archivo: File): void {
    this.cancelarProcesamiento(false);
    this.eventoActual.set({
      estado: 'procesando',
      porcentajeAvance: 0,
      registrosProcesados: 0,
      totalRegistros: 0,
    });
    this.mensajeError.set(null);
    this.registrosAcumulados.set([]);
    this.actualizarAlmacenamiento([]);
    this.mensajeProgresoSignal.set('Preparando archivo…');
    this.paginaActualSignal.set(1);

    this.procesamientoSub = this.cargaMasivaService
      .procesarArchivo(archivo)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (evento) => {
          this.eventoActual.set(evento);
          if (typeof evento.totalRegistros === 'number') {
            this.archivoMetadataSignal.update((actual) =>
              actual
                ? {
                    ...actual,
                    filasEstimadas: evento.totalRegistros,
                    calculandoFilas: false,
                  }
                : actual,
            );
          }

          this.mensajeProgresoSignal.set(evento.mensajeProgreso ?? null);

          const nuevosRegistros = evento.nuevosRegistros ?? [];
          if (nuevosRegistros.length) {
            this.registrosAcumulados.update((actuales) => {
              const actualizados = [...actuales, ...nuevosRegistros];
              this.actualizarAlmacenamiento(actualizados);
              return actualizados;
            });
          }
          if (evento.estado === 'error') {
            this.mensajeError.set(
              evento.mensajeError ?? 'Ocurrió un error inesperado.',
            );
          }
        },
        error: () => {
          this.mensajeError.set('No fue posible procesar el archivo.');
          this.eventoActual.set({
            estado: 'error',
            porcentajeAvance: 0,
            registrosProcesados: 0,
            totalRegistros: 0,
          });
          this.registrosAcumulados.set([]);
          this.actualizarAlmacenamiento([]);
          this.mensajeProgresoSignal.set('No fue posible procesar el archivo.');
        },
        complete: () => {
          this.mensajeProgresoSignal.update(
            (mensaje) => mensaje ?? 'Procesamiento completado.',
          );
          this.procesamientoSub = null;
        },
      });
  }

  descargarPlantilla(): void {
    const contenido = this.cargaMasivaService.generarPlantillaEjemplo();
    this.descargarArchivo(contenido, 'plantilla-inscripcion-masiva.csv');
  }

  verDetalle(registro: InscripcionMasivaRegistro): void {
    this.cargaMasivaService.establecerRegistroSeleccionado(registro);
    void this.router.navigate(['carga-masiva', 'detalle'], {
      state: { registro },
    });
  }

  cancelarProcesamiento(actualizarEstado = true): void {
    if (this.procesamientoSub) {
      this.procesamientoSub.unsubscribe();
      this.procesamientoSub = null;
    }
    if (actualizarEstado) {
      const previo = this.eventoActual();
      this.eventoActual.set({
        estado: 'cancelado',
        porcentajeAvance: previo?.porcentajeAvance ?? 0,
        registrosProcesados: previo?.registrosProcesados ?? 0,
        totalRegistros: previo?.totalRegistros ?? 0,
      });
      this.mensajeProgresoSignal.set('Procesamiento cancelado por el usuario.');
    }
  }

  abrirModalRequisitos(): void {
    this.mostrarModalRequisitosSignal.set(true);
  }

  cerrarModalRequisitos(): void {
    this.mostrarModalRequisitosSignal.set(false);
  }

  onModalKeydown(event: KeyboardEvent): void {
    if (event.key === 'Escape') {
      event.preventDefault();
      this.cerrarModalRequisitos();
    }
  }

  onBusquedaChange(valor: string): void {
    this.terminoBusquedaSignal.set(valor);
    this.paginaActualSignal.set(1);
  }

  onFiltroFlujoChange(valor: string): void {
    this.flujoSeleccionadoSignal.set(valor);
    this.paginaActualSignal.set(1);
  }

  onTamanoPaginaChange(valor: string): void {
    const numero = Number.parseInt(valor, 10);
    if (!Number.isNaN(numero) && numero > 0) {
      this.tamanoPaginaSignal.set(numero);
      this.paginaActualSignal.set(1);
    }
  }

  irAPagina(pagina: number): void {
    const total = this.totalPaginas();
    const destino = Math.min(Math.max(1, pagina), total);
    this.paginaActualSignal.set(destino);
  }

  paginaSiguiente(): void {
    this.irAPagina(this.paginaActualSignal() + 1);
  }

  paginaAnterior(): void {
    this.irAPagina(this.paginaActualSignal() - 1);
  }

  limpiarRegistrosGuardados(): void {
    this.registrosAcumulados.set([]);
    this.actualizarAlmacenamiento([]);
    this.eventoActual.set(null);
    this.mensajeProgresoSignal.set(null);
    this.paginaActualSignal.set(1);
  }

  private descargarArchivo(contenido: string, nombreArchivo: string): void {
    const blob = new Blob([contenido], { type: 'text/csv;charset=utf-8;' });
    const enlace = document.createElement('a');
    const url = URL.createObjectURL(blob);
    enlace.href = url;
    enlace.download = nombreArchivo;
    enlace.style.display = 'none';
    document.body.appendChild(enlace);
    enlace.click();
    document.body.removeChild(enlace);
    URL.revokeObjectURL(url);
  }

  private actualizarAlmacenamiento(
    registros: InscripcionMasivaRegistro[],
  ): void {
    if (typeof window === 'undefined' || !window.localStorage) {
      return;
    }

    try {
      window.localStorage.setItem(this.storageKey, JSON.stringify(registros));
      if (registros.length) {
        this.ultimaActualizacionSignal.set(new Date());
      } else {
        this.ultimaActualizacionSignal.set(null);
      }
    } catch {
      this.mensajeError.set(
        'No fue posible guardar los registros en el navegador. Libera espacio e intenta nuevamente.',
      );
      this.mensajeProgresoSignal.set(null);
    }
  }

  private cargarRegistrosGuardados(): void {
    if (typeof window === 'undefined' || !window.localStorage) {
      this.registrosAcumulados.set([]);
      return;
    }

    const stored = window.localStorage.getItem(this.storageKey);

    if (!stored) {
      this.registrosAcumulados.set([]);
      return;
    }

    try {
      const registros = JSON.parse(stored);
      if (Array.isArray(registros)) {
        const normalizados = registros
          .map((registro) => this.normalizarRegistroGuardado(registro))
          .filter(
            (registro): registro is InscripcionMasivaRegistro =>
              registro !== null,
          );
        this.registrosAcumulados.set(normalizados);
        this.ultimaActualizacionSignal.set(
          normalizados.length ? new Date() : null,
        );
      } else {
        this.registrosAcumulados.set([]);
        this.ultimaActualizacionSignal.set(null);
      }
    } catch {
      this.registrosAcumulados.set([]);
      this.ultimaActualizacionSignal.set(null);
      this.mensajeError.set(
        'No fue posible recuperar los registros guardados. La información anterior fue descartada.',
      );
      this.mensajeProgresoSignal.set(null);
    }
  }

  private normalizarRegistroGuardado(
    registro: unknown,
  ): InscripcionMasivaRegistro | null {
    if (!registro || typeof registro !== 'object') {
      return null;
    }

    const datos = registro as Record<string, unknown>;
    const obtenerCampo = (
      clave: keyof InscripcionMasivaRegistro,
      esOpcional = false,
    ): string | undefined => {
      const valor = datos[clave];
      if (typeof valor === 'string') {
        return valor;
      }

      return esOpcional ? undefined : '';
    };

    return {
      folioControl: obtenerCampo('folioControl') ?? '',
      flujo: obtenerCampo('flujo') ?? '',
      cicloEscolar: obtenerCampo('cicloEscolar') ?? '',
      curp: obtenerCampo('curp') ?? '',
      primerApellido: obtenerCampo('primerApellido') ?? '',
      segundoApellido: obtenerCampo('segundoApellido', true),
      nombre: obtenerCampo('nombre') ?? '',
      fechaNacimiento: obtenerCampo('fechaNacimiento') ?? '',
      grado: obtenerCampo('grado') ?? '',
      grupo: obtenerCampo('grupo') ?? '',
      correoElectronico: obtenerCampo('correoElectronico', true),
    };
  }

  private actualizarArchivoMetadata(archivo: File): void {
    this.lecturaArchivoId += 1;
    const lecturaId = this.lecturaArchivoId;
    this.archivoMetadataSignal.set({
      size: archivo.size,
      lastModified: archivo.lastModified,
      filasEstimadas: null,
      calculandoFilas: true,
    });

    archivo
      .text()
      .then((contenido) => {
        if (lecturaId !== this.lecturaArchivoId) {
          return;
        }
        const lineas = contenido
          .split(/\r?\n/)
          .filter((linea) => linea.trim().length > 0);
        const filas = Math.max(0, lineas.length - 1);
        this.archivoMetadataSignal.update((actual) =>
          actual
            ? {
                ...actual,
                filasEstimadas: filas,
                calculandoFilas: false,
              }
            : actual,
        );
      })
      .catch(() => {
        this.archivoMetadataSignal.update((actual) =>
          actual
            ? {
                ...actual,
                calculandoFilas: false,
              }
            : actual,
        );
      });
  }

  private formatearBytes(bytes: number): string {
    if (!Number.isFinite(bytes) || bytes <= 0) {
      return '0 bytes';
    }

    const unidades = ['bytes', 'KB', 'MB', 'GB'];
    const indice = Math.min(
      Math.floor(Math.log(bytes) / Math.log(1024)),
      unidades.length - 1,
    );
    const valor = bytes / Math.pow(1024, indice);
    const formateador = new Intl.NumberFormat('es-MX', {
      maximumFractionDigits: indice === 0 ? 0 : 2,
    });
    return `${formateador.format(valor)} ${unidades[indice]}`;
  }
}
