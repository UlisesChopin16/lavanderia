import 'package:drift/drift.dart';
import 'configuracion_empresa.dart';

@DataClassName('DireccionEntry')
class Direccion extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get empresaId => integer().references(ConfiguracionEmpresa, #id)();
  TextColumn get calle => text()();
  TextColumn get numeroExterior => text()();
  TextColumn get numeroInterior => text().nullable()();
  TextColumn get colonia => text()();
  TextColumn get codigoPostal => text()();
  TextColumn get ciudad => text()();
  TextColumn get estado => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaActualizacion => dateTime().nullable()();
  DateTimeColumn get fechaEliminacion => dateTime().nullable()();
}