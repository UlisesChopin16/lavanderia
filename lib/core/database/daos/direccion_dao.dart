import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/direccion.dart';
import '../app_database.dart';

part 'direccion_dao.g.dart';

@DriftAccessor(tables: [Direccion])
class DireccionDao extends DatabaseAccessor<AppDatabase>
    with _$DireccionDaoMixin {
  DireccionDao(super.db);

  Future<List<DireccionEntry>> getAll() => select(direccion).get();

  Stream<List<DireccionEntry>> watchAll() => select(direccion).watch();

  Future<DireccionEntry?> getById(int id) => (select(
    direccion,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertDireccion(Insertable<DireccionEntry> row) {
    final now = DateTime.now();
    final casted = row as DireccionEntry;
    final direccionWithDate = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );

    return into(direccion).insert(direccionWithDate);
  }

  Future<bool> updateDireccion(Insertable<DireccionEntry> row) {
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final casted = row as DireccionEntry;
    final direccionWithDate = casted.copyWith(fechaActualizacion: Value(now));

    return update(direccion).replace(direccionWithDate);
  }

  Future<bool> deleteDireccion(int id) async {
    final now = DateTime.now();
    final direccionData = await getById(id);
    if (direccionData == null) {
      return Future.value(false); // No record found to delete
    }

    final updateDireccion = direccionData.copyWith(
      fechaEliminacion: Value(now),
    );

    return update(direccion).replace(updateDireccion);
  }
}
