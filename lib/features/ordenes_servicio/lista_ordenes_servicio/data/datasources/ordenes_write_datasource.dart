import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_model/orden_con_detalles_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/extensions/item_con_precio_ext.dart';

@lazySingleton
class OrdenesWriteDatasource {
  final OrdenHistoryDao ordenHistoryDao;
  final OrdenServicioDao ordenServicioDao;
  final ItemServicioOrdenDao itemServicioOrdenDao;

  const OrdenesWriteDatasource({
    required this.ordenHistoryDao,
    required this.ordenServicioDao,
    required this.itemServicioOrdenDao,
  });

  Future<void> insertOrdenWithItems(OrdenConDetallesModel orden) async {
    final companion = orden.toOrdenCompanion();
    final ordenId = await ordenServicioDao.insertOrden(companion);
    final companionHistory = orden.toHistoryCompanion(ordenId.id);
    await ordenHistoryDao.insertOrden(companionHistory);
    for (final item in orden.items) {
      final itemWithOrdenId = item.toCompanion(ordenId.id);
      await itemServicioOrdenDao.insertItem(itemWithOrdenId);
    }
  }
}
