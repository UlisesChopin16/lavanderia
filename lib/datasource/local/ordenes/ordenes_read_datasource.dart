import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/data/local/ordenes/daos.dart';
import 'package:lavanderia/models/dto/ordenes/history_item_model.dart';
import 'package:lavanderia/data/local/ordenes/orden_con_detalles_entry.dart';
import 'package:lavanderia/models/dto/ordenes/orden_con_detalles_model.dart';
import 'package:lavanderia/models/data/ordenes/filtros_ordenes.dart';
import 'package:lavanderia/extensions/history_item_ext.dart';
import 'package:lavanderia/extensions/item_con_precio_ext.dart';
import 'package:lavanderia/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/models/dto/ordenes/item_con_precio_model.dart';

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

  Stream<List<OrdenConDetallesModel>> observeAll(FiltrosOrdenes filtros) {
    final ordenesStream = ordenHistoryDao.watchAll(filtros);
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
