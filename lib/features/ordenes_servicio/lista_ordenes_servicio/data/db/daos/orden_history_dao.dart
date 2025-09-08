import 'package:drift/drift.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/orden_history.dart';
import '../../../../../../core/database/app_database.dart';

part 'orden_history_dao.g.dart';

@DriftAccessor(tables: [OrdenHistory])
class OrdenHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$OrdenHistoryDaoMixin {
  OrdenHistoryDao(super.db);

  // Future<List<OrdenHistoryEntry>> getAll() => select(ordenHistory).get();

  // Stream<List<OrdenHistoryEntry>> watchAll() => select(ordenHistory).watch();

  // Future<OrdenHistoryEntry?> getById(int id) => (select(
  //   ordenHistory,
  // )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Future<List<OrdenHistoryEntry>> getOrdenesForCliente(int clienteId) => (select(
  //   ordenHistory,
  // )..where((tbl) => tbl.clienteId.equals(clienteId))).get();

  // Future<int> insertOrden(Insertable<OrdenHistoryEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as OrdenHistoryEntry;
  //   final data = casted.copyWith(
  //     fechaCreacion: now,
  //     fechaActualizacion: Value(now),
  //   );
  //   return into(ordenHistory).insert(data);
  // }

  // Future<bool> updateOrden(Insertable<OrdenHistoryEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as OrdenHistoryEntry;
  //   final data = casted.copyWith(fechaActualizacion: Value(now));
  //   return update(ordenHistory).replace(data);
  // }
}
