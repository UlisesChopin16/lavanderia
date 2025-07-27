import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/items_orden.dart';
import '../app_database.dart';

part 'item_orden_dao.g.dart';

@DriftAccessor(tables: [ItemsOrden])
class ItemsOrdenServicioDao extends DatabaseAccessor<AppDatabase>
    with _$ItemsOrdenServicioDaoMixin {
  ItemsOrdenServicioDao(super.db);

  Future<List<ItemOrdenEntry>> getAll() => select(itemsOrden).get();

  Stream<List<ItemOrdenEntry>> watchAll() => select(itemsOrden).watch();

  Future<ItemOrdenEntry?> getById(int id) => (select(
    itemsOrden,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertItem(Insertable<ItemOrdenEntry> row) {
    final now = DateTime.now();
    final casted = row as ItemOrdenEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(itemsOrden).insert(data);
  }

  Future<bool> updateItem(Insertable<ItemOrdenEntry> row) {
    final now = DateTime.now();
    final casted = row as ItemOrdenEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(itemsOrden).replace(data);
  }

  Future<bool> deleteItem(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(itemsOrden).replace(updated);
  }
}
