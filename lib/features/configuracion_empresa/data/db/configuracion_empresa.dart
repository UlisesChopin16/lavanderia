import 'package:drift/drift.dart';

@DataClassName('ConfiguracionEmpresaEntry')
class ConfiguracionEmpresa extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get correo => text()();
  TextColumn get paginaWeb => text()();
  TextColumn get logo => text().nullable()();        // Guardar ruta de la imagen
  IntColumn get color => integer()();
  TextColumn get password => text()(); // Contraseña para acceso administrativo
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}