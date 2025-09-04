import 'package:drift/drift.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/orden_servicio.dart';
import '../../../../../../core/database/app_database.dart';

part 'orden_servicio_dao.g.dart';

@DriftAccessor(tables: [OrdenServicio])
class OrdenServicioDao extends DatabaseAccessor<AppDatabase>
    with _$OrdenServicioDaoMixin {
  OrdenServicioDao(super.db);

  Future<List<OrdenServicioEntry>> getAll() => select(ordenServicio).get();

  Stream<List<OrdenServicioEntry>> watchAll() => select(ordenServicio).watch();

  Future<OrdenServicioEntry?> getById(int id) => (select(
    ordenServicio,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<OrdenServicioEntry>> getOrdenesForCliente(int clienteId) => (select(
    ordenServicio,
  )..where((tbl) => tbl.clienteId.equals(clienteId))).get();

  Future<int> insertOrden(Insertable<OrdenServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as OrdenServicioEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(ordenServicio).insert(data);
  }

  Future<bool> updateOrden(Insertable<OrdenServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as OrdenServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(ordenServicio).replace(data);
  }

  Future<bool> deleteOrden(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(ordenServicio).replace(updated);
  }
}
