import 'package:lavanderia/models/data/clientes/cliente_entity.dart';

abstract class ClientesWriteRepository {
  Future<int> createCliente(ClienteEntity cliente);
  Future<void> updateCliente(ClienteEntity cliente);
}
