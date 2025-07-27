import 'package:drift/drift.dart';

@DataClassName('EstatusUrgenciaEntry')
class EstatusUrgencia extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text()();
  TextColumn get estatus => text()(); // 'Activo', 'Inactivo'
  IntColumn get porcentajeRecargo => integer()(); // 0 - 100
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}