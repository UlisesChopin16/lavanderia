import 'package:drift/drift.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/models/tables/ordenes/item_servicio_orden.dart';
import 'package:lavanderia/data/local/ordenes/item_con_precio_entry.dart';

import 'package:lavanderia/data/local/app_database.dart';

part 'item_servicio_orden_dao.g.dart';

@DriftAccessor(tables: [ItemServicioOrden])
class ItemServicioOrdenDao extends DatabaseAccessor<AppDatabase> with _$ItemServicioOrdenDaoMixin {
  ItemServicioOrdenDao(super.db);

  // Future<List<ItemServicioOrdenEntry>> getAll() => select(itemServicioOrden).get();

  // Stream<List<ItemServicioOrdenEntry>> watchAll() => select(itemServicioOrden).watch();

  // Future<ItemServicioOrdenEntry?> getById(int id) => (select(
  //   itemServicioOrden,
  // )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Future<List<ItemServicioOrdenEntry>?> getItemsForOrden(int ordenId) => (select(
  //   itemServicioOrden,
  // )..where((tbl) => tbl.ordenId.equals(ordenId))).get();

  // Future<int> insertItem(ItemServicioOrdenEntry row) {
  //   final now = DateTime.now();
  //   final data = row.copyWith(
  //     fechaCreacion: now,
  //     fechaActualizacion: Value(now),
  //   );
  //   return into(itemServicioOrden).insert(data);
  // }

  // Future<bool> updateItem(ItemServicioOrdenEntry row) {
  //   final now = DateTime.now();
  //   final data = row.copyWith(fechaActualizacion: Value(now));
  //   return update(itemServicioOrden).replace(data);
  // }

  // Future<bool> deleteItem(ItemServicioOrdenEntry row) async {
  //   final now = DateTime.now();
  //   final updated = row.copyWith(fechaEliminacion: Value(now));
  //   return update(itemServicioOrden).replace(updated);
  // }

  Future<List<ItemConPrecioEntry>> getItemsByOrden(int ordenId) async {
    final query = queryJoined();
    query.where(itemServicioOrden.ordenId.equals(ordenId));
    final rows = await query.get();
    return convertToDetalles(rows);
  }
  

  Future<int> insertItem(ItemServicioOrdenCompanion row) async {
    final now = DateTime.now();
    final data = row.copyWith(
      fechaCreacion: Value(now),
    );

    return into(itemServicioOrden).insert(data);
  }

  Future<bool> updateItem(ItemServicioOrdenEntry row) async {
    return update(itemServicioOrden).replace(row);
  }

  JoinedSelectStatement queryJoined() {
    final query = select(itemServicioOrden).join([
      innerJoin(
        preciosConceptos,
        itemServicioOrden.precioConceptoId.equalsExp(preciosConceptos.id),
      ),
      innerJoin(
        categoriaServicio,
        categoriaServicio.id.equalsExp(preciosConceptos.categoriaId),
      ),
    ]);

    return query;
  }

  List<ItemConPrecioEntry> convertToDetalles(List<TypedResult> rows) {
    return rows.map((row) {
      return ItemConPrecioEntry(
        row.readTable(itemServicioOrden),
        PrecioConDetallesEntry(
          row.readTable(preciosConceptos),
          row.readTable(categoriaServicio),
        )
      );
    }).toList();
  }
}
