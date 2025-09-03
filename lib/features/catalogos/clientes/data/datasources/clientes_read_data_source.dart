import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/clientes/data/models/cliente_model.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/extensions/cliente_ext.dart';

@lazySingleton
class ClientesReadDataSource {
  final ClientesDao clientesDao;

  const ClientesReadDataSource(this.clientesDao);

  Future<List<ClienteModel>> getAllClientes() async {
    final clientes = await clientesDao.getAll();
    return clientes.map((e) => e.toModel()).toList();
  }

  Future<ClienteModel?> getClienteById(int id) async {
    final cliente = await clientesDao.getById(id);
    return cliente?.toModel();
  }
  Future<List<ClienteModel>> getClientesByInfo(String info) async {
    final clientes = await clientesDao.getClientesByInfo(info);
    return clientes.map((e) => e.toModel()).toList();
  }

  Stream<List<ClienteModel>> watchAllClientes(FiltrosClientes filtros) {
    final clientesStream = clientesDao.watchAll(filtros);
    return clientesStream.map((clientes) => clientes.map((e) => e.toModel()).toList());
  }
}
