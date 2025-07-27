import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/configuracion_empresa.dart';
import '../app_database.dart';

part 'configuracion_empresa_dao.g.dart';

@DriftAccessor(tables: [ConfiguracionEmpresa])
class ConfiguracionEmpresaDao extends DatabaseAccessor<AppDatabase>
    with _$ConfiguracionEmpresaDaoMixin {
  ConfiguracionEmpresaDao(super.db);

  Future<List<ConfiguracionEmpresaEntry>> getAll() =>
      select(configuracionEmpresa).get();

  Stream<List<ConfiguracionEmpresaEntry>> watchAll() =>
      select(configuracionEmpresa).watch();

  Future<ConfiguracionEmpresaEntry?> getById(int id) => (select(
    configuracionEmpresa,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertConfig(Insertable<ConfiguracionEmpresaEntry> row) {
    final now = DateTime.now();
    final casted = row as ConfiguracionEmpresaEntry;
    final configWithDate = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),

    );

    return into(configuracionEmpresa).insert(configWithDate);
  }

  Future<bool> updateConfig(Insertable<ConfiguracionEmpresaEntry> row) {
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final casted = row as ConfiguracionEmpresaEntry;
    final configWithDate = casted.copyWith(fechaActualizacion: Value(now));

    return update(configuracionEmpresa).replace(configWithDate);
  }

  Future<bool> deleteConfig(int id) async {
    final now = DateTime.now();
    final config = await getById(id);
    if (config == null) {
      return Future.value(false); // No record found to delete
    }

    final updateConfiguracionEmpresa = config.copyWith(
      fechaEliminacion: Value(now),
    );

    return update(configuracionEmpresa).replace(updateConfiguracionEmpresa);
  }
}
