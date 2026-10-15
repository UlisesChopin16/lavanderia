enum ColumnPreciosName {
  id(title: 'ID'),
  nombre(title: 'Nombre del Concepto'),
  categoria(title: 'Categoría'),
  sizeRopa(title: 'Tamaño'),
  tipoUnidad(title: 'Unidad'),
  diasEntrega(title: 'Días de Entrega'),
  importe(title: '\$ Importe'),
  estatus(title: 'Estatus'),
  fechaCreacion(title: 'Fecha de Creación'),
  fechaEliminacion(title: 'Fecha de Eliminación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String title;

  const ColumnPreciosName({
    required this.title,
  });
}