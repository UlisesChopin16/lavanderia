import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/precios_conceptos.dart';

import '../app_database.dart';

part 'categoria_item_servicio_dao.g.dart';

@DriftAccessor(tables: [PreciosConceptos])
class PreciosConceptosDao extends DatabaseAccessor<AppDatabase> with _$PreciosConceptosDaoMixin {
  PreciosConceptosDao(super.db);

  Future<List<PreciosConceptosEntry>> getAll() => select(preciosConceptos).get();

  Stream<List<PreciosConceptosEntry>> watchAll() => select(preciosConceptos).watch();

  Future<PreciosConceptosEntry?> getById(int id) =>
      (select(preciosConceptos)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<PreciosConceptosEntry>> getCategoriesForItem(int itemId) =>
      (select(preciosConceptos)..where((tbl) => tbl.itemId.equals(itemId))).get();

  Future<int> insertRelacion(Insertable<PreciosConceptosEntry> row) {
    final now = DateTime.now();
    final casted = row as PreciosConceptosEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: const Value(null),
    );
    return into(preciosConceptos).insert(data);
  }

  Future<bool> updateRelacion(Insertable<PreciosConceptosEntry> row) {
    final now = DateTime.now();
    final casted = row as PreciosConceptosEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(preciosConceptos).replace(data);
  }

  Future<bool> deleteRelacion(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(preciosConceptos).replace(updated);
  }
}
