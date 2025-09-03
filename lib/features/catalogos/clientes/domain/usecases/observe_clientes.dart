import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_read_repository.dart';

@lazySingleton
class ObserveClientes {
  final ClientesReadRepository repository;

  ObserveClientes(this.repository);

  Stream<List<ClienteEntity>> call(FiltrosClientes filtros) => repository.watchAllClientes(filtros);
}