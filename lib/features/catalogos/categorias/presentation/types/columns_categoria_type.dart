enum ColumnsCategoriaType {
  id(title: 'ID'),
  nombre(title: 'Nombre'),
  estatus(title: 'Estatus'),
  diasEntrega(title: 'Días de Entrega'),
  fechaCreacion(title: 'Fecha de Creación'),
  fechaEliminacion(title: 'Fecha de Eliminación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String title;

  const ColumnsCategoriaType({
    required this.title,
  });
}