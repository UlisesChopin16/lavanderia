import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/models/dto/clientes/cliente_model.dart';
import 'package:lavanderia/extensions/cliente_ext.dart';

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
