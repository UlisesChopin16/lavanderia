import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/data/db/categoria_servicio.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

import '../../../../../../../core/database/app_database.dart';

part 'categoria_servicio_dao.g.dart';

@DriftAccessor(tables: [CategoriaServicio])
class CategoriaServicioDao extends DatabaseAccessor<AppDatabase> with _$CategoriaServicioDaoMixin {
  CategoriaServicioDao(super.db);

  // Future<List<CategoriaServicioEntry>> getAll() =>
  //     select(categoriaServicio).get();

  // Stream<List<CategoriaServicioEntry>> watchAll() =>
  //     select(categoriaServicio).watch();

  // Future<CategoriaServicioEntry?> getById(int id) =>
  //     (select(categoriaServicio)..where((tbl) => tbl.id.equals(id)))
  //         .getSingleOrNull();

  // Future<int> insertCategoria(Insertable<CategoriaServicioEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as CategoriaServicioEntry;
  //   final data = casted.copyWith(
  //     fechaCreacion: now,
  //     fechaActualizacion: const Value(null),
  //   );
  //   return into(categoriaServicio).insert(data);
  // }

  // Future<bool> updateCategoria(Insertable<CategoriaServicioEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as CategoriaServicioEntry;
  //   final data = casted.copyWith(fechaActualizacion: Value(now));
  //   return update(categoriaServicio).replace(data);
  // }

  // Future<bool> deleteCategoria(int id) async {
  //   final now = DateTime.now();
  //   final record = await getById(id);
  //   if (record == null) return false;
  //   final updated = record.copyWith(fechaEliminacion: Value(now));
  //   return update(categoriaServicio).replace(updated);
  // }

  Future<List<CategoriaServicioEntry>> getAll() {
    final query = select(categoriaServicio);
    query.where((tbl) => tbl.estatus.equals(EstatusType.activo.value));
    return query.get();
  }

  Stream<List<CategoriaServicioEntry>> watchAll(FiltrosBase filtros) {
    final query = select(categoriaServicio);

    if (filtros.estatus != EstatusType.todos) {
      query.where((tbl) => tbl.estatus.equals(filtros.estatus.value));
    }

    if (filtros.nombre.isNotEmpty) {
      query.where((tbl) => tbl.nombre.like('%${filtros.nombre}%'));
    }

    final mode = filtros.ascendente ? OrderingMode.asc : OrderingMode.desc;
    // final orderAll = [
    //   (tbl) => OrderingTerm(
    //         expression: tbl.estatus,
    //         mode: mode,
    //       ),
    //   (tbl) => OrderingTerm(
    //         expression: tbl.nombre,
    //         mode: mode,
    //       ),
    // ];

    query.orderBy([
      // if (filtros.estatus == EstatusType.todos && filtros.ordenamiento == null) ...orderAll,

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

    // Apply filters to the query if needed
    return query.watch();
  }

  Future<CategoriaServicioEntry?> getById(int id) =>
      (select(categoriaServicio)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertCategoria(CategoriaServicioCompanion row) async {
    final query = select(categoriaServicio);
    final value = row.nombre.value.toLowerCase();
    query.where((tbl) => tbl.nombre.lower().equals(value));
    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      throw SQLException(message: 'Ya existe una categoría con el nombre "${row.nombre.value}".');
    }

    final now = DateTime.now();
    final data = row.copyWith(
      fechaCreacion: Value(now),
      fechaActualizacion: Value(now),
    );

    return await into(categoriaServicio).insert(data);
  }

  Future<bool> updateCategoria(Insertable<CategoriaServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as CategoriaServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(categoriaServicio).replace(data);
  }

  Future<bool> deleteCategoria(CategoriaServicioEntry entry) async {
    final now = DateTime.now();
    // final record = await getById(id);
    // if (record == null) return false;
    final updated = entry.copyWith(fechaEliminacion: Value(now), fechaActualizacion: Value(now));
    return update(categoriaServicio).replace(updated);
    // return await delete(CategoriaRopa).delete(updated);
  }
}
