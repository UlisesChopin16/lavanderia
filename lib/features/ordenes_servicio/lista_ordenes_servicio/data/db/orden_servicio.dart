import 'package:drift/drift.dart';
import '../../../../catalogos/clientes/data/db/cliente.dart';

@DataClassName('OrdenServicioEntry')
class OrdenServicio extends Table {
  IntColumn get id => integer().autoIncrement()();                     // ID de la orden
  IntColumn get clienteId => integer().references(Cliente, #id)();
  TextColumn get folio => text()();           // Formato: "2023-08-0001"
  TextColumn get descripcion => text().nullable()();
  TextColumn get estatus => text()();                // "En curso" o "Cerrada"
  // TextColumn get metodoPago => text()();             // "Efectivo", "Tarjeta", "Transferencia"
  // RealColumn get adelantoPago => real().nullable()();
  RealColumn get total => real()();
  RealColumn get restante => real()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaCierre => dateTime().nullable()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
}