import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_read_repository.dart';

@lazySingleton
class ObtainAllClientes {
  final ClientesReadRepository repository;

  ObtainAllClientes(this.repository);

  Future<List<ClienteEntity>> call() {
    return repository.getAllClientes();
  }
}