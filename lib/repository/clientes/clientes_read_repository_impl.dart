import 'package:injectable/injectable.dart';
import 'package:lavanderia/datasource/local/clientes/clientes_read_data_source.dart';
import 'package:lavanderia/models/data/clientes/cliente_entity.dart';
import 'package:lavanderia/models/data/clientes/filtros_clientes.dart';
import 'package:lavanderia/extensions/cliente_ext.dart';
import 'package:lavanderia/repository/clientes/clientes_read_repository.dart';

@LazySingleton(as: ClientesReadRepository)
class ClientesReadRepositoryImpl implements ClientesReadRepository {
  final ClientesReadDataSource dataSource;

  const ClientesReadRepositoryImpl(this.dataSource);

  @override
  Future<List<ClienteEntity>> getAllClientes() async {
    final clientes = await dataSource.getAllClientes();
    return clientes.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ClienteEntity?> getClienteById(int id) async {
    final cliente = await dataSource.getClienteById(id);
    return cliente?.toEntity();
  }

  @override
  Future<List<ClienteEntity>> getClientesByInfo(String info) async {
    final clientes = await dataSource.getClientesByInfo(info);
    return clientes.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<ClienteEntity>> watchAllClientes(FiltrosClientes filtros) {
    final stream = dataSource.watchAllClientes(filtros);
    final mappedStream = stream.map(
      (sizes) => sizes.map((e) => e.toEntity()).toList(),
    );
    return mappedStream;
  }
}
