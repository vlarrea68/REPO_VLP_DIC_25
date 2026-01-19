import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { CargaMasivaDetalleComponent } from './carga-masiva-detalle.component';
import {
  CargaMasivaService,
  InscripcionMasivaRegistro,
} from '../../services/carga-masiva.service';

class CargaMasivaServiceMock {
  private registro: InscripcionMasivaRegistro | null = null;

  obtenerRegistroSeleccionado = jasmine
    .createSpy('obtenerRegistroSeleccionado')
    .and.callFake(() => this.registro);

  establecerRegistroSeleccionado = jasmine
    .createSpy('establecerRegistroSeleccionado')
    .and.callFake((registro: InscripcionMasivaRegistro | null) => {
      this.registro = registro;
    });

  setRegistro(registro: InscripcionMasivaRegistro | null): void {
    this.registro = registro;
  }
}

const crearRegistro = (): InscripcionMasivaRegistro => ({
  folioControl: 'FOLIO-0010',
  flujo: 'I',
  cicloEscolar: '2024-2025',
  curp: 'CURP010203HDFRRL10',
  primerApellido: 'Martínez',
  segundoApellido: 'Hernández',
  nombre: 'Ana Sofía',
  fechaNacimiento: '2007-05-20',
  grado: '6',
  grupo: 'B',
  correoElectronico: 'ana@example.edu.mx',
});

describe('CargaMasivaDetalleComponent', () => {
  let servicio: CargaMasivaServiceMock;

  beforeEach(async () => {
    servicio = new CargaMasivaServiceMock();

    await TestBed.configureTestingModule({
      imports: [CargaMasivaDetalleComponent],
      providers: [provideRouter([]), { provide: CargaMasivaService, useValue: servicio }],
    }).compileComponents();
  });

  it('debería mostrar los datos del registro recuperado', () => {
    servicio.setRegistro(crearRegistro());
    const fixture: ComponentFixture<CargaMasivaDetalleComponent> =
      TestBed.createComponent(CargaMasivaDetalleComponent);
    fixture.detectChanges();

    const elementos = fixture.nativeElement.querySelectorAll(
      '.detalle-registro__fila dd'
    ) as NodeListOf<HTMLElement>;
    expect(elementos.length).toBeGreaterThan(0);
    expect(Array.from(elementos).some((item) => item.textContent?.includes('FOLIO-0010'))).toBeTrue();
    expect(servicio.establecerRegistroSeleccionado).toHaveBeenCalled();
  });

  it('debería mostrar el mensaje de ausencia cuando no hay registro', () => {
    servicio.setRegistro(null);
    const fixture: ComponentFixture<CargaMasivaDetalleComponent> =
      TestBed.createComponent(CargaMasivaDetalleComponent);
    fixture.detectChanges();

    const mensaje = fixture.nativeElement.querySelector(
      '.detalle-registro__tarjeta--vacia'
    ) as HTMLElement | null;
    expect(mensaje?.textContent).toContain('No se encontró información');
  });

  it('debería regresar a la vista de carga masiva al invocar regresar', () => {
    servicio.setRegistro(crearRegistro());
    const fixture: ComponentFixture<CargaMasivaDetalleComponent> =
      TestBed.createComponent(CargaMasivaDetalleComponent);
    const router = TestBed.inject(Router);
    spyOn(router, 'navigate').and.returnValue(Promise.resolve(true));

    fixture.detectChanges();
    fixture.componentInstance.regresar();

    expect(router.navigate).toHaveBeenCalledWith(['carga-masiva']);
  });
});
