import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/estatus_urgencia_table.dart';
import '../app_database.dart';


part 'estatus_urgencia_dao.g.dart';

@DriftAccessor(tables: [EstatusUrgencia])
class EstatusUrgenciaDao extends DatabaseAccessor<AppDatabase>
    with _$EstatusUrgenciaDaoMixin {
  EstatusUrgenciaDao(super.db);

  Future<List<EstatusUrgenciaEntry>> getAll() => select(estatusUrgencia).get();

  Stream<List<EstatusUrgenciaEntry>> watchAll() =>
      select(estatusUrgencia).watch();

  Future<EstatusUrgenciaEntry?> getById(int id) => (select(
    estatusUrgencia,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertEstatus(Insertable<EstatusUrgenciaEntry> row) {
    final now = DateTime.now();
    final casted = row as EstatusUrgenciaEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(estatusUrgencia).insert(data);
  }

  Future<bool> updateEstatus(Insertable<EstatusUrgenciaEntry> row) {
    final now = DateTime.now();
    final casted = row as EstatusUrgenciaEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(estatusUrgencia).replace(data);
  }

  Future<bool> deleteEstatus(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(estatusUrgencia).replace(updated);
  }
}
