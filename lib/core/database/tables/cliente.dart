import 'package:drift/drift.dart';

@DataClassName('ClienteEntry')
class Cliente extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  TextColumn get correo => text()();
  TextColumn get telefono => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}