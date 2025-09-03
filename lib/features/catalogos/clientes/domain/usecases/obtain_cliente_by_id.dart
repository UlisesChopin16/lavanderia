import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_read_repository.dart';

@lazySingleton
class ObtainClienteById {
  final ClientesReadRepository repository;

  ObtainClienteById(this.repository);

  Future<ClienteEntity?> call(int id) => repository.getClienteById(id);

}