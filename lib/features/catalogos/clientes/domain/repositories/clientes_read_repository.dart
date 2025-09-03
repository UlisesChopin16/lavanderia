import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';

abstract class ClientesReadRepository {
  Future<List<ClienteEntity>> getAllClientes();
  Future<ClienteEntity?> getClienteById(int id);
  Future<List<ClienteEntity>> getClientesByInfo(String data);
  Stream<List<ClienteEntity>> watchAllClientes(FiltrosClientes filtros);
}
