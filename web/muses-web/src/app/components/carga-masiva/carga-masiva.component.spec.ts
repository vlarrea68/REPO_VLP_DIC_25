import { ComponentFixture, TestBed } from '@angular/core/testing';
import { CargaMasivaComponent } from './carga-masiva.component';
import {
  CargaMasivaService,
  EventoCargaMasiva,
} from '../../services/carga-masiva.service';
import { of, Subscription } from 'rxjs';
import { provideRouter, Router } from '@angular/router';

class CargaMasivaServiceMock {
  procesarArchivo = jasmine
    .createSpy('procesarArchivo')
    .and.returnValue(of(this.crearEventoCompletado()));

  generarPlantillaEjemplo = jasmine
    .createSpy('generarPlantillaEjemplo')
    .and.returnValue('folio_control,flujo\nFOLIO-0001,I');

  generarCsvErrores = jasmine
    .createSpy('generarCsvErrores')
    .and.returnValue('linea,mensajes,contenido_original\n2,"CURP inválida",""');

  establecerRegistroSeleccionado = jasmine.createSpy(
    'establecerRegistroSeleccionado',
  );

  obtenerEncabezadosEsperados = jasmine
    .createSpy('obtenerEncabezadosEsperados')
    .and.returnValue([
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
    ]);

  private crearEventoCompletado(): EventoCargaMasiva {
    const registros = [
      {
        folioControl: 'FOLIO-0001',
        flujo: 'I',
        cicloEscolar: '2024-2025',
        curp: 'CURP010203HDFRRL01',
        primerApellido: 'García',
        segundoApellido: 'Pérez',
        nombre: 'María',
        fechaNacimiento: '2006-08-17',
        grado: '5',
        grupo: 'A',
        correoElectronico: 'maria@example.edu.mx',
      },
      {
        folioControl: 'FOLIO-0002',
        flujo: 'R',
        cicloEscolar: '2024-2025',
        curp: 'CURP010203HDFRRL02',
        primerApellido: 'López',
        segundoApellido: '',
        nombre: 'Juan',
        fechaNacimiento: '2005-01-05',
        grado: '6',
        grupo: 'B',
        correoElectronico: '',
      },
    ];

    return {
      estado: 'completado',
      porcentajeAvance: 100,
      registrosProcesados: 2,
      totalRegistros: 2,
      nuevosRegistros: registros,
      resumen: {
        totalRegistros: 2,
        registrosValidos: registros,
        errores: [],
      },
    };
  }
}

function crearArchivoDummy(nombre: string): File {
  const contenido = 'folio_control,flujo\nFOLIO-0001,I';
  return new File([contenido], nombre, { type: 'text/csv' });
}

describe('CargaMasivaComponent', () => {
  let component: CargaMasivaComponent;
  let fixture: ComponentFixture<CargaMasivaComponent>;
  let servicio: CargaMasivaServiceMock;
  let router: Router;
  let storageStore: Record<string, string>;

  beforeEach(async () => {
    servicio = new CargaMasivaServiceMock();

    await TestBed.configureTestingModule({
      imports: [CargaMasivaComponent],
      providers: [
        provideRouter([]),
        { provide: CargaMasivaService, useValue: servicio },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(CargaMasivaComponent);
    component = fixture.componentInstance;
    router = TestBed.inject(Router);
    spyOn(router, 'navigate').and.returnValue(Promise.resolve(true));
    storageStore = {};
    spyOn(window.localStorage, 'getItem').and.callFake((key: string) =>
      Object.prototype.hasOwnProperty.call(storageStore, key)
        ? storageStore[key]
        : null,
    );
    spyOn(window.localStorage, 'setItem').and.callFake(
      (key: string, value: string) => {
        storageStore[key] = value;
      },
    );
    fixture.detectChanges();
  });

  it('debería crearse el componente', () => {
    expect(component).toBeTruthy();
  });

  it('debería deshabilitar el botón de procesar cuando no hay archivo seleccionado', () => {
    const boton = fixture.nativeElement.querySelector(
      'button[type="submit"]',
    ) as HTMLButtonElement;
    expect(boton.disabled).toBeTrue();
  });

  it('debería invocar al servicio al procesar el archivo seleccionado', () => {
    const archivo = crearArchivoDummy('prueba.csv');
    component.onArchivoSeleccionado({
      target: { files: [archivo] },
    } as unknown as Event);
    component.onSubmit(new Event('submit'));

    expect(servicio.procesarArchivo).toHaveBeenCalledWith(archivo);
    expect(component.registros().length).toBe(2);
  });

  it('debería almacenar los registros procesados en el almacenamiento local', () => {
    const archivo = crearArchivoDummy('procesar.csv');
    component.onArchivoSeleccionado({
      target: { files: [archivo] },
    } as unknown as Event);
    component.onSubmit(new Event('submit'));

    const stored = storageStore['cargaMasivaRegistros'];
    expect(stored).toBeTruthy();
    const registros = JSON.parse(stored) as unknown[];
    expect(registros.length).toBe(2);
  });

  it('debería restaurar los registros almacenados al inicializar', () => {
    const registrosPrevios =
      servicio['crearEventoCompletado']().nuevosRegistros ?? [];
    storageStore['cargaMasivaRegistros'] = JSON.stringify(registrosPrevios);

    const nuevoFixture = TestBed.createComponent(CargaMasivaComponent);
    const nuevoComponent = nuevoFixture.componentInstance;
    nuevoFixture.detectChanges();

    expect(nuevoComponent.registros().length).toBe(registrosPrevios.length);
    nuevoFixture.destroy();
    storageStore = {};
  });

  it('debería generar la plantilla desde el servicio', () => {
    const descargarSpy = spyOn<any>(component, 'descargarArchivo');
    component.descargarPlantilla();
    expect(servicio.generarPlantillaEjemplo).toHaveBeenCalled();
    expect(descargarSpy).toHaveBeenCalled();
  });

  it('debería navegar al detalle con el registro seleccionado', () => {
    const registro = servicio['crearEventoCompletado']().nuevosRegistros?.[0]!;
    component.verDetalle(registro);

    expect(servicio.establecerRegistroSeleccionado).toHaveBeenCalledWith(
      registro,
    );
    expect(router.navigate).toHaveBeenCalledWith(['carga-masiva', 'detalle'], {
      state: { registro },
    });
  });

  it('debería permitir abrir y cerrar el modal de requisitos', () => {
    expect(component.mostrarModalRequisitos()).toBeFalse();
    component.abrirModalRequisitos();
    expect(component.mostrarModalRequisitos()).toBeTrue();
    component.cerrarModalRequisitos();
    expect(component.mostrarModalRequisitos()).toBeFalse();
  });

  it('debería permitir limpiar los registros guardados manualmente', () => {
    const archivo = crearArchivoDummy('manual.csv');
    component.onArchivoSeleccionado({
      target: { files: [archivo] },
    } as unknown as Event);
    component.onSubmit(new Event('submit'));

    expect(component.registros().length).toBe(2);

    component.limpiarRegistrosGuardados();

    expect(component.registros().length).toBe(0);
    expect(component.eventoActual()).toBeNull();
  });

  it('debería filtrar registros por término y flujo seleccionados', () => {
    const registros = [
      {
        folioControl: 'FOLIO-0001',
        flujo: 'I',
        cicloEscolar: '2024-2025',
        curp: 'CURP0001',
        primerApellido: 'García',
        segundoApellido: 'Hernández',
        nombre: 'María',
        fechaNacimiento: '2006-01-01',
        grado: '5',
        grupo: 'A',
        correoElectronico: 'maria@example.edu.mx',
      },
      {
        folioControl: 'FOLIO-0002',
        flujo: 'R',
        cicloEscolar: '2024-2025',
        curp: 'CURP0002',
        primerApellido: 'López',
        segundoApellido: 'Santos',
        nombre: 'Juan',
        fechaNacimiento: '2005-01-01',
        grado: '6',
        grupo: 'B',
        correoElectronico: 'juan@example.edu.mx',
      },
      {
        folioControl: 'FOLIO-0003',
        flujo: 'R',
        cicloEscolar: '2024-2025',
        curp: 'CURP0003',
        primerApellido: 'Ramírez',
        segundoApellido: 'Pérez',
        nombre: 'Ana',
        fechaNacimiento: '2007-05-03',
        grado: '4',
        grupo: 'C',
        correoElectronico: 'ana@example.edu.mx',
      },
    ];

    (component as any).registrosAcumulados.set(registros);

    component.onFiltroFlujoChange('R');
    expect(component.registrosFiltrados().length).toBe(2);

    component.onBusquedaChange('ana');
    expect(component.registrosFiltrados().length).toBe(1);
    expect(component.registrosFiltrados()[0].nombre).toBe('Ana');

    component.onFiltroFlujoChange('todos');
    component.onBusquedaChange('CURP0001');
    expect(component.registrosFiltrados().length).toBe(1);
    expect(component.registrosFiltrados()[0].curp).toBe('CURP0001');
  });

  it('debería paginar los registros según el tamaño de página seleccionado', () => {
    const registros = Array.from({ length: 35 }, (_, indice) => ({
      folioControl: `FOLIO-${indice.toString().padStart(4, '0')}`,
      flujo: indice % 2 === 0 ? 'I' : 'R',
      cicloEscolar: '2024-2025',
      curp: `CURP${indice.toString().padStart(4, '0')}`,
      primerApellido: 'Apellido',
      segundoApellido: 'Segundo',
      nombre: `Nombre ${indice}`,
      fechaNacimiento: '2006-01-01',
      grado: '5',
      grupo: 'A',
      correoElectronico: `correo${indice}@example.edu.mx`,
    }));

    (component as any).registrosAcumulados.set(registros);

    component.onTamanoPaginaChange('10');
    expect(component.registrosPaginados().length).toBe(10);
    expect(component.totalPaginas()).toBe(4);

    component.paginaSiguiente();
    expect(component.paginaActual()).toBe(2);
    expect(component.registrosPaginados()[0].folioControl).toBe('FOLIO-0010');

    component.irAPagina(4);
    expect(component.paginaActual()).toBe(4);
    expect(component.registrosPaginados().length).toBe(5);
  });

  it('debería restablecer el formulario y filtros al limpiar la selección', () => {
    const archivo = crearArchivoDummy('limpiar.csv');
    component.onArchivoSeleccionado({
      target: { files: [archivo] },
    } as unknown as Event);
    component.onBusquedaChange('folio');
    component.onFiltroFlujoChange('I');
    component.onTamanoPaginaChange('10');

    component.limpiarSeleccion();

    expect(component.formulario.value.archivo).toBeNull();
    expect(component.formulario.value.reemplazarExistentes).toBeTrue();
    expect(component.terminoBusqueda()).toBe('');
    expect(component.flujoSeleccionado()).toBe('todos');
    expect(component.tamanoPaginaActual()).toBe(25);
    expect(component.paginaActual()).toBe(1);
    expect(component.mensajeDeError()).toBeNull();
  });

  it('debería cancelar el procesamiento activo y mostrar el mensaje correspondiente', () => {
    const sub = new (class extends Subscription {
      override unsubscribe(): void {
        super.unsubscribe();
      }
    })();

    const cancelarSpy = spyOn(sub, 'unsubscribe').and.callThrough();

    (component as unknown as { procesamientoSub: Subscription | null }).procesamientoSub = sub;
    component.eventoActual.set({
      estado: 'procesando',
      porcentajeAvance: 50,
      registrosProcesados: 100,
      totalRegistros: 200,
    });

    component.cancelarProcesamiento();

    expect(cancelarSpy).toHaveBeenCalled();
    expect(component.estado()).toBe('cancelado');
    expect(component.mensajeDeProgreso()).toBe('Procesamiento cancelado por el usuario.');
  });

  it('debería manejar datos corruptos en localStorage mostrando un mensaje de error', () => {
    storageStore['cargaMasivaRegistros'] = 'no-json';

    const nuevoFixture = TestBed.createComponent(CargaMasivaComponent);
    const nuevoComponent = nuevoFixture.componentInstance;
    nuevoFixture.detectChanges();

    expect(nuevoComponent.registros().length).toBe(0);
    expect(nuevoComponent.mensajeDeError()).toContain('No fue posible recuperar los registros guardados');

    nuevoFixture.destroy();
    delete storageStore['cargaMasivaRegistros'];
  });

  it('debería informar cuando no hay espacio disponible en localStorage', () => {
    (window.localStorage.setItem as jasmine.Spy).and.callFake(() => {
      throw new DOMException('Quota exceeded', 'QuotaExceededError');
    });

    const archivo = crearArchivoDummy('sin-espacio.csv');
    component.onArchivoSeleccionado({
      target: { files: [archivo] },
    } as unknown as Event);
    component.onSubmit(new Event('submit'));

    expect(component.mensajeDeError()).toContain('No fue posible guardar los registros en el navegador');
  });
});
