import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

import '../../../../../../../core/database/app_database.dart';
import '../item_servicio.dart';

part 'item_servicio_dao.g.dart';

@DriftAccessor(tables: [ItemServicio])
class ItemServicioDao extends DatabaseAccessor<AppDatabase> with _$ItemServicioDaoMixin {
  ItemServicioDao(super.db);

  Future<List<ItemServicioEntry>> getAll() => select(itemServicio).get();

  Stream<List<ItemServicioEntry>> watchAll({
    required int idCategoria,
    required FiltrosBase filtros,
  }) {
    final query = select(itemServicio);
    query.where((tbl) => tbl.categoriaId.equals(idCategoria));

    if (filtros.estatus != EstatusType.todos) {
      query.where((tbl) => tbl.estatus.equals(filtros.estatus.value));
    }

    if (filtros.nombre.isNotEmpty) {
      query.where((tbl) => tbl.nombre.like('%${filtros.nombre}%'));
    }

    final mode = filtros.ascendente ? OrderingMode.asc : OrderingMode.desc;

    query.orderBy([
      if (filtros.ordenamiento == ColumnNamesType.id)
        (tbl) => OrderingTerm(
              expression: tbl.id,
              mode: mode,
            ),
      if (filtros.ordenamiento == ColumnNamesType.nombre)
        (tbl) => OrderingTerm(
              expression: tbl.nombre,
              mode: mode,
            ),
      if (filtros.ordenamiento == ColumnNamesType.estatus)
        (tbl) => OrderingTerm(
              expression: tbl.estatus,
              mode: mode,
            ),
      if (filtros.ordenamiento == ColumnNamesType.fechaCreacion)
        (tbl) => OrderingTerm(
              expression: tbl.fechaCreacion,
              mode: mode,
            ),
      if (filtros.ordenamiento == ColumnNamesType.fechaEliminacion)
        (tbl) => OrderingTerm(
              expression: tbl.fechaEliminacion,
              mode: mode,
            ),
    ]);

    return query.watch();
  }

  Future<ItemServicioEntry?> getById(int id) => (select(
        itemServicio,
      )..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertItem(ItemServicioCompanion item) async {
    final query = select(itemServicio);
    final value = item.nombre.value.toLowerCase();
    query.where((tbl) => tbl.nombre.lower().equals(value));
    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      throw SQLException(message: 'Ya existe un concepto con el nombre "${item.nombre.value}".');
    }

    final now = DateTime.now();
    final data = item.copyWith(
      fechaCreacion: Value(now),
      fechaActualizacion: Value(now),
    );
    return await into(itemServicio).insert(data);
  }

  Future<bool> updateItem(ItemServicioEntry item) {
    final now = DateTime.now();
    final data = item.copyWith(fechaActualizacion: Value(now));
    return update(itemServicio).replace(data);
  }

  Future<bool> deleteItem(ItemServicioEntry item) async {
    final now = DateTime.now();
    final updated = item.copyWith(
      fechaEliminacion: Value(now),
      fechaActualizacion: Value(now),
    );
    return update(itemServicio).replace(updated);
  }
}
