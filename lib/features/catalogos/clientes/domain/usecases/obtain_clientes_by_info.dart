import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_read_repository.dart';

@lazySingleton
class ObtainClienteByInfo {
  final ClientesReadRepository repository;

  ObtainClienteByInfo(this.repository);

  Future<List<ClienteEntity>> call(String info) => repository.getClientesByInfo(info);
}
