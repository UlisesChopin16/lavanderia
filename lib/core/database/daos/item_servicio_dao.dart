import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/item_servicio.dart';
import '../app_database.dart';

part 'item_servicio_dao.g.dart';

@DriftAccessor(tables: [ItemServicio])
class ItemServicioDao extends DatabaseAccessor<AppDatabase>
    with _$ItemServicioDaoMixin {
  ItemServicioDao(super.db);

  Future<List<ItemServicioEntry>> getAll() => select(itemServicio).get();

  Stream<List<ItemServicioEntry>> watchAll() => select(itemServicio).watch();

  Future<ItemServicioEntry?> getById(int id) => (select(
    itemServicio,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertItem(Insertable<ItemServicioEntry> item) {
    final now = DateTime.now();
    final casted = item as ItemServicioEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(itemServicio).insert(data);
  }

  Future<bool> updateItem(Insertable<ItemServicioEntry> item) {
    final now = DateTime.now();
    final casted = item as ItemServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(itemServicio).replace(data);
  }

  Future<bool> deleteItem(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(itemServicio).replace(updated);
  }
}
