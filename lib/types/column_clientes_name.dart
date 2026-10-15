enum ColumnClientesName {
  id(title: 'ID'),
  nombre(title: 'Nombre(s)'),
  apellido(title: 'Apellido(s)'),
  telefono(title: 'Teléfono'),
  correo(title: 'Correo'),

  fechaCreacion(title: 'Fecha de Creación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String title;

  const ColumnClientesName({
    required this.title,
  });
}
