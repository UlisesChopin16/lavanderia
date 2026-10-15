import 'package:injectable/injectable.dart';
import 'package:lavanderia/datasource/local/ordenes/ordenes_read_datasource.dart';
import 'package:lavanderia/models/data/ordenes/filtros_ordenes.dart';
import 'package:lavanderia/models/data/ordenes/orden_con_detalles_entity.dart';
import 'package:lavanderia/extensions/history_item_ext.dart';
import 'package:lavanderia/extensions/item_con_precio_ext.dart';
import 'package:lavanderia/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/repository/ordenes/ordenes_read_repository.dart';

@LazySingleton(as: OrdenesReadRepository)
class OrdenesReadRepositoryImpl implements OrdenesReadRepository {
  final OrdenesReadDatasource _datasource;

  OrdenesReadRepositoryImpl(this._datasource);

  @override
  Future<List<HistoryItemEntity>> getHistoryByOrden(int ordenId) async {
    final items = await _datasource.getHistoryByOrden(ordenId);
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<ItemConPrecioEntity>> getItemsByOrden(int ordenId) async {
    final items = await _datasource.getItemsByOrden(ordenId);
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<OrdenConDetallesEntity>> observeAll(FiltrosOrdenes filtros) {
    final stream = _datasource.observeAll(filtros);
    return stream.map((ordenes) => ordenes.map((e) => e.toEntity()).toList());
  }
}
