import 'package:drift/drift.dart';

@DataClassName('ConfiguracionEmpresaEntry')
class ConfiguracionEmpresa extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get direccion => text()();
  TextColumn get telefono => text()();
  TextColumn get correo => text()();
  TextColumn get paginaWeb => text()();
  TextColumn get logo => text().nullable()();        // Guardar ruta de la imagen
  TextColumn get color => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}