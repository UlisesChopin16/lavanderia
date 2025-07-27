import 'package:drift/drift.dart';
import 'ordenes_servicio.dart';
import 'items_servicio.dart';

@DataClassName('ItemOrdenEntry')
class ItemsOrden extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  IntColumn get itemId => integer().references(ItemsServicio, #id)();
  RealColumn get cantidad => real()();
  RealColumn get importe => real()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}