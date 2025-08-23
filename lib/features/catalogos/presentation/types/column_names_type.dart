enum ColumnNamesType {
  id(title: 'ID'),
  nombre(title: 'Nombre'),
  estatus(title: 'Estatus'),
  fechaCreacion(title: 'Fecha de Creación'),
  fechaEliminacion(title: 'Fecha de Eliminación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String title;

  const ColumnNamesType({
    required this.title,
  });
}
