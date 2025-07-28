import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/item_servicio_orden.dart';
import '../app_database.dart';

part 'item_servicio_orden_dao.g.dart';

@DriftAccessor(tables: [ItemServicioOrden])
class ItemServicioOrdenDao extends DatabaseAccessor<AppDatabase>
    with _$ItemServicioOrdenDaoMixin {
  ItemServicioOrdenDao(super.db);

  Future<List<ItemServicioOrdenEntry>> getAll() => select(itemServicioOrden).get();

  Stream<List<ItemServicioOrdenEntry>> watchAll() => select(itemServicioOrden).watch();

  Future<ItemServicioOrdenEntry?> getById(int id) => (select(
    itemServicioOrden,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<ItemServicioOrdenEntry>?> getItemsForOrden(int ordenId) => (select(
    itemServicioOrden,
  )..where((tbl) => tbl.ordenId.equals(ordenId))).get();

  Future<int> insertItem(Insertable<ItemServicioOrdenEntry> row) {
    final now = DateTime.now();
    final casted = row as ItemServicioOrdenEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(itemServicioOrden).insert(data);
  }

  Future<bool> updateItem(Insertable<ItemServicioOrdenEntry> row) {
    final now = DateTime.now();
    final casted = row as ItemServicioOrdenEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(itemServicioOrden).replace(data);
  }

  Future<bool> deleteItem(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(itemServicioOrden).replace(updated);
  }
}
