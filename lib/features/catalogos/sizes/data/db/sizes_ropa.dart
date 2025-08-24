import 'package:drift/drift.dart';

@DataClassName('SizesRopaEntry')
class SizesRopa extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get estatus => text()(); // 'Activo', 'Inactivo'
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}