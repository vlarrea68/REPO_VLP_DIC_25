import { CommonModule } from '@angular/common';
import {
  Component,
  DestroyRef,
  Input,
  OnChanges,
  OnInit,
  SimpleChanges,
  inject,
  signal,
} from '@angular/core';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  ValidationErrors,
  ValidatorFn,
  Validators,
  ReactiveFormsModule,
} from '@angular/forms';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { Observable, catchError, distinctUntilChanged, map, of, switchMap } from 'rxjs';
import { CatalogosService } from '../../services/catalogos.service';
import { Router } from '@angular/router';
import {
  ConfiguracionFormulariosService,
  InstitucionFormularioConfiguracion,
} from '../../services/configuracion-formularios.service';

interface SelectOption<T = string> {
  label: string;
  value: T;
}

interface CctCatalogEntry {
  cct: string;
  nombrePlantel: string;
  entidad: string;
  municipio: string;
  localidad: string;
}

interface InscripcionRegistro extends Record<string, unknown> {
  flujo: string;
  cicloEscolar: string;
  nombreCompleto: string;
  curp?: string;
  guardadoEn: string;
}

interface CampoConfiguracionAplicada {
  visible: boolean;
  required: boolean;
  labelOverride?: string;
}

@Component({
  selector: 'app-inscripcion',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './inscripcion.component.html',
  styleUrl: './inscripcion.component.scss',
})
export class InscripcionComponent implements OnInit, OnChanges {
  @Input()
  modoBaja = false;

  private readonly fb = inject(FormBuilder);
  private readonly catalogosService = inject(CatalogosService);
  private readonly router = inject(Router);
  private readonly configuracionFormulariosService = inject(
    ConfiguracionFormulariosService
  );
  private readonly destroyRef = inject(DestroyRef);
  private readonly selectPlaceholder: SelectOption = {
    label: 'Seleccione una opción',
    value: '',
  };
  private readonly localeCollator = new Intl.Collator('es', {
    sensitivity: 'base',
    ignorePunctuation: true,
  });

  private readonly nombreLibreRegex =
    /^(?=.{1,100}$)[\p{L}\p{M}\s.,''"()\-°ª]+$/u;
  private readonly segmentoRaizRegex = /^[A-ZÁÉÍÓÚÜÑ]{4}\d{6}[HM][A-Z]{5}$/i;
  private readonly curpRegex = /^[A-ZÁÉÍÓÚÜÑ]{4}\d{6}[HM][A-Z]{5}[A-Z\d]{2}$/i;
  private readonly cctRegex = /^[0-9]{2}[A-Z]{3}\d{4}[A-Z0-9]$/;
  private readonly cicloEscolarRegex = /^\d{4}-\d{4}$/;
  private readonly cicloInstitucionalRegex = /^\d{4}-\d$/;
  private readonly anoEscolarRegex = /^\d{4}$/;
  private readonly periodoRegex = /^\d{1,2}$/;
  private readonly duracionPeriodoRegex = /^\d{1,2}$/;
  private readonly telefonoRegex = /^\d{10}$/;
  private readonly slashDateRegex = /^(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/;
  private readonly isoDateRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/;
  private readonly claveInstitucionRegex = /^[A-Z0-9-]{5,15}$/;
  private readonly claveCarreraRegex = /^[A-Z0-9-]{5,15}$/;
  private readonly numeroRvoeRegex = /^[A-Z0-9-]{5,20}$/;
  private readonly creditosRegex = /^\d{1,3}$/;
  private readonly dateFieldNames: readonly string[] = [
    'fechaNacimiento',
    'fechaAcuerdoRvoe',
    'fechaInicioPeriodo',
    'fechaInicioEstudios',
  ];

  readonly submissionSuccess = signal(false);

  modoEdicion = false;
  mensajeGuardado = '';
  registrosGuardados: InscripcionRegistro[] = [];
  private registroEnEdicionIndex: number | null = null;
  readonly todayIsoString = this.formatDateToIso(new Date());

  institucionOptions: SelectOption[] = [this.selectPlaceholder];
  institucionConfiguracionSeleccionada: InstitucionFormularioConfiguracion | null =
    null;
  configuracionCargando = false;
  camposOcultos: string[] = [];
  camposOpcionales: string[] = [];

  private baseCamposConfiguracion: Record<string, CampoConfiguracionAplicada> = {};
  private camposConfiguracionActual: Record<string, CampoConfiguracionAplicada> = {};
  private readonly campoEtiquetaCache: Record<string, string> = {};

  get tituloFormulario(): string {
    return `Formulario de ${this.textoAccion}`;
  }

  get textoAccion(): 'inscripción' | 'baja' {
    return this.modoBaja ? 'baja' : 'inscripción';
  }

  get textoAccionCapitalizada(): string {
    return this.capitalize(this.textoAccion);
  }

  get textoAccionPlural(): 'inscripciones' | 'bajas' {
    return this.modoBaja ? 'bajas' : 'inscripciones';
  }

  get textoAccionPluralCapitalizada(): string {
    return this.capitalize(this.textoAccionPlural);
  }

  get mensajeExitoAlmacenamiento(): string {
    return `La ${this.textoAccion} se guardó en el almacenamiento local del navegador.`;
  }

  flujoOptions: SelectOption[] = [this.selectPlaceholder];
  turnoOptions: SelectOption[] = [this.selectPlaceholder];
  generoOptions: SelectOption[] = [
    { label: 'Seleccione una opción', value: '' },
    { label: 'Mujer', value: 'MUJ' },
    { label: 'Hombre', value: 'HOM' },
    { label: 'No binario', value: 'NBI' },
    { label: 'Otro', value: 'OTR' },
  ];
  sexoOptions: SelectOption[] = [
    this.selectPlaceholder,
    { label: 'H) Hombre', value: 'H' },
    { label: 'M) Mujer', value: 'M' },
  ];
  nacionalidadOptions: SelectOption[] = [this.selectPlaceholder];
  paisOptions: SelectOption[] = [this.selectPlaceholder];
  entidadOptions: SelectOption[] = [this.selectPlaceholder];
  municipioOptions: SelectOption[] = [
    { label: 'Seleccione una opción', value: '' },
    { label: 'Álvaro Obregón', value: '001' },
    { label: 'Guadalajara', value: '039' },
    { label: 'Monterrey', value: '039' },
    { label: 'Mérida', value: '050' },
  ];

  readonly tipoVialidadOptions: SelectOption[] = [
    { label: 'Seleccione una opción', value: '' },
    { label: 'Avenida', value: 'AV' },
    { label: 'Boulevard', value: 'BLV' },
    { label: 'Calle', value: 'CAL' },
    { label: 'Calzada', value: 'CLZ' },
    { label: 'Carretera', value: 'CAR' },
  ];

  nivelEducativoOptions: SelectOption[] = [this.selectPlaceholder];
  modalidadOptions: SelectOption[] = [this.selectPlaceholder];
  opcionEducativaCatalog: SelectOption[] = [this.selectPlaceholder];

  readonly lenguaOptions: SelectOption[] = [
    { label: 'Seleccione una opción', value: '' },
    { label: 'Español', value: 'ESPA' },
    { label: 'Inglés', value: 'INGL' },
    { label: 'Lengua indígena', value: 'LING' },
    { label: 'Lengua de señas mexicana', value: 'LSM' },
  ];

  necesidadOptions: SelectOption[] = [this.selectPlaceholder];
  tipoDiscapacidadOptions: SelectOption[] = [this.selectPlaceholder];
  aptitudSobresalienteOptions: SelectOption[] = [this.selectPlaceholder];
  antecedenteOptions: SelectOption[] = [this.selectPlaceholder];
  situacionAcademicaOptions: SelectOption[] = [this.selectPlaceholder];
  origenEstudiosOptions: SelectOption[] = [this.selectPlaceholder];
  tipoBajaOptions: SelectOption[] = [
    { label: 'Seleccione una opción', value: '' },
    { label: 'Temporal', value: '1' },
    { label: 'Definitiva', value: '2' },
  ];

  motivoBajaOptions: SelectOption[] = [this.selectPlaceholder];
  duracionPeriodoOptions: SelectOption[] = [this.selectPlaceholder];
  periodoModuloOptions: SelectOption[] = [this.selectPlaceholder];
  gradoAvanceOptions: SelectOption[] = [this.selectPlaceholder];

  readonly cctCatalog: CctCatalogEntry[] = [
    {
      cct: '09DPR1234Z',
      nombrePlantel: 'Centro de Innovación Educativa',
      entidad: '09',
      municipio: '001',
      localidad: '0001',
    },
    {
      cct: '14EMS5678A',
      nombrePlantel: 'Instituto Tecnológico del Occidente',
      entidad: '14',
      municipio: '039',
      localidad: '0002',
    },
  ];

  private readonly defaultCicloEscolar = this.getCurrentSchoolCycle();
  private readonly defaultAnoEscolar = this.getCycleStartYearString(
    this.defaultCicloEscolar
  );

  readonly inscripcionForm: FormGroup = this.fb.group(
    {
      flujo: [
        '',
        [
          Validators.required,
          this.allowedValuesValidator(['I', 'R', 'B']),
        ],
      ],
      cicloEscolar: [
        this.defaultCicloEscolar,
        [Validators.required, this.cicloEscolarValidator()],
      ],
      anoEscolar: [
        this.defaultAnoEscolar,
        [Validators.required, Validators.pattern(this.anoEscolarRegex)],
      ],
      nivelEducativo: ['', Validators.required],
      modalidadEducativa: ['', Validators.required],
      claveInstitucion: [
        '',
        [Validators.required, Validators.pattern(this.claveInstitucionRegex)],
      ],
      claveEscuela: [
        '',
        [
          Validators.required,
          Validators.pattern(this.cctRegex),
          this.cctCatalogValidator(),
        ],
      ],
      claveCarrera: [
        '',
        [Validators.required, Validators.pattern(this.claveCarreraRegex)],
      ],
      creditosTotales: [
        '',
        [Validators.required, Validators.pattern(this.creditosRegex)],
      ],
      nombreAlumno: [
        '',
        [
          Validators.required,
          this.optionalPatternValidator(this.nombreLibreRegex),
        ],
      ],
      primerApellido: [
        '',
        [
          Validators.required,
          this.optionalPatternValidator(this.nombreLibreRegex),
        ],
      ],
      segundoApellido: [
        '',
        this.optionalPatternValidator(this.nombreLibreRegex),
      ],
      sexo: ['', Validators.required],
      genero: ['', Validators.required],
      segmentoRaiz: [
        '',
        [
          Validators.required,
          Validators.minLength(16),
          Validators.maxLength(16),
          this.optionalPatternValidator(this.segmentoRaizRegex),
        ],
      ],
      curp: [
        '',
        [
          Validators.required,
          Validators.minLength(18),
          Validators.maxLength(18),
          this.optionalPatternValidator(this.curpRegex),
        ],
      ],
      fechaNacimiento: [
        '',
        [
          Validators.required,
          this.dateFormatValidator(),
          this.notFutureDateValidator(),
        ],
      ],
      correoElectronico: ['', [Validators.required, Validators.email]],
      numeroTelefonico: ['', this.optionalPatternValidator(this.telefonoRegex)],
      nacionalidad: ['', Validators.required],
      paisNacimiento: ['', Validators.required],
      entidadNacimiento: ['', Validators.required],
      paisResidencia: ['', Validators.required],
      entidadResidencia: ['', Validators.required],
      municipioResidencia: ['', Validators.required],
      entidadDomicilio: ['', Validators.required],
      tipoVialidad: ['', Validators.required],
      nombreVialidad: [
        '',
        [
          Validators.required,
          this.optionalPatternValidator(/^[A-ZÁÉÍÓÚÜÑ0-9'\-\.\s]{1,255}$/i),
        ],
      ],
      numeroExterior: ['', this.optionalPatternValidator(/^[\w\-]{1,15}$/i)],
      numeroInterior: ['', this.optionalPatternValidator(/^[\w\-]{1,15}$/i)],
      codigoPostal: [
        '',
        [Validators.required, Validators.pattern(/^\d{5}$/)],
      ],
      paisProcedencia: ['', Validators.required],
      entidadProcedencia: ['', Validators.required],
      lenguaMaterna: ['', Validators.required],
      segundaLengua: ['', this.optionalPatternValidator(/^[A-Z0-9]{2,4}$/i)],
      necesidadEducativa: ['', Validators.required],
      tipoDiscapacidad: [''],
      aptitudSobresaliente: [''],
      numeroMatricula: [
        '',
        [Validators.required, this.optionalPatternValidator(/^[A-Z0-9-]{5,20}$/i)],
      ],
      cicloInstitucional: [
        '',
        [
          Validators.required,
          Validators.pattern(this.cicloInstitucionalRegex),
        ],
      ],
      gradoAvance: ['', [Validators.required, Validators.pattern(this.periodoRegex)]],
      periodoModulo: [
        '',
        [Validators.required, Validators.pattern(this.periodoRegex)],
      ],
      duracionPeriodo: [
        '',
        [Validators.required, Validators.pattern(this.duracionPeriodoRegex)],
      ],
      fechaInicioPeriodo: [
        '',
        [
          Validators.required,
          this.dateFormatValidator(),
          this.notFutureDateValidator(),
        ],
      ],
      antecedenteAcademico: ['', Validators.required],
      fechaInicioEstudios: [
        '',
        [
          Validators.required,
          this.dateFormatValidator(),
          this.notFutureDateValidator(),
        ],
      ],
      tipoBaja: [''],
      motivoBaja: [''],
      opcionEducativa: ['', Validators.required],
      numeroAcuerdoRvoe: [
        '',
        [Validators.required, Validators.pattern(this.numeroRvoeRegex)],
      ],
      fechaAcuerdoRvoe: [
        '',
        [Validators.required, this.dateFormatValidator()],
      ],
      turno: ['', Validators.required],
      situacionAcademica: ['', Validators.required],
      origenEstudios: ['', Validators.required],
    },
    {
      validators: [
        this.curpSegmentoConsistencyValidator(),
        this.segundaLenguaValidator(),
        this.flujoGradoValidator(),
        this.anoEscolarPeriodoValidator(),
      ],
    }
  );

  constructor() {
    this.cargarCatalogos();
    this.inicializarConfiguracionCampos();
    this.applyFieldConfiguration(null);
    this.cargarInstitucionesFormulario();
    this.configureUppercaseControls([
      'segmentoRaiz',
      'curp',
      'claveEscuela',
      'claveInstitucion',
      'claveCarrera',
      'numeroAcuerdoRvoe',
      'numeroMatricula',
    ]);
    this.configureBajaRequirements();
    this.configureFlujoNavigation();
    this.resetSuccessOnChanges();
    this.subscribeToInstitucionChanges();
    this.configureNecesidadEducativaDependencies();
  }

  ngOnInit(): void {
    this.aplicarConfiguracionPorModo(true);
    this.cargarRegistrosGuardados();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if ('modoBaja' in changes && !changes['modoBaja'].firstChange) {
      this.aplicarConfiguracionPorModo();
      this.cargarRegistrosGuardados();
    }
  }

  private inicializarConfiguracionCampos(): void {
    const base: Record<string, CampoConfiguracionAplicada> = {};

    Object.entries(this.inscripcionForm.controls).forEach(([campo, control]) => {
      base[campo] = {
        visible: true,
        required: this.controlHasValidator(control, Validators.required),
      };
    });

    this.baseCamposConfiguracion = base;
    this.camposConfiguracionActual = Object.fromEntries(
      Object.entries(base).map(([campo, config]) => [campo, { ...config }])
    );
  }

  private cargarInstitucionesFormulario(): void {
    this.configuracionFormulariosService
      .getInstituciones()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((instituciones) => {
        const options = instituciones.map(({ clave, nombre }) => ({
          label: `${clave}) ${nombre}`,
          value: clave,
        }));

        this.institucionOptions = this.withPlaceholder(options);
      });
  }

  private subscribeToInstitucionChanges(): void {
    const control = this.getControl('claveInstitucion');

    if (!control) {
      return;
    }

    control.valueChanges
      .pipe(
        takeUntilDestroyed(this.destroyRef),
        map((valor) => (typeof valor === 'string' ? valor.trim() : '')),
        distinctUntilChanged(),
        switchMap((clave) => {
          if (!clave) {
            this.configuracionCargando = false;
            return of(null);
          }

          this.configuracionCargando = true;

          return this.configuracionFormulariosService
            .getConfiguracionPorClaveInstitucion(clave)
            .pipe(catchError(() => of(null)));
        })
      )
      .subscribe((configuracion) => {
        this.configuracionCargando = false;
        this.applyFieldConfiguration(configuracion);
      });
  }

  private reaplicarConfiguracionCamposActual(): void {
    this.applyFieldConfiguration(this.institucionConfiguracionSeleccionada);
  }

  private applyFieldConfiguration(
    configuracion: InstitucionFormularioConfiguracion | null
  ): void {
    const merged: Record<string, CampoConfiguracionAplicada> = {};

    Object.entries(this.baseCamposConfiguracion).forEach(([campo, base]) => {
      const override = configuracion?.campos?.[campo];
      const visible = override?.visible ?? base.visible;
      const required = override?.obligatorio ?? base.required;
      const labelOverride = override?.etiqueta ?? base.labelOverride;

      const aplicada: CampoConfiguracionAplicada = {
        visible,
        required,
        labelOverride,
      };

      merged[campo] = aplicada;
      this.actualizarControlSegunConfiguracion(campo, aplicada);
    });

    this.camposConfiguracionActual = merged;
    this.institucionConfiguracionSeleccionada = configuracion;

    const camposOcultos: string[] = [];
    const camposOpcionales: string[] = [];

    Object.entries(merged).forEach(([campo, config]) => {
      const baseConfig = this.baseCamposConfiguracion[campo];

      if (!config.visible) {
        camposOcultos.push(this.obtenerNombreCampoParaResumen(campo, config));
        return;
      }

      const eraObligatorio = baseConfig?.required ?? false;
      if (eraObligatorio && !config.required) {
        camposOpcionales.push(this.obtenerNombreCampoParaResumen(campo, config));
      }
    });

    this.camposOcultos = camposOcultos;
    this.camposOpcionales = camposOpcionales;
    this.actualizarDependenciasNecesidad();
  }

  private actualizarControlSegunConfiguracion(
    campo: string,
    configuracion: CampoConfiguracionAplicada
  ): void {
    const control = this.getControl(campo);

    if (!control) {
      return;
    }

    if (!configuracion.visible) {
      control.reset('', { emitEvent: false });
      control.disable({ emitEvent: false });
      control.removeValidators(Validators.required);
      control.updateValueAndValidity({ emitEvent: false });
      return;
    }

    control.enable({ emitEvent: false });

    if (configuracion.required) {
      control.addValidators(Validators.required);
    } else {
      control.removeValidators(Validators.required);
    }

    control.updateValueAndValidity({ emitEvent: false });
  }

  private controlHasValidator(
    control: AbstractControl,
    validator: ValidatorFn
  ): boolean {
    const maybeHasValidator = (control as { hasValidator?: (validator: ValidatorFn) => boolean }).hasValidator;
    return typeof maybeHasValidator === 'function'
      ? maybeHasValidator.call(control, validator)
      : false;
  }

  esCampoVisible(campo: string): boolean {
    return this.camposConfiguracionActual[campo]?.visible ?? true;
  }

  esCampoObligatorio(campo: string): boolean {
    if (campo in this.camposConfiguracionActual) {
      return this.camposConfiguracionActual[campo]?.required ?? false;
    }

    return this.baseCamposConfiguracion[campo]?.required ?? false;
  }

  private obtenerNombreCampoParaResumen(
    campo: string,
    configuracion: CampoConfiguracionAplicada
  ): string {
    const etiquetaOverride = configuracion.labelOverride?.trim();

    if (etiquetaOverride) {
      return etiquetaOverride;
    }

    if (!this.campoEtiquetaCache[campo]) {
      const conEspacios = campo
        .replace(/([A-Z])/g, ' $1')
        .replace(/_/g, ' ')
        .trim();

      const palabras = conEspacios
        .split(/\s+/)
        .filter((segmento) => segmento.length > 0)
        .map((segmento) => this.capitalize(segmento.toLowerCase()));

      this.campoEtiquetaCache[campo] =
        palabras.length > 0 ? palabras.join(' ') : campo;
    }

    return this.campoEtiquetaCache[campo];
  }

  private cargarCatalogos(): void {
    this.subscribeToCatalog(
      this.catalogosService.getFlujos(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.flujoOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getTurnos(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.turnoOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getNacionalidades(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion.toUpperCase()}`,
        value: clave,
      }),
      (options) => (this.nacionalidadOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getPaises(),
      ({ clave, nombre }) => ({
        label: nombre,
        value: clave,
      }),
      (options) => (this.paisOptions = options),
      (a, b) => this.localeCollator.compare(a.label, b.label)
    );

    this.subscribeToCatalog(
      this.catalogosService.getEntidades(),
      ({ claveEntidad, nombre }) => ({
        label: `${claveEntidad}) ${nombre}`,
        value: claveEntidad,
      }),
      (options) => (this.entidadOptions = options),
      (a, b) => this.localeCollator.compare(a.label, b.label)
    );

    this.subscribeToCatalog(
      this.catalogosService.getNivelesEducativos(),
      ({ clave, nivelEducativo }) => ({
        label: `${clave}) ${nivelEducativo}`,
        value: clave,
      }),
      (options) => (this.nivelEducativoOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getModalidades(),
      ({ clave, modalidadEducativa }) => ({
        label: `${clave}) ${modalidadEducativa}`,
        value: clave,
      }),
      (options) => (this.modalidadOptions = options)
    );

    const opcionEducativaLabelMap: Record<string, string> = {
      'Presencial': 'Presencial',
      'En Línea / Virtual': 'En línea/virtual',
      'Abierta / A Distancia': 'Abierta/a distancia',
      'Certificación Por Examen': 'Certificación por examen',
      'Dual': 'Dual',
    };

    this.catalogosService
      .getOpcionesEducativas()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((entries) => {
        const seen = new Set<string>();
        const mapped = entries
          .map(({ clave, opcionEducativa }) => {
            const formattedLabel =
              opcionEducativaLabelMap[opcionEducativa] ?? opcionEducativa;
            return {
              label: formattedLabel,
              value: clave,
              normalized: formattedLabel.toLocaleLowerCase('es'),
            };
          })
          .filter((entry) => {
            if (seen.has(entry.normalized)) {
              return false;
            }
            seen.add(entry.normalized);
            return true;
          })
          .map(({ label, value }) => ({ label, value }));

        this.opcionEducativaCatalog = this.withPlaceholder(mapped);
      });

    this.subscribeToCatalog(
      this.catalogosService.getNecesidadesEducativas(),
      ({ clave, descripcion }) => ({
        label:
          clave === '00'
            ? '00) No aplica/Se desconoce'
            : `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.necesidadOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getDiscapacidades(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.tipoDiscapacidadOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getAptitudesSobresalientes(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.aptitudSobresalienteOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getCatalogoSiNo(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.antecedenteOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getSituacionesAcademicas(),
      ({ clave, situacionAcademica }) => ({
        label: `${clave}) ${situacionAcademica}`,
        value: clave,
      }),
      (options) => (this.situacionAcademicaOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getOrigenesEstudios(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.origenEstudiosOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getMotivosBaja(),
      ({ clave, causa }) => ({
        label: `${clave}) ${causa}`,
        value: clave,
      }),
      (options) => (this.motivoBajaOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getDuracionesPeriodoEscolar(),
      ({ clave, descripcion }) => ({
        label: `${clave}) ${descripcion}`,
        value: clave,
      }),
      (options) => (this.duracionPeriodoOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getNumerosPeriodo(),
      ({ clave, ordinal }) => ({
        label: `${clave}) ${ordinal}`,
        value: clave,
      }),
      (options) => (this.periodoModuloOptions = options)
    );

    this.subscribeToCatalog(
      this.catalogosService.getGradosPlanEstudios(),
      ({ numeroArabigo, ordinal }) => ({
        label: `${numeroArabigo}) ${ordinal}`,
        value: numeroArabigo,
      }),
      (options) => (this.gradoAvanceOptions = options)
    );
  }

  private subscribeToCatalog<T>(
    source: Observable<T[]>,
    mapItem: (item: T) => SelectOption,
    assign: (options: SelectOption[]) => void,
    sortFn?: (a: SelectOption, b: SelectOption) => number
  ): void {
    source
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((items) => {
        const mapped = items.map(mapItem);
        if (sortFn) {
          mapped.sort(sortFn);
        }
        assign(this.withPlaceholder(mapped));
      });
  }

  private withPlaceholder(options: SelectOption[]): SelectOption[] {
    return [this.selectPlaceholder, ...options];
  }

  getControl(controlName: string): AbstractControl | null {
    return this.inscripcionForm.get(controlName);
  }

  isInvalid(controlName: string): boolean {
    const control = this.getControl(controlName);
    return !!control && control.invalid && (control.dirty || control.touched);
  }

  hasError(controlName: string, errorKey: string): boolean {
    const control = this.getControl(controlName);
    return !!control && control.hasError(errorKey);
  }

  submit(): void {
    if (this.inscripcionForm.invalid) {
      this.inscripcionForm.markAllAsTouched();
      this.submissionSuccess.set(false);
      return;
    }

    const claveInstitucionControl = this.getControl('claveInstitucion');
    const claveInstitucionActual =
      claveInstitucionControl && typeof claveInstitucionControl.value === 'string'
        ? claveInstitucionControl.value
        : '';
    const payload = this.inscripcionForm.getRawValue();
    const guardadoEn =
      this.modoEdicion && this.registroEnEdicionIndex !== null
        ? this.registrosGuardados[this.registroEnEdicionIndex]?.guardadoEn
        : undefined;
    const registroFormateado = this.formatearRegistroGuardado({
      ...payload,
      guardadoEn: guardadoEn ?? new Date().toISOString(),
    });

    if (this.modoEdicion && this.registroEnEdicionIndex !== null) {
      const registrosActualizados = this.registrosGuardados.map((registro, indice) =>
        indice === this.registroEnEdicionIndex ? { ...registro, ...registroFormateado } : registro
      );
      this.registrosGuardados = registrosActualizados;
      this.mensajeGuardado = this.obtenerMensajeOperacion('actualizó');
    } else {
      this.registrosGuardados = [...this.registrosGuardados, registroFormateado];
      this.mensajeGuardado = this.obtenerMensajeOperacion('guardó');
    }

    this.actualizarAlmacenamiento(this.registrosGuardados);
    this.modoEdicion = false;
    this.registroEnEdicionIndex = null;
    this.submissionSuccess.set(true);
    const valoresPorDefecto = {
      ...this.getDefaultFormValue(),
      claveInstitucion: claveInstitucionActual,
    };
    this.inscripcionForm.reset(valoresPorDefecto, { emitEvent: false });
    this.aplicarConfiguracionPorModo();
  }

  editarRegistro(indice: number): void {
    const registro = this.registrosGuardados[indice];

    if (!registro) {
      return;
    }

    const { nombreCompleto, guardadoEn, ...valoresFormulario } =
      registro as Record<string, unknown>;

    const valoresNormalizados = this.normalizeDateFields(valoresFormulario, true);

    this.inscripcionForm.reset(this.getDefaultFormValue());
    this.aplicarConfiguracionPorModo();
    this.inscripcionForm.patchValue(valoresNormalizados);
    this.modoEdicion = true;
    this.registroEnEdicionIndex = indice;
    this.mensajeGuardado = '';
    this.submissionSuccess.set(false);
  }

  eliminarRegistro(indice: number): void {
    if (indice < 0 || indice >= this.registrosGuardados.length) {
      return;
    }

    const registrosActualizados = this.registrosGuardados.filter((_, i) => i !== indice);
    this.registrosGuardados = registrosActualizados;
    this.actualizarAlmacenamiento(registrosActualizados);

    if (this.registroEnEdicionIndex !== null) {
      if (this.registroEnEdicionIndex === indice) {
        this.modoEdicion = false;
        this.registroEnEdicionIndex = null;
        const claveControl = this.getControl('claveInstitucion');
        const claveActual =
          claveControl && typeof claveControl.value === 'string'
            ? claveControl.value
            : '';
        const valoresPorDefecto = {
          ...this.getDefaultFormValue(),
          claveInstitucion: claveActual,
        };
        this.inscripcionForm.reset(valoresPorDefecto, { emitEvent: false });
        this.aplicarConfiguracionPorModo();
      } else if (this.registroEnEdicionIndex > indice) {
        this.registroEnEdicionIndex -= 1;
      }
    }

    this.mensajeGuardado = this.obtenerMensajeOperacion('eliminó');
  }

  private configureUppercaseControls(controlNames: string[]): void {
    controlNames.forEach((name) => {
      const control = this.getControl(name);
      control?.valueChanges
        .pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe((value) => {
          if (typeof value === 'string' && value !== value.toUpperCase()) {
            control.setValue(value.toUpperCase(), { emitEvent: false });
          }
        });
    });
  }

  private aplicarConfiguracionPorModo(inicial = false): void {
    const flujoCtrl = this.getControl('flujo');

    if (this.modoBaja) {
      flujoCtrl?.enable({ emitEvent: false });
      flujoCtrl?.setValue('B', { emitEvent: false });
      this.habilitarCamposBaja();
    } else {
      flujoCtrl?.enable({ emitEvent: false });

      if (inicial) {
        flujoCtrl?.setValue('', { emitEvent: false });
      }

      this.deshabilitarCamposBaja();
    }

    this.actualizarValidadoresBaja(flujoCtrl?.value ?? null);
    this.reaplicarConfiguracionCamposActual();
  }

  private habilitarCamposBaja(): void {
    const tipoBajaCtrl = this.getControl('tipoBaja');
    const motivoBajaCtrl = this.getControl('motivoBaja');

    tipoBajaCtrl?.enable({ emitEvent: false });
    motivoBajaCtrl?.enable({ emitEvent: false });
  }

  private deshabilitarCamposBaja(): void {
    const tipoBajaCtrl = this.getControl('tipoBaja');
    const motivoBajaCtrl = this.getControl('motivoBaja');

    tipoBajaCtrl?.disable({ emitEvent: false });
    motivoBajaCtrl?.disable({ emitEvent: false });
    tipoBajaCtrl?.setValue('', { emitEvent: false });
    motivoBajaCtrl?.setValue('', { emitEvent: false });
  }

  private actualizarValidadoresBaja(flujoActual: string | null): void {
    const tipoBajaCtrl = this.getControl('tipoBaja');
    const motivoBajaCtrl = this.getControl('motivoBaja');
    const requiereCampos = this.modoBaja || flujoActual === 'B';
    const validators = requiereCampos ? [Validators.required] : [];

    tipoBajaCtrl?.setValidators(validators);
    motivoBajaCtrl?.setValidators(validators);

    if (!requiereCampos) {
      tipoBajaCtrl?.setValue('', { emitEvent: false });
      motivoBajaCtrl?.setValue('', { emitEvent: false });
    }

    tipoBajaCtrl?.updateValueAndValidity({ emitEvent: false });
    motivoBajaCtrl?.updateValueAndValidity({ emitEvent: false });
  }

  private obtenerStorageKey(): string {
    return this.modoBaja ? 'bajas' : 'inscripciones';
  }

  private obtenerFlujoInicial(): string {
    return this.modoBaja ? 'B' : '';
  }

  private capitalize(texto: string): string {
    if (!texto) {
      return texto;
    }

    const [primeraLetra, ...resto] = texto;
    return `${primeraLetra.toUpperCase()}${resto.join('')}`;
  }

  private obtenerMensajeOperacion(resultado: 'guardó' | 'actualizó' | 'eliminó'): string {
    return `La ${this.textoAccion} se ${resultado} correctamente.`;
  }

  private getDefaultFormValue(): Record<string, unknown> {
    return {
      flujo: this.obtenerFlujoInicial(),
      cicloEscolar: this.defaultCicloEscolar,
      anoEscolar: this.defaultAnoEscolar,
      nombreAlumno: '',
      primerApellido: '',
      segundoApellido: '',
      sexo: '',
      genero: '',
      curp: '',
      segmentoRaiz: '',
      fechaNacimiento: '',
      correoElectronico: '',
      numeroTelefonico: '',
      nacionalidad: '',
      paisNacimiento: '',
      entidadNacimiento: '',
      paisResidencia: '',
      entidadResidencia: '',
      tipoVialidad: '',
      nombreVialidad: '',
      numeroExterior: '',
      numeroInterior: '',
      codigoPostal: '',
      municipioResidencia: '',
      entidadDomicilio: '',
      paisProcedencia: '',
      entidadProcedencia: '',
      lenguaMaterna: '',
      segundaLengua: '',
      necesidadEducativa: '',
      tipoDiscapacidad: '',
      aptitudSobresaliente: '',
      claveInstitucion: '',
      claveEscuela: '',
      claveCarrera: '',
      creditosTotales: '',
      nivelEducativo: '',
      modalidadEducativa: '',
      opcionEducativa: '',
      numeroAcuerdoRvoe: '',
      fechaAcuerdoRvoe: '',
      turno: '',
      cicloInstitucional: '',
      gradoAvance: '',
      periodoModulo: '',
      duracionPeriodo: '',
      fechaInicioPeriodo: '',
      antecedenteAcademico: '',
      numeroMatricula: '',
      situacionAcademica: '',
      fechaInicioEstudios: '',
      origenEstudios: '',
      tipoBaja: '',
      motivoBaja: '',
    };
  }

  private actualizarAlmacenamiento(registros: InscripcionRegistro[]): void {
    if (typeof window === 'undefined' || !window.localStorage) {
      return;
    }

    window.localStorage.setItem(
      this.obtenerStorageKey(),
      JSON.stringify(registros)
    );
  }

  private cargarRegistrosGuardados(): void {
    if (typeof window === 'undefined' || !window.localStorage) {
      this.registrosGuardados = [];
      return;
    }

    const stored = window.localStorage.getItem(this.obtenerStorageKey());

    if (!stored) {
      this.registrosGuardados = [];
      return;
    }

    try {
      const registros = JSON.parse(stored);

      if (Array.isArray(registros)) {
        this.registrosGuardados = registros.map((registro) =>
          this.formatearRegistroGuardado(registro as Record<string, unknown>)
        );
      } else {
        this.registrosGuardados = [];
      }
    } catch {
      this.registrosGuardados = [];
    }
  }

  private formatearRegistroGuardado(registro: Record<string, unknown>): InscripcionRegistro {
    const normalizado = this.normalizeDateFields(registro);
    const guardadoEn =
      typeof normalizado['guardadoEn'] === 'string' && normalizado['guardadoEn']
        ? (normalizado['guardadoEn'] as string)
        : new Date().toISOString();

    return {
      ...normalizado,
      nombreCompleto: this.obtenerNombreCompleto(normalizado),
      guardadoEn,
    } as InscripcionRegistro;
  }

  private obtenerNombreCompleto(registro: Record<string, unknown>): string {
    const partes = [registro['nombreAlumno'], registro['primerApellido'], registro['segundoApellido']]
      .map((valor) => (typeof valor === 'string' ? valor.trim() : ''))
      .filter((valor) => valor.length > 0);

    return partes.join(' ');
  }

  private normalizeDateFields(
    values: Record<string, unknown>,
    strict = false
  ): Record<string, unknown> {
    const normalized: Record<string, unknown> = { ...values };

    for (const field of this.dateFieldNames) {
      const rawValue = values[field];

      if (typeof rawValue !== 'string') {
        if (strict) {
          normalized[field] = '';
        }
        continue;
      }

      const trimmed = rawValue.trim();

      if (trimmed.length === 0) {
        if (strict) {
          normalized[field] = '';
        }
        continue;
      }

      const isoValue = this.toIsoDateString(trimmed);

      if (isoValue) {
        normalized[field] = isoValue;
      } else if (strict) {
        normalized[field] = '';
      }
    }

    return normalized;
  }

  private toIsoDateString(value: string): string | null {
    const parsed = this.parseDate(value);
    return parsed ? this.formatDateToIso(parsed) : null;
  }

  private configureBajaRequirements(): void {
    this.getControl('flujo')?.valueChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((valor) => {
        this.actualizarValidadoresBaja(typeof valor === 'string' ? valor : null);
      });
  }

  private configureNecesidadEducativaDependencies(): void {
    const control = this.getControl('necesidadEducativa');

    control?.valueChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => this.actualizarDependenciasNecesidad());

    this.actualizarDependenciasNecesidad();
  }

  private actualizarDependenciasNecesidad(): void {
    const control = this.getControl('necesidadEducativa');
    const valor = control?.value;
    const clave = typeof valor === 'string' ? valor.trim() : '';

    this.actualizarCampoDependiente('tipoDiscapacidad', clave === '01');
    this.actualizarCampoDependiente('aptitudSobresaliente', clave === '02');
  }

  private actualizarCampoDependiente(
    campo: 'tipoDiscapacidad' | 'aptitudSobresaliente',
    requerido: boolean
  ): void {
    const control = this.getControl(campo);

    if (!control) {
      return;
    }

    const visible = this.esCampoVisible(campo);
    const debeHabilitar = requerido && visible;

    if (debeHabilitar) {
      control.enable({ emitEvent: false });
      control.addValidators(Validators.required);
    } else {
      control.removeValidators(Validators.required);
      control.setValue('', { emitEvent: false });
      control.disable({ emitEvent: false });
    }

    control.updateValueAndValidity({ emitEvent: false });
  }

  private configureFlujoNavigation(): void {
    const flujoCtrl = this.getControl('flujo');

    flujoCtrl?.valueChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((valor) => {
        const flujo = typeof valor === 'string' ? valor : '';

        if (!this.modoBaja && flujo === 'B') {
          this.router.navigate(['/baja']);
        }

        if (this.modoBaja && (flujo === 'I' || flujo === 'R')) {
          this.router.navigate(['/inscripcion']);
        }
      });
  }

  private resetSuccessOnChanges(): void {
    this.inscripcionForm.valueChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => {
        if (this.submissionSuccess()) {
          this.submissionSuccess.set(false);
        }
      });
  }

  private cicloEscolarValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string | null;

      if (!value) {
        return null;
      }

      if (!this.cicloEscolarRegex.test(value)) {
        return { cicloEscolarFormato: true };
      }

      const [inicioStr, finStr] = value.split('-');
      const inicio = Number(inicioStr);
      const fin = Number(finStr);

      if (!Number.isInteger(inicio) || !Number.isInteger(fin)) {
        return { cicloEscolarFormato: true };
      }

      if (fin !== inicio + 1) {
        return { cicloEscolarSecuencia: true };
      }

      return null;
    };
  }

  private getCurrentSchoolCycle(): string {
    const today = new Date();
    const currentYear = today.getFullYear();
    const startYear = today.getMonth() >= 6 ? currentYear : currentYear - 1;
    const endYear = startYear + 1;

    return `${startYear}-${endYear}`;
  }

  private getCycleStartYearString(cycle: string): string {
    const startYear = this.getCycleStartYear(cycle);
    return typeof startYear === 'number' ? String(startYear) : '';
  }

  private getCycleStartYear(cycle: string): number | null {
    if (!cycle || !this.cicloEscolarRegex.test(cycle)) {
      return null;
    }

    const [inicioStr] = cycle.split('-');
    const inicio = Number(inicioStr);

    return Number.isInteger(inicio) ? inicio : null;
  }

  private cctCatalogValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = (control.value as string | null) || '';
      if (!value) {
        return null;
      }

      const normalized = value.toUpperCase();
      const exists = this.cctCatalog.some(
        (entry) => entry.cct.toUpperCase() === normalized
      );

      return exists ? null : { cctCatalog: true };
    };
  }

  private optionalPatternValidator(pattern: RegExp): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string | null;
      if (!value) {
        return null;
      }
      return pattern.test(value) ? null : { pattern: true };
    };
  }

  private allowedValuesValidator(allowed: string[]): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string | null;

      if (!value) {
        return null;
      }

      return allowed.includes(value) ? null : { invalidOption: true };
    };
  }

  private curpSegmentoConsistencyValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const curp = (group.get('curp')?.value as string | undefined) || '';
      const segmento =
        (group.get('segmentoRaiz')?.value as string | undefined) || '';

      if (!curp || !segmento) {
        return null;
      }

      if (curp.slice(0, 16) !== segmento) {
        return { segmentoCurpMismatch: true };
      }

      return null;
    };
  }

  private segundaLenguaValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const lenguaMaterna = group.get('lenguaMaterna');
      const segundaLengua = group.get('segundaLengua');
      if (!lenguaMaterna || !segundaLengua) {
        return null;
      }

      const valueA = lenguaMaterna.value as string | null;
      const valueB = segundaLengua.value as string | null;

      const errors = { ...(segundaLengua.errors || {}) };
      delete errors['sameLanguage'];

      if (valueA && valueB && valueA === valueB) {
        segundaLengua.setErrors({ ...errors, sameLanguage: true });
        return { sameLanguage: true };
      }

      if (Object.keys(errors).length === 0) {
        segundaLengua.setErrors(null);
      } else {
        segundaLengua.setErrors(errors);
      }

      return null;
    };
  }

  private flujoGradoValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const flujoCtrl = group.get('flujo');
      const gradoCtrl = group.get('gradoAvance');

      if (!flujoCtrl || !gradoCtrl) {
        return null;
      }

      const errorKey = 'flujoIncompatible';
      const flujo = flujoCtrl.value as string | null;
      const gradoRaw = gradoCtrl.value as string | number | null;

      const gradoStr =
        typeof gradoRaw === 'string' ? gradoRaw.trim() : String(gradoRaw ?? '');

      if (!flujo || !['I', 'R', 'B'].includes(flujo)) {
        this.toggleControlError(flujoCtrl, errorKey, false);
        this.toggleControlError(gradoCtrl, errorKey, false);
        return null;
      }

      if (!gradoStr) {
        this.toggleControlError(flujoCtrl, errorKey, false);
        this.toggleControlError(gradoCtrl, errorKey, false);
        return null;
      }

      const gradoNumber = Number(gradoStr);

      if (!Number.isFinite(gradoNumber)) {
        this.toggleControlError(flujoCtrl, errorKey, false);
        this.toggleControlError(gradoCtrl, errorKey, false);
        return null;
      }

      const isInvalidForInscripcion = flujo === 'I' && gradoNumber !== 1;
      const isInvalidForReinscripcion = flujo === 'R' && gradoNumber <= 1;
      const shouldSetError = isInvalidForInscripcion || isInvalidForReinscripcion;

      this.toggleControlError(flujoCtrl, errorKey, shouldSetError);
      this.toggleControlError(gradoCtrl, errorKey, shouldSetError);

      return shouldSetError ? { [errorKey]: true } : null;
    };
  }

  private anoEscolarPeriodoValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const anoCtrl = group.get('anoEscolar');
      const cicloCtrl = group.get('cicloEscolar');

      if (!anoCtrl || !cicloCtrl) {
        return null;
      }

      const errorKey = 'anoFueraDeCiclo';
      const anoValue = (anoCtrl.value as string | null) || '';
      const cicloValue = (cicloCtrl.value as string | null) || '';

      const hasBasicErrors =
        anoCtrl.hasError('required') || anoCtrl.hasError('pattern');

      if (!anoValue || hasBasicErrors) {
        this.toggleControlError(anoCtrl, errorKey, false);
        return null;
      }

      const cicloValido = this.getCycleStartYear(cicloValue);
      const anoNumero = Number(anoValue);

      if (!cicloValido || !Number.isInteger(anoNumero)) {
        this.toggleControlError(anoCtrl, errorKey, false);
        return null;
      }

      const shouldSetError = anoNumero !== cicloValido;
      this.toggleControlError(anoCtrl, errorKey, shouldSetError);

      return shouldSetError ? { [errorKey]: true } : null;
    };
  }

  private toggleControlError(
    control: AbstractControl | null,
    errorKey: string,
    shouldSet: boolean
  ): void {
    if (!control) {
      return;
    }

    const currentErrors = control.errors || {};

    if (shouldSet) {
      if (!currentErrors[errorKey]) {
        control.setErrors({ ...currentErrors, [errorKey]: true });
      }
      return;
    }

    if (!currentErrors[errorKey]) {
      return;
    }

    const { [errorKey]: _removed, ...rest } = currentErrors;
    control.setErrors(Object.keys(rest).length ? rest : null);
  }

  private dateFormatValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string | null;
      if (!value) {
        return null;
      }

      const parsed = this.parseDate(value);
      return parsed ? null : { dateFormat: true };
    };
  }

  private notFutureDateValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string | null;
      if (!value) {
        return null;
      }

      const parsed = this.parseDate(value);
      if (!parsed) {
        return null;
      }

      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (parsed > today) {
        return { futureDate: true };
      }

      return null;
    };
  }

  private formatDateToIso(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  private parseDate(value: string | null): Date | null {
    if (!value) {
      return null;
    }

    let day: number;
    let month: number;
    let year: number;

    if (this.slashDateRegex.test(value)) {
      const [dayStr, monthStr, yearStr] = value.split('/');
      day = Number(dayStr);
      month = Number(monthStr);
      year = Number(yearStr);
    } else if (this.isoDateRegex.test(value)) {
      const [yearStr, monthStr, dayStr] = value.split('-');
      year = Number(yearStr);
      month = Number(monthStr);
      day = Number(dayStr);
    } else {
      return null;
    }

    const date = new Date(year, month - 1, day);

    if (
      date.getFullYear() !== year ||
      date.getMonth() !== month - 1 ||
      date.getDate() !== day
    ) {
      return null;
    }

    return date;
  }
}
