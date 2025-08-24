import 'package:drift/drift.dart';
import 'package:lavanderia/features/catalogos/sizes/data/db/sizes_ropa.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

import '../../../../../../core/database/app_database.dart';

part 'sizes_ropa_dao.g.dart';

@DriftAccessor(tables: [SizesRopa])
class SizesRopaDao extends DatabaseAccessor<AppDatabase> with _$SizesRopaDaoMixin {
  SizesRopaDao(super.db);

  Future<List<SizesRopaEntry>> getAll() {
    final query = select(sizesRopa);
    query.where((tbl) => tbl.estatus.equals(EstatusType.activo.value));
    return query.get();
  }

  Stream<List<SizesRopaEntry>> watchAll(FiltrosBase filtros) {
    final query = select(sizesRopa);

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

  Future<SizesRopaEntry?> getById(int id) =>
      (select(sizesRopa)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertSizes(SizesRopaCompanion row) async => await into(sizesRopa).insert(row);

  Future<bool> updateSizes(Insertable<SizesRopaEntry> row) {
    final now = DateTime.now();
    final casted = row as SizesRopaEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(sizesRopa).replace(data);
  }

  Future<bool> deleteSizes(SizesRopaEntry entry) async {
    final now = DateTime.now();
    // final record = await getById(id);
    // if (record == null) return false;
    final updated = entry.copyWith(fechaEliminacion: Value(now), fechaActualizacion: Value(now));
    return update(sizesRopa).replace(updated);
    // return await delete(sizesRopa).delete(updated);
  }
}
