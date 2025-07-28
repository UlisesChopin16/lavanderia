import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/categoria_item_servicio.dart';
import 'orden_servicio.dart';
import 'item_servicio.dart';

@DataClassName('ItemServicioOrdenEntry')
class ItemServicioOrden extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenServicio, #id)();
  IntColumn get itemId => integer().references(ItemServicio, #id)();
  IntColumn get categoriaId => integer().references(CategoriaItemServicio, #id)();
  RealColumn get cantidad => real()();
  RealColumn get importe => real()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}