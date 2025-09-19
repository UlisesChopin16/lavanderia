enum ColumnsOrdenesNames {
  id(title: 'ID'),
  folio(title: 'Folio'),
  cliente(title: 'Cliente'),
  estatus(title: 'Estatus'),
  metodoPago(title: 'Método de Pago'),
  restante(title: 'Restante'),
  total(title: 'Total'),
  fechaCreacion(title: 'Fecha de Creación'),
  fechaCierre(title: 'Fecha de Cierre');

  final String title;

  const ColumnsOrdenesNames({
    required this.title,
  });
}

// class OrdenServicio extends Table {
//   IntColumn get id => integer().autoIncrement()();                     // ID de la orden
//   IntColumn get clienteId => integer().references(Cliente, #id)();
//   TextColumn get folio => text()();           // Formato: "2023-08-0001"
//   TextColumn get descripcion => text().nullable()();
//   TextColumn get estatus => text()();                // "En curso" o "Cerrada"
//   TextColumn get metodoPago => text()();             // "Efectivo", "Tarjeta", "Transferencia"
//   RealColumn get adelantoPago => real().nullable()();
//   RealColumn get total => real()();
//   RealColumn get restante => real()();
//   DateTimeColumn get fechaCierre => dateTime()();
//   DateTimeColumn get fechaCreacion => dateTime()();
// }