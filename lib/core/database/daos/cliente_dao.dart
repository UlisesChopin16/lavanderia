import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/cliente.dart';
import '../app_database.dart';

part 'cliente_dao.g.dart';

@DriftAccessor(tables: [Cliente])
class ClientesDao extends DatabaseAccessor<AppDatabase>
    with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Future<List<ClienteEntry>> getAll() => select(cliente).get();

  Stream<List<ClienteEntry>> watchAll() => select(cliente).watch();

  // Future<ClienteEntry?> getById(int id) =>
  //     (select(cliente)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  // Obtener un cliente por ID o nombre
  Future<ClienteEntry?> getById(int id) =>
      (select(cliente)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  Future<ClienteEntry?> getByName(String name) =>
      (select(cliente)..where((tbl) => tbl.nombres.equals(name))).getSingleOrNull();

  Future<int> insertCliente(Insertable<ClienteEntry> row) {
    final now = DateTime.now();
    final casted = row as ClienteEntry;
    final clienteWithDate = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );

    return into(cliente).insert(clienteWithDate);
  }

  Future<bool> updateCliente(Insertable<ClienteEntry> row) {
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final casted = row as ClienteEntry;
    final clienteWithDate = casted.copyWith(fechaActualizacion: Value(now));

    return update(cliente).replace(clienteWithDate);
  }

  Future<bool> deleteCliente(int id) async {
    // Soft delete: set fechaEliminacion to now instead of deleting the record
    final now = DateTime.now();
    final clienteData = await getById(id);
    if (clienteData == null) {
      return Future.value(false); // No record found to delete
    }

    final updatedCliente = clienteData.copyWith(fechaEliminacion: Value(now));

    return update(cliente).replace(updatedCliente);
  }
}
