import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/direcciones.dart';
import '../app_database.dart';

part 'direccion_dao.g.dart';

@DriftAccessor(tables: [Direcciones])
class DireccionesDao extends DatabaseAccessor<AppDatabase>
    with _$DireccionesDaoMixin {
  DireccionesDao(super.db);

  Future<List<DireccionEntry>> getAll() => select(direcciones).get();

  Stream<List<DireccionEntry>> watchAll() => select(direcciones).watch();

  Future<DireccionEntry?> getById(int id) => (select(
    direcciones,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertDireccion(Insertable<DireccionEntry> row) {
    final now = DateTime.now();
    final casted = row as DireccionEntry;
    final direccionWithDate = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );

    return into(direcciones).insert(direccionWithDate);
  }

  Future<bool> updateDireccion(Insertable<DireccionEntry> row) {
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final casted = row as DireccionEntry;
    final direccionWithDate = casted.copyWith(fechaActualizacion: Value(now));

    return update(direcciones).replace(direccionWithDate);
  }

  Future<bool> deleteDireccion(int id) async {
    final now = DateTime.now();
    final direccion = await getById(id);
    if (direccion == null) {
      return Future.value(false); // No record found to delete
    }

    final updateDireccion = direccion.copyWith(
      fechaEliminacion: Value(now),
    );

    return update(direcciones).replace(updateDireccion);
  }
}
