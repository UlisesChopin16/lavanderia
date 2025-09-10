import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/datasources/ordenes_read_datasource.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/history_item_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/item_con_precio_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_read_repository.dart';

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
  Stream<List<OrdenConDetallesEntity>> observeAll() {
    final stream = _datasource.observeAll();
    return stream.map((ordenes) => ordenes.map((e) => e.toEntity()).toList());
  }
}
