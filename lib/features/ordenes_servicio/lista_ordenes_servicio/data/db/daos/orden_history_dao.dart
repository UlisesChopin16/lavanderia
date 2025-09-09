import 'package:drift/drift.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/orden_history.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_entry/orden_con_detalles_entry.dart';
import '../../../../../../core/database/app_database.dart';

part 'orden_history_dao.g.dart';

@DriftAccessor(tables: [OrdenHistory])
class OrdenHistoryDao extends DatabaseAccessor<AppDatabase> with _$OrdenHistoryDaoMixin {
  OrdenHistoryDao(super.db);

  // Future<List<OrdenHistoryEntry>> getAll() => select(ordenHistory).get();
  Stream<List<OrdenConDetallesEntry>> watchAll() {
    final query = queryJoined();
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

  Future<int> insertOrden(OrdenHistoryCompanion row) async {
    final now = DateTime.now();

    final data = row.copyWith(
      fecha: Value(now),
    );

    return await into(ordenHistory).insert(data);
  }

  JoinedSelectStatement queryJoined() {
    final query = select(ordenServicio).join([
      innerJoin(
        ordenHistory,
        ordenHistory.ordenId.equalsExp(ordenServicio.id),
      ),
      innerJoin(
        cliente,
        cliente.id.equalsExp(ordenServicio.clienteId),
      )
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
