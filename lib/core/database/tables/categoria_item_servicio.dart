import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/categoria_servicio.dart';
import 'package:lavanderia/core/database/tables/item_servicio.dart';

@DataClassName('CategoriaItemServicioEntry')
class CategoriaItemServicio extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoriaId => integer().references(CategoriaServicio, #id)(); // ID de la categoría del item
  IntColumn get itemId => integer().references(ItemServicio, #id)();
  IntColumn get diasEntrega => integer()(); // Días de entrega para este item en esta categoría
  TextColumn get tipoUnidad => text()(); // Ej. "Kg" o "Unidad"
  RealColumn get importe => real()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}