import 'package:drift/drift.dart';

@DataClassName('ItemServicioEntry')
class ItemsServicio extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text()();
  RealColumn get importe => real()();
  TextColumn get tipoUnidad => text()(); // Ej. "Kg" o "Unidad"
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}