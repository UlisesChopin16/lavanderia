import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_write_repository.dart';

@lazySingleton
class UpdateCliente {
  final ClientesWriteRepository repository;

  UpdateCliente(this.repository);

  Future<void> call(ClienteEntity cliente) {
    return repository.updateCliente(cliente);
  }
}