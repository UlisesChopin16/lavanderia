import 'package:injectable/injectable.dart';
import 'package:lavanderia/datasource/local/clientes/clientes_write_data_source.dart';
import 'package:lavanderia/models/data/clientes/cliente_entity.dart';
import 'package:lavanderia/extensions/cliente_ext.dart';
import 'package:lavanderia/repository/clientes/clientes_write_repository.dart';

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
