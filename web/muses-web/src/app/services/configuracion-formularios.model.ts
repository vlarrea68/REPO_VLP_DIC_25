export interface CampoFormularioConfiguracion {
  readonly visible?: boolean;
  readonly obligatorio?: boolean;
  readonly etiqueta?: string;
}

export interface InstitucionFormularioConfiguracion {
  readonly clave: string;
  readonly nombre: string;
  readonly descripcion?: string;
  readonly campos: Record<string, CampoFormularioConfiguracion>;
}

export interface InstitucionFormularioResumen {
  readonly clave: string;
  readonly nombre: string;
  readonly descripcion?: string;
}
