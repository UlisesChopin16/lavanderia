import 'package:drift/drift.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/orden_history.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_entry/orden_con_detalles_entry.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';

import '../../../../../../core/database/app_database.dart';

part 'orden_history_dao.g.dart';

@DriftAccessor(tables: [OrdenHistory])
class OrdenHistoryDao extends DatabaseAccessor<AppDatabase> with _$OrdenHistoryDaoMixin {
  OrdenHistoryDao(super.db);

  // Future<List<OrdenHistoryEntry>> getAll() => select(ordenHistory).get();
  Stream<List<OrdenConDetallesEntry>> watchAll(FiltrosOrdenes filtros) {
    final query = queryWithFilters(filtros);
    // query.where()
    return query.watch().map((rows) => convertToDetalles(rows));
  }

  Future<List<OrdenHistoryEntry>> getHistoryByOrden(int idOrden) async {
    final query = select(ordenHistory)
      ..where((tbl) => tbl.ordenId.equals(idOrden))
      ..orderBy([(t) => OrderingTerm.desc(t.fecha)]);
    return await query.get();
  }

  // Future<OrdenHistoryEntry?> getById(int id) => (select(
  //   ordenHistory,
  // )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Future<List<OrdenHistoryEntry>> getOrdenesForCliente(int clienteId) => (select(
  //   ordenHistory,
  // )..where((tbl) => tbl.clienteId.equals(clienteId))).get();

  Future<int> insertHistory(OrdenHistoryCompanion row) async {
    return await into(ordenHistory).insert(row);
  }
  
  Future<bool> updateHistory(OrdenHistoryEntry row) async {
    return await update(ordenHistory).replace(row);
  }

  JoinedSelectStatement queryJoined() {
    final query = select(ordenServicio).join([
      innerJoin(
        ordenHistory,
        ordenHistory.ordenId.equalsExp(ordenServicio.id) &
            ordenHistory.fecha.equalsExp(ordenServicio.fechaActualizacion),
      ),
      innerJoin(
        cliente,
        cliente.id.equalsExp(ordenServicio.clienteId),
      ),
    ]);

    return query;
  }

  JoinedSelectStatement queryWithFilters(FiltrosOrdenes filtros) {
    final query = queryJoined();

    // Apply filters
    if (filtros.estatus != EstatusOrdenType.todos) {
      query.where(ordenServicio.estatus.equals(filtros.estatus.value));
    }

    if (filtros.busqueda.isNotEmpty) {
      final tokens = filtros.busqueda.toLowerCase().split(' ');

      query.where(
        tokens
            .map(
              (t) =>
                  cliente.nombres.lower().like('%$t%') |
                  cliente.apellidos.lower().like('%$t%') |
                  ordenServicio.folio.lower().like('%$t%'),
            )
            .reduce((a, b) => a & b),
      );
      // final busqueda = '%${filtros.busqueda.toLowerCase()}%';
      // query.where(ordenServicio.folio.lower().like(busqueda) | cliente.nombres.lower().like(busqueda) | cliente.apellidos.lower().like(busqueda));
    }

    if (filtros.metodoPago != null) {
      query.where(ordenHistory.metodoPago.equals(filtros.metodoPago!.value));
    }

    if (filtros.fechas.isNotEmpty) {
      final filtrosLength = filtros.fechas.length;
      final isMoreOne = filtrosLength > 1;

      final start = filtros.fechas[0];
      final end = isMoreOne ? filtros.fechas[1] : null;
      final newEnd = end?.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

      if (start != null && newEnd != null) {
        // Filter between two dates
        query.where(
          ordenServicio.fechaCreacion.isBetweenValues(start, newEnd),
        );
      } else if (start != null) {
        // Filter from start date onwards
        query.where(ordenServicio.fechaCreacion.isBiggerOrEqualValue(start));
      } else if (newEnd != null) {
        // Filter up to end date
        query.where(ordenServicio.fechaCreacion.isSmallerOrEqualValue(newEnd));
      }
    }

    final mode = filtros.ascendente ? OrderingMode.asc : OrderingMode.desc;

    query.orderBy([
      if (filtros.ordenamiento == ColumnsOrdenesNames.id)
        OrderingTerm(
          expression: ordenServicio.id,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.estatus)
        OrderingTerm(
          expression: ordenServicio.estatus,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.cliente)
        OrderingTerm(
          expression: cliente.nombres,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.fechaCierre)
        OrderingTerm(
          expression: ordenServicio.fechaCierre,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.fechaCreacion)
        OrderingTerm(
          expression: ordenServicio.fechaCreacion,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.folio)
        OrderingTerm(
          expression: ordenServicio.folio,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.metodoPago)
        OrderingTerm(
          expression: ordenHistory.metodoPago,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.restante)
        OrderingTerm(
          expression: ordenServicio.restante,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnsOrdenesNames.total)
        OrderingTerm(
          expression: ordenServicio.total,
          mode: mode,
        ),
    ]);

    return query;
  }

  List<OrdenConDetallesEntry> convertToDetalles(List<TypedResult> rows) {
    return rows.map((row) {
      return OrdenConDetallesEntry(
        orden: row.readTable(ordenServicio),
        detalles: row.readTable(ordenHistory),
        cliente: row.readTable(cliente),
      );
    }).toList();
  }

  // Future<bool> updateOrden(Insertable<OrdenHistoryEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as OrdenHistoryEntry;
  //   final data = casted.copyWith(fechaActualizacion: Value(now));
  //   return update(ordenHistory).replace(data);
  // }
}

// oinedSelectStatement queryJoined() {
//     final query = select(itemServicioOrden).join([
//       innerJoin(
//         preciosConceptos,
//         itemServicioOrden.precioConceptoId.equalsExp(preciosConceptos.id),
//       ),
//       leftOuterJoin(
//         sizesRopa,
//         sizesRopa.id.equalsExp(preciosConceptos.sizeRopaId),
//       ),
//       innerJoin(
//         categoriaServicio,
//         categoriaServicio.id.equalsExp(preciosConceptos.categoriaId),
//       ),
//     ]);

//     return query;
//   }
