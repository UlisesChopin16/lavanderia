import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/tables.dart';

@DataClassName('ItemServicioEntry')
class ItemServicio extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoriaId => integer().references(CategoriaServicio, #id)();
  TextColumn get nombre => text()();
  TextColumn get estatus => text()(); // Ej. "Activo", "Inactivo"
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}