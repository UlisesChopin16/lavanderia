
import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_write_repository.dart';

@lazySingleton
class CreateCliente {
  final ClientesWriteRepository repository;

  CreateCliente(this.repository);

  Future<int> call(ClienteEntity cliente) {
    return repository.createCliente(cliente);
  }
}