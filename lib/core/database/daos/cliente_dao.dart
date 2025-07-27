import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/clientes.dart';
import '../app_database.dart';

part 'cliente_dao.g.dart';

@DriftAccessor(tables: [Clientes])
class ClientesDao extends DatabaseAccessor<AppDatabase>
    with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Future<List<ClienteEntry>> getAll() => select(clientes).get();

  Stream<List<ClienteEntry>> watchAll() => select(clientes).watch();

  Future<ClienteEntry?> getById(int id) =>
      (select(clientes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertCliente(Insertable<ClienteEntry> cliente) {
    final now = DateTime.now();
    final casted = cliente as ClienteEntry;
    final clienteWithDate = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: Value(now),

    );

    return into(clientes).insert(clienteWithDate);
  }

  Future<bool> updateCliente(Insertable<ClienteEntry> cliente) {
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final casted = cliente as ClienteEntry;
    final clienteWithDate = casted.copyWith(fechaActualizacion: Value(now));

    return update(clientes).replace(clienteWithDate);
  }

  Future<bool> deleteCliente(int id) async {
    // Soft delete: set fechaEliminacion to now instead of deleting the record
    final now = DateTime.now();
    final cliente = await getById(id);
    if (cliente == null) {
      return Future.value(false); // No record found to delete
    }

    final updatedCliente = cliente.copyWith(
      fechaEliminacion: Value(now),
    );

    return update(clientes).replace(updatedCliente);
  }
}
