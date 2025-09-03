import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';

abstract class ClientesWriteRepository {
  Future<int> createCliente(ClienteEntity cliente);
  Future<void> updateCliente(ClienteEntity cliente);
}
