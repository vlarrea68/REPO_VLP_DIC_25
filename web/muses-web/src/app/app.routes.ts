import { Routes } from '@angular/router';
import { InicioComponent } from './components/inicio/inicio.component';
import { InscripcionComponent } from './components/inscripcion/inscripcion.component';
import { BajaComponent } from './components/baja/baja.component';
import { CargaMasivaComponent } from './components/carga-masiva/carga-masiva.component';
import { CargaMasivaDetalleComponent } from './components/carga-masiva-detalle/carga-masiva-detalle.component';
import { ConfiguracionInstitucionesComponent } from './components/configuracion-instituciones/configuracion-instituciones.component';

export const routes: Routes = [
  {
    path: '',
    component: InicioComponent,
    pathMatch: 'full',
  },
  {
    path: 'inicio',
    component: InicioComponent,
    pathMatch: 'full',
  },
  {
    path: 'inscripcion',
    component: InscripcionComponent,
    pathMatch: 'full',
  },
  {
    path: 'baja',
    component: BajaComponent,
    pathMatch: 'full',
  },
  {
    path: 'carga-masiva',
    component: CargaMasivaComponent,
    pathMatch: 'full',
  },
  {
    path: 'carga-masiva/detalle',
    component: CargaMasivaDetalleComponent,
  },
  {
    path: 'configuracion-instituciones',
    component: ConfiguracionInstitucionesComponent,
  },
  /* {
    path: 'inscripcion-masiva',
    component: InscripcionMasivaComponent,
    pathMatch: 'full',
  },
  {
    path: 'inscripciones/:id/editar',
    component: EditarRegistroComponent,
  }, */
];
