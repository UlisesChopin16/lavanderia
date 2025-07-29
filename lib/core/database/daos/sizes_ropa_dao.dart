import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/sizes_ropa.dart';
import '../app_database.dart';


part 'sizes_ropa_dao.g.dart';

@DriftAccessor(tables: [SizesRopa])
class SizesRopaDao extends DatabaseAccessor<AppDatabase>
    with _$SizesRopaDaoMixin {
  SizesRopaDao(super.db);

  Future<List<SizesRopaEntry>> getAll() => select(sizesRopa).get();

  Stream<List<SizesRopaEntry>> watchAll() =>
      select(sizesRopa).watch();

  Future<SizesRopaEntry?> getById(int id) => (select(
    sizesRopa,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertSizes(Insertable<SizesRopaEntry> row) {
    final now = DateTime.now();
    final casted = row as SizesRopaEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(sizesRopa).insert(data);
  }

  Future<bool> updateSizes(Insertable<SizesRopaEntry> row) {
    final now = DateTime.now();
    final casted = row as SizesRopaEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(sizesRopa).replace(data);
  }

  Future<bool> deleteSizes(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(sizesRopa).replace(updated);
  }
}
