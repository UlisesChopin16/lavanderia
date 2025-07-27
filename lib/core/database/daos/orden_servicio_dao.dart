import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/ordenes_servicio.dart';
import '../app_database.dart';

part 'orden_servicio_dao.g.dart';

@DriftAccessor(tables: [OrdenesServicio])
class OrdenServicioDao extends DatabaseAccessor<AppDatabase>
    with _$OrdenServicioDaoMixin {
  OrdenServicioDao(super.db);

  Future<List<OrdenServicioEntry>> getAll() => select(ordenesServicio).get();
  
  Stream<List<OrdenServicioEntry>> watchAll() => select(ordenesServicio).watch();

  Future<OrdenServicioEntry?> getById(int id) => (select(
    ordenesServicio,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertOrden(Insertable<OrdenServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as OrdenServicioEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
    return into(ordenesServicio).insert(data);
  }

  Future<bool> updateOrden(Insertable<OrdenServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as OrdenServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(ordenesServicio).replace(data);
  }

  Future<bool> deleteOrden(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(ordenesServicio).replace(updated);
  }
}
