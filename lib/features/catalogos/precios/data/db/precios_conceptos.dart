import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/tables.dart';

@DataClassName('PreciosConceptosEntry')
class PreciosConceptos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(ItemServicio, #id)();
  IntColumn get sizeRopaId => integer().references(SizesRopa, #id)();
  IntColumn get diasEntrega => integer()(); // Días de entrega para este item en esta categoría
  TextColumn get tipoUnidad => text()(); // Ej. "Kg" o "pieza"
  RealColumn get importe => real()();
  TextColumn get estatus => text()(); // Ej. "Activo", "Inactivo"
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}