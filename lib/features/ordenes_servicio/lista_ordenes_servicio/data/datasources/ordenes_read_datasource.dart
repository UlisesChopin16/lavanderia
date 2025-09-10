import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/history_item/history_item_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_entry/orden_con_detalles_entry.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_model/orden_con_detalles_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/history_item_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/item_con_precio_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/data/models/items_servicio/item_con_precio_model/item_con_precio_model.dart';

@lazySingleton
class OrdenesReadDatasource {
  final OrdenHistoryDao ordenHistoryDao;
  final OrdenServicioDao ordenServicioDao;
  final ItemServicioOrdenDao itemServicioOrdenDao;

  const OrdenesReadDatasource({
    required this.ordenHistoryDao,
    required this.ordenServicioDao,
    required this.itemServicioOrdenDao,
  });

  Stream<List<OrdenConDetallesModel>> observeAll() {
    final ordenesStream = ordenHistoryDao.watchAll();
    return convertToModel(ordenesStream);
  }

  Future<List<HistoryItemModel>> getHistoryByOrden(int ordenId) async {
    final items = await ordenHistoryDao.getHistoryByOrden(ordenId);
    return items.map((e) => e.toModel()).toList();
  }

  Future<List<ItemConPrecioModel>> getItemsByOrden(int ordenId) async {
    final items = await itemServicioOrdenDao.getItemsByOrden(ordenId);
    return items.map((e) => e.toModel()).toList();
  }
  // Future

  Stream<List<OrdenConDetallesModel>> convertToModel(Stream<List<OrdenConDetallesEntry>> stream) {
    return stream.map(convertToModelList);
  }

  List<OrdenConDetallesModel> convertToModelList(List<OrdenConDetallesEntry> entries) {
    return entries.map((e) => e.toModel()).toList();
  }
}
