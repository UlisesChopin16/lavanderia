import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/categoria_item_servicio.dart';
import '../app_database.dart';

part 'categoria_item_servicio_dao.g.dart';

@DriftAccessor(tables: [CategoriaItemServicio])
class CategoriaItemServicioDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriaItemServicioDaoMixin {
  CategoriaItemServicioDao(super.db);

  Future<List<CategoriaItemServicioEntry>> getAll() =>
      select(categoriaItemServicio).get();

  Stream<List<CategoriaItemServicioEntry>> watchAll() =>
      select(categoriaItemServicio).watch();

  Future<CategoriaItemServicioEntry?> getById(int id) =>
      (select(categoriaItemServicio)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<List<CategoriaItemServicioEntry>> getCategoriesForItem(int itemId) =>
      (select(categoriaItemServicio)..where((tbl) => tbl.itemId.equals(itemId)))
          .get();

  Future<int> insertRelacion(Insertable<CategoriaItemServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as CategoriaItemServicioEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: const Value(null),
    );
    return into(categoriaItemServicio).insert(data);
  }

  Future<bool> updateRelacion(Insertable<CategoriaItemServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as CategoriaItemServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(categoriaItemServicio).replace(data);
  }

  Future<bool> deleteRelacion(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(categoriaItemServicio).replace(updated);
  }
}