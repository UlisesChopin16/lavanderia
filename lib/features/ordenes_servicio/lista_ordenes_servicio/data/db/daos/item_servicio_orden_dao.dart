import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/item_servicio_orden.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/data/models/items_servicio/item_con_precio_entry/item_con_precio_entry.dart';

import '../../../../../../core/database/app_database.dart';

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
      leftOuterJoin(
        sizesRopa,
        sizesRopa.id.equalsExp(preciosConceptos.sizeRopaId),
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
          row.readTableOrNull(sizesRopa) ?? ConstantsManager.defaultSizeRopa.toModel().toEntry(),
          row.readTable(categoriaServicio),
        )
      );
    }).toList();
  }
}
