import 'package:drift/drift.dart';
import 'cliente.dart';

@DataClassName('OrdenServicioEntry')
class OrdenServicio extends Table {
  IntColumn get id => integer().autoIncrement()();                     // ID de la orden
  IntColumn get clienteId => integer().references(Cliente, #id)();
  IntColumn get folio => integer()();
  IntColumn get estatusUrgenciaId => integer()();              // ID del estatus de urgencia de la orden
  DateTimeColumn get fechaEntrega => dateTime()();
  DateTimeColumn get fechaLista => dateTime()();
  DateTimeColumn get fechaRecogida => dateTime()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get estatus => text()();                // "Pendiente" o "Completado"
  RealColumn get total => real()();
  TextColumn get metodoPago => text()();             // "Efectivo", "Tarjeta", "Transferencia"
  RealColumn get pago => real().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}