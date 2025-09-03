import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/clientes/data/datasources/clientes_write_data_source.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/extensions/cliente_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/repositories/clientes_write_repository.dart';

@LazySingleton(as: ClientesWriteRepository)
class ClientesWriteRepositoryImpl implements ClientesWriteRepository {
  final ClientesWriteDataSource dataSource;

  ClientesWriteRepositoryImpl(this.dataSource);

  @override
  Future<int> createCliente(ClienteEntity cliente) async {
    final model = cliente.toModel();
    final id = await dataSource.insertCliente(model);
    return id;
  }

  @override
  Future<void> updateCliente(ClienteEntity cliente) async {
    await dataSource.updateCliente(cliente.toModel());
  }
}
