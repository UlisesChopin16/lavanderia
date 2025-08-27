enum ColumnPreciosName {
  id(title: 'ID'),
  nombre(title: 'Nombre del Concepto'),
  categoria(title: 'Categoría'),
  sizeRopa(title: 'Tamaño'),
  tipoUnidad(title: 'Unidad'),
  diasEntrega(title: 'Días de Entrega'),
  importe(title: 'Importe'),
  estatus(title: 'Estatus'),
  fechaCreacion(title: 'Fecha de Creación'),
  fechaEliminacion(title: 'Fecha de Eliminación');
  // fechaActualizacion(value: 'fecha_actualizacion', title: 'Fecha de Actualización');

  final String title;

  const ColumnPreciosName({
    required this.title,
  });
}

// @DataClassName('PreciosConceptosEntry')
// class PreciosConceptos extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get itemId => integer().references(ItemServicio, #id)();
//   IntColumn get sizeRopaId => integer().references(SizesRopa, #id)();
//   IntColumn get diasEntrega => integer()(); // Días de entrega para este item en esta categoría
//   TextColumn get tipoUnidad => text()(); // Ej. "Kg" o "pieza"
//   RealColumn get importe => real()();
//   DateTimeColumn get fechaCreacion => dateTime()();
//   DateTimeColumn get fechaActualizacion => dateTime().nullable()();
//   DateTimeColumn get fechaEliminacion => dateTime().nullable()();
// }