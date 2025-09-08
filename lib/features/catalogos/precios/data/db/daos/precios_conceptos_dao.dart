import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/catalogos/precios/data/db/precios_conceptos.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_entry/precio_con_detalles_entry.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';

import '../../../../../../core/database/app_database.dart';

export 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_entry/precio_con_detalles_entry.dart';

part 'precios_conceptos_dao.g.dart';

@DriftAccessor(tables: [PreciosConceptos])
class PreciosConceptosDao extends DatabaseAccessor<AppDatabase> with _$PreciosConceptosDaoMixin {
  PreciosConceptosDao(super.db);

  // Future<List<PreciosConceptosEntry>> getAll() => select(preciosConceptos).get();

  Future<List<PrecioConDetallesEntry>> getAll() async {
    final query = queryJoined();
    query.where(preciosConceptos.estatus.equals(EstatusType.activo.value));

    final data = await query.get();
    return convertToDetalles(data);
  }

  Stream<List<PrecioConDetallesEntry>> watchAllBySize({
    required int sizeId,
    required FiltrosPrecios filtros,
  }) {
    final query = queryWithFilters(filtros);
    query.where(sizesRopa.id.equals(sizeId));

    // query.where();
    return query.watch().map((rows) {
      return convertToDetalles(rows);
    });
  }

  Stream<List<PrecioConDetallesEntry>> watchAllByCategoria({
    required int categoriaId,
    required FiltrosPrecios filtros,
  }) {
    final query = queryWithFilters(filtros);
    query.where(categoriaServicio.id.equals(categoriaId));

    // query.where();
    return query.watch().map((rows) {
      return convertToDetalles(rows);
    });
  }

  Stream<List<PrecioConDetallesEntry>> watchAll({required FiltrosPrecios filtros}) {
    final query = queryWithFilters(filtros);
    // query.where();
    return query.watch().map((rows) {
      return convertToDetalles(rows);
    });
  }

  JoinedSelectStatement queryJoined() {
    final query = select(preciosConceptos).join([
      leftOuterJoin(sizesRopa, sizesRopa.id.equalsExp(preciosConceptos.sizeRopaId)),
      innerJoin(
        categoriaServicio,
        categoriaServicio.id.equalsExp(preciosConceptos.categoriaId),
      ),
    ]);

    return query;
  }

  JoinedSelectStatement queryWithFilters(FiltrosPrecios? filtros) {
    final query = queryJoined();
    if (filtros == null) return query;

    if (filtros.categoria.id != -1 && filtros.categoria.id != 0) {
      query.where(categoriaServicio.id.equals(filtros.categoria.id));
    }

    final sizeRopa = filtros.sizeRopa;

    if (sizeRopa != null) {
      query.where(preciosConceptos.sizeRopaId.equals(sizeRopa.id));
    }
    

    if (filtros.estatus != EstatusType.todos) {
      // query.where((tbl) => tbl.estatus.equals(filtros.estatus.value));
      query.where(preciosConceptos.estatus.equals(filtros.estatus.value));
    }

    if (filtros.nombre.isNotEmpty) {
      // Se buscara por nombre de categoria, nombre de concepto o Nombre de tamaño
      query.where(
        preciosConceptos.nombreConcepto.like('%${filtros.nombre}%') |
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
          expression: preciosConceptos.nombreConcepto,
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
    await verifyCategoriaEstatus(row);
    await verifySizeEstatus(row);
    await rowExists(row);

    final now = DateTime.now();
    final data = row.copyWith(
      fechaCreacion: Value(now),
      fechaActualizacion: const Value(null),
    );

    return into(preciosConceptos).insert(data);
  }

  Future<bool> updateRelacion(PreciosConceptosEntry row) async {
    await verifyCategoriaEstatusEntry(row);
    await verifySizeEstatusEntry(row);
    await rowEntryExists(row);

    final now = DateTime.now();
    final data = row.copyWith(fechaActualizacion: Value(now));
    return update(preciosConceptos).replace(data);
  }

  Future<bool> deleteRelacion(PreciosConceptosEntry row) async {
    final now = DateTime.now();
    final updated = row.copyWith(fechaEliminacion: Value(now));
    return update(preciosConceptos).replace(updated);
  }

  Future<void> deactivatePreciosByCategoria(int categoriaId) async {
    final query = select(preciosConceptos);
    query.where((tbl) => tbl.categoriaId.equals(categoriaId) & tbl.fechaEliminacion.isNull());
    final rows = await query.get();

    final now = DateTime.now();
    for (var row in rows) {
      final updated = row.copyWith(
        estatus: EstatusType.inactivo.value,
        fechaEliminacion: Value(now),
        fechaActualizacion: Value(now),
      );
      await update(preciosConceptos).replace(updated);
    }
  }

  Future<void> activatePreciosByCategoria(int categoriaId) async {
    final query = queryJoined();
    query.where(
      categoriaServicio.id.equals(categoriaId) &
          preciosConceptos.fechaEliminacion.isNotNull() &
          sizesRopa.estatus.equals(EstatusType.activo.value),
    );
    // final query = select(preciosConceptos);
    // query.where((tbl) => tbl.categoriaId.equals(categoriaId) & tbl.fechaEliminacion.isNotNull());
    final rows = await query.get();
    final dataRows = convertToDetalles(rows);

    final now = DateTime.now();
    for (var row in dataRows) {
      final updated = row.precio.copyWith(
        estatus: EstatusType.activo.value,
        fechaEliminacion: const Value(null),
        fechaActualizacion: Value(now),
      );
      await update(preciosConceptos).replace(updated);
    }
  }

  Future<void> changeDiasPreciosByCategoria(CategoriaServicioEntry categoria) async {
    final query = select(preciosConceptos);
    query.where((tbl) => tbl.categoriaId.equals(categoria.id));
    final rows = await query.get();

    final now = DateTime.now();
    for (var row in rows) {
      final updated = row.copyWith(
        diasEntrega: categoria.diasEntrega,
        fechaActualizacion: Value(now),
      );
      await update(preciosConceptos).replace(updated);
    }
  }

  Future<void> deactivatePreciosBySize(int sizeId) async {
    final query = select(preciosConceptos);
    query.where((tbl) => tbl.sizeRopaId.equals(sizeId) & tbl.fechaEliminacion.isNull());
    final rows = await query.get();

    final now = DateTime.now();
    for (var row in rows) {
      final updated = row.copyWith(
        estatus: EstatusType.inactivo.value,
        fechaEliminacion: Value(now),
        fechaActualizacion: Value(now),
      );
      await update(preciosConceptos).replace(updated);
    }
  }

  Future<void> activatePreciosBySize(int sizeId) async {
    final query = queryJoined();
    query.where(
      sizesRopa.id.equals(sizeId) &
          preciosConceptos.fechaEliminacion.isNotNull() &
          categoriaServicio.estatus.equals(EstatusType.activo.value),
    );
    // final query = select(preciosConceptos);
    // query.where((tbl) => tbl.sizeRopaId.equals(sizeId) & tbl.fechaEliminacion.isNotNull());
    final rows = await query.get();
    final dataRows = convertToDetalles(rows);

    final now = DateTime.now();
    for (var row in dataRows) {
      final updated = row.precio.copyWith(
        estatus: EstatusType.activo.value,
        fechaEliminacion: const Value(null),
        fechaActualizacion: Value(now),
      );
      await update(preciosConceptos).replace(updated);
    }
  }

  Future<void> rowExists(PreciosConceptosCompanion row) async {
    final query = queryJoined();
    // Nos aseguramos que el precio no exista ya en la base de datos con el mismo concepto
    // y el mismo tamaño
    query.where(
      preciosConceptos.categoriaId.equals(row.categoriaId.value) &
          preciosConceptos.sizeRopaId.equals(row.sizeRopaId.value) &
          preciosConceptos.nombreConcepto.lower().equals(row.nombreConcepto.value.toLowerCase()),
    );

    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      final detallesRow = convertToDetalles(dataRow).first;
      final nombreConcepto = row.nombreConcepto.value;
      final categoria = detallesRow.categoria.nombre;
      final size = detallesRow.size.nombre;
      throw SQLException(
        message:
            'Ya hay un registro en la base de datos con el concepto "$nombreConcepto" en la categoria "$categoria" y con el tamaño "$size".',
      );
    }
  }

  Future<void> rowEntryExists(PreciosConceptosEntry row) async {
    final query = queryJoined();
    // Nos aseguramos que el precio no exista ya en la base de datos con el mismo concepto
    // y el mismo tamaño
    query.where(
      preciosConceptos.categoriaId.equals(row.categoriaId) &
          preciosConceptos.sizeRopaId.equals(row.sizeRopaId) &
          preciosConceptos.nombreConcepto.lower().equals(row.nombreConcepto.toLowerCase()) &
          preciosConceptos.id.isNotIn([row.id]),
    );

    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      final detallesRow = convertToDetalles(dataRow).first;
      final nombreConcepto = row.nombreConcepto;
      final categoria = detallesRow.categoria.nombre;
      final size = detallesRow.size.nombre;
      throw SQLException(
        message:
            'Ya hay un registro en la base de datos con el concepto "$nombreConcepto" en la categoria "$categoria" y con el tamaño "$size".',
      );
    }
  }

  Future<void> verifyCategoriaEstatus(PreciosConceptosCompanion row) async {
    final query = select(categoriaServicio);
    // query.where(
    //   categoriaServicio.id.equals(row.categoriaId.value),
    // );
    query.where(
      (tbl) => tbl.id.equals(row.categoriaId.value),
    );

    final dataRow = await query.get();
    if (dataRow.isEmpty) return;

    final detallesRow = dataRow.first;
    final nombreConcepto = row.nombreConcepto.value;
    final isInactive = detallesRow.estatus == EstatusType.inactivo.value;
    final categoria = detallesRow.nombre;

    if (isInactive) {
      throw SQLException(
        message:
            'No se puede crear el concepto "$nombreConcepto" porque la categoria "$categoria" está inactiva, porfavor active la categoria antes de continuar.',
      );
    }
  }

  Future<void> verifyCategoriaEstatusEntry(PreciosConceptosEntry row) async {
    // final query = queryJoined();
    // query.where(
    //   categoriaServicio.id.equals(row.categoriaId),
    // );

    final query = select(categoriaServicio);
    query.where(
      (tbl) => tbl.id.equals(row.categoriaId),
    );

    final dataRow = await query.get();
    if (dataRow.isEmpty) return;

    final detallesRow = dataRow.first;
    final nombreConcepto = row.nombreConcepto;
    final categoria = detallesRow.nombre;
    final isInactive = detallesRow.estatus == EstatusType.inactivo.value;

    if (isInactive) {
      throw SQLException(
        message:
            'No se puede actualizar el concepto "$nombreConcepto" porque la categoria "$categoria" está inactiva, porfavor active la categoria antes de continuar.',
      );
    }
  }

  Future<void> verifySizeEstatus(PreciosConceptosCompanion row) async {
    // final query = queryJoined();

    // query.where(
    //   sizesRopa.id.equals(row.sizeRopaId.value),
    // );

    final query = select(sizesRopa);
    query.where(
      (tbl) => tbl.id.equals(row.sizeRopaId.value),
    );

    final dataRow = await query.get();
    if (dataRow.isEmpty) return;

    final detallesRow = dataRow.first;
    final nombreConcepto = row.nombreConcepto.value;
    final size = detallesRow.nombre;
    final isInactive = detallesRow.estatus == EstatusType.inactivo.value;

    if (isInactive) {
      throw SQLException(
        message:
            'No se puede crear el concepto "$nombreConcepto" porque el tamaño "$size" está inactivo, porfavor active el tamaño antes de continuar.',
      );
    }
  }

  Future<void> verifySizeEstatusEntry(PreciosConceptosEntry row) async {
    final query = select(sizesRopa);
    query.where(
      (tbl) => tbl.id.equals(row.sizeRopaId),
    );

    final dataRow = await query.get();
    if (dataRow.isEmpty) return;
    final detallesRow = dataRow.first;
    final nombreConcepto = row.nombreConcepto;
    final size = detallesRow.nombre;
    final isInactive = detallesRow.estatus == EstatusType.inactivo.value;

    if (isInactive) {
      throw SQLException(
        message:
            'No se puede actualizar el concepto "$nombreConcepto" porque el tamaño "$size" está inactivo, porfavor active el tamaño antes de continuar.',
      );
    }
  }

  List<PrecioConDetallesEntry> convertToDetalles(List<TypedResult> rows) {
    return rows.map((row) {
      return PrecioConDetallesEntry(
        row.readTable(preciosConceptos),
        row.readTableOrNull(sizesRopa) ?? ConstantsManager.defaultSizeRopa.toModel().toEntry(),
        row.readTable(categoriaServicio),
      );
    }).toList();
  }
}
