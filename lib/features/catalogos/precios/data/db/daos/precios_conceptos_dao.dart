import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/features/catalogos/precios/data/db/precios_conceptos.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precios_detalles_entry/precios_detalles_entry.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';

import '../../../../../../core/database/app_database.dart';

part 'precios_conceptos_dao.g.dart';

@DriftAccessor(tables: [PreciosConceptos])
class PreciosConceptosDao extends DatabaseAccessor<AppDatabase> with _$PreciosConceptosDaoMixin {
  PreciosConceptosDao(super.db);

  // Future<List<PreciosConceptosEntry>> getAll() => select(preciosConceptos).get();

  Stream<List<PrecioConDetalles>> watchAllConceptosSizes({
    required int sizeId,
    required FiltrosPrecios filtros,
  }) {
    final query = queryWithFilters(filtros);
    query.where(sizesRopa.id.equals(sizeId));
    query.groupBy([itemServicio.id]);

    // query.where();
    return query.watch().map((rows) {
      return rows.map((row) {
        return PrecioConDetalles(
          row.readTable(preciosConceptos),
          row.readTable(itemServicio),
          row.readTable(sizesRopa),
          row.readTable(categoriaServicio),
        );
      }).toList();
    });
  }

  Stream<List<PrecioConDetalles>> watchAllByConcepto({
    required int conceptoId,
    required FiltrosPrecios filtros,
  }) {
    final query = queryWithFilters(filtros);
    query.where(preciosConceptos.itemId.equals(conceptoId));

    // query.where();
    return query.watch().map((rows) {
      return rows.map((row) {
        return PrecioConDetalles(
          row.readTable(preciosConceptos),
          row.readTable(itemServicio),
          row.readTable(sizesRopa),
          row.readTable(categoriaServicio),
        );
      }).toList();
    });
  }

  Stream<List<PrecioConDetalles>> watchAll(FiltrosPrecios filtros) {
    final query = queryWithFilters(filtros);
    // query.where();
    return query.watch().map((rows) {
      return rows.map((row) {
        return PrecioConDetalles(
          row.readTable(preciosConceptos),
          row.readTable(itemServicio),
          row.readTable(sizesRopa),
          row.readTable(categoriaServicio),
        );
      }).toList();
    });
  }

  JoinedSelectStatement queryJoined() {
    final query = select(preciosConceptos).join([
      innerJoin(itemServicio, itemServicio.id.equalsExp(preciosConceptos.itemId)),
      innerJoin(sizesRopa, sizesRopa.id.equalsExp(preciosConceptos.sizeRopaId)),
      innerJoin(
        categoriaServicio,
        categoriaServicio.id.equalsExp(itemServicio.categoriaId),
      ),
    ]);

    return query;
  }

  JoinedSelectStatement queryWithFilters(FiltrosPrecios? filtros) {
    final query = queryJoined();
    if (filtros == null) return query;

    if (filtros.estatus != EstatusType.todos) {
      // query.where((tbl) => tbl.estatus.equals(filtros.estatus.value));
      query.where(preciosConceptos.estatus.equals(filtros.estatus.value));
    }

    if (filtros.nombre.isNotEmpty) {
      // Se buscara por nombre de categoria, nombre de concepto o Nombre de tamaño
      query.where(
        itemServicio.nombre.like('%${filtros.nombre}%') |
            categoriaServicio.nombre.like('%${filtros.nombre}%') |
            sizesRopa.nombre.like('%${filtros.nombre}%'),
      );
      // query.where((tbl) => tbl.nombre.like('%${filtros.nombre}%'));
    }

    final mode = filtros.ascendente ? OrderingMode.asc : OrderingMode.desc;

    query.orderBy([
      if (filtros.ordenamiento == ColumnPreciosName.id)
        OrderingTerm(
          expression: preciosConceptos.id,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.nombre)
        OrderingTerm(
          expression: itemServicio.nombre,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.categoria)
        OrderingTerm(
          expression: categoriaServicio.nombre,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.sizeRopa)
        OrderingTerm(
          expression: sizesRopa.nombre,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.tipoUnidad)
        OrderingTerm(
          expression: preciosConceptos.tipoUnidad,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.diasEntrega)
        OrderingTerm(
          expression: preciosConceptos.diasEntrega,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.importe)
        OrderingTerm(
          expression: preciosConceptos.importe,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.estatus)
        OrderingTerm(
          expression: preciosConceptos.diasEntrega,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.fechaCreacion)
        OrderingTerm(
          expression: preciosConceptos.fechaCreacion,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnPreciosName.fechaEliminacion)
        OrderingTerm(
          expression: preciosConceptos.fechaEliminacion,
          mode: mode,
        ),
    ]);

    return query;

  }

  Future<int> insertPrecio(PreciosConceptosCompanion row) async {
    final query = queryJoined();
    // Nos aseguramos que el precio no exista ya en la base de datos con el mismo concepto
    // y el mismo tamaño
    query.where(
      preciosConceptos.itemId.equals(row.itemId.value) &
          preciosConceptos.sizeRopaId.equals(row.sizeRopaId.value),
    );

    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      throw const SQLException(message: 'El precio para este concepto y tamaño ya existe.');
    }

    final now = DateTime.now();
    final data = row.copyWith(
      fechaCreacion: Value(now),
      fechaActualizacion: const Value(null),
    );

    return into(preciosConceptos).insert(data);
  }

  Future<bool> updateRelacion(PreciosConceptosEntry row) {
    final now = DateTime.now();
    final data = row.copyWith(fechaActualizacion: Value(now));
    return update(preciosConceptos).replace(data);
  }

  Future<bool> deleteRelacion(PreciosConceptosEntry row) async {
    final now = DateTime.now();
    final updated = row.copyWith(fechaEliminacion: Value(now));
    return update(preciosConceptos).replace(updated);
  }
}
