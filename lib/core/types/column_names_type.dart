enum ColumnNamesType {
  id(value: 'id', title: 'ID'),
  nombre(value: 'nombre', title: 'Nombre'),
  estatus(value: 'estatus', title: 'Estatus'),
  fechaCreacion(value: 'fecha_creacion', title: 'Fecha de Creación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String value;
  final String title;

  const ColumnNamesType({
    required this.value,
    required this.title,
  });
}
