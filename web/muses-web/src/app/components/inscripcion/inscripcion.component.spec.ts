import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { InscripcionComponent } from './inscripcion.component';

describe('InscripcionComponent', () => {
  let component: InscripcionComponent;
  let fixture: ComponentFixture<InscripcionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RouterTestingModule, InscripcionComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(InscripcionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should keep baja fields disabled by default', () => {
    const tipoBajaCtrl = component.inscripcionForm.get('tipoBaja');
    const motivoBajaCtrl = component.inscripcionForm.get('motivoBaja');

    expect(tipoBajaCtrl?.disabled).toBeTrue();
    expect(motivoBajaCtrl?.disabled).toBeTrue();
  });

  it('should enable baja fields when modoBaja is true', () => {
    const bajaFixture = TestBed.createComponent(InscripcionComponent);
    const bajaComponent = bajaFixture.componentInstance;
    bajaComponent.modoBaja = true;

    bajaFixture.detectChanges();

    const tipoBajaCtrl = bajaComponent.inscripcionForm.get('tipoBaja');
    const motivoBajaCtrl = bajaComponent.inscripcionForm.get('motivoBaja');

    expect(tipoBajaCtrl?.enabled).toBeTrue();
    expect(motivoBajaCtrl?.enabled).toBeTrue();
  });

  it('should navigate to baja when flujo changes to baja in modo inscripción', () => {
    const router = TestBed.inject(Router);
    const navigateSpy = spyOn(router, 'navigate');
    const flujoCtrl = component.inscripcionForm.get('flujo');

    flujoCtrl?.setValue('B');

    expect(navigateSpy).toHaveBeenCalledWith(['/baja']);
  });

  it('should navigate to inscripción when flujo cambia a inscripción en modo baja', () => {
    const router = TestBed.inject(Router);
    const navigateSpy = spyOn(router, 'navigate');
    const bajaFixture = TestBed.createComponent(InscripcionComponent);
    const bajaComponent = bajaFixture.componentInstance;
    bajaComponent.modoBaja = true;

    bajaFixture.detectChanges();

    const flujoCtrl = bajaComponent.inscripcionForm.get('flujo');
    flujoCtrl?.setValue('I');

    expect(navigateSpy).toHaveBeenCalledWith(['/inscripcion']);

    navigateSpy.calls.reset();

    flujoCtrl?.setValue('R');

    expect(navigateSpy).toHaveBeenCalledWith(['/inscripcion']);
  });
});
