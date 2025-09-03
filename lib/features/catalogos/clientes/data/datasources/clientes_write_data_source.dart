import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/clientes/data/models/cliente_model.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/extensions/cliente_ext.dart';

@lazySingleton
class ClientesWriteDataSource {
  final ClientesDao clientesDao;

  const ClientesWriteDataSource(this.clientesDao);

  Future<int> insertCliente(ClienteModel cliente) async {
    return await clientesDao.insertCliente(cliente.toCompanion());
  }

  Future<void> updateCliente(ClienteModel cliente) async {
    await clientesDao.updateCliente(cliente.toEntry());
  }
}
