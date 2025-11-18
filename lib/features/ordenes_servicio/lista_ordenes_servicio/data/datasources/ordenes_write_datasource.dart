import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/daos/daos.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_model/orden_con_detalles_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/item_con_precio_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/orden_con_detalles_ext.dart';

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

  Future<OrdenConDetallesModel> insertOrdenWithItems(OrdenConDetallesModel orden) async {
    final companion = orden.toOrdenCompanion();
    final ordenId = await ordenServicioDao.insertOrden(companion);

    final companionHistory = orden.toHistoryCompanion(ordenId.id);
    final data = companionHistory.copyWith(fecha: Value(ordenId.fechaActualizacion!));
    await ordenHistoryDao.insertHistory(data);

    for (final item in orden.items) {
      final itemWithOrdenId = item.toCompanion(ordenId.id);
      await itemServicioOrdenDao.insertItem(itemWithOrdenId);
    }

    return orden.copyWith(
      folio: ordenId.folio,
      id: ordenId.id,
      fechaCreacion: ordenId.fechaCreacion,
    );
  }

  Future<void> updateOrden(OrdenConDetallesModel orden) async {
    final entry = orden.toEntry();
    final companionHistory = orden.toHistoryCompanion(orden.id);
    final entryHistory = orden.toHistoryEntry(orden.id);

    final entryOrden = await ordenServicioDao.updateOrden(entry);
    final data = companionHistory.copyWith(fecha: Value(entryOrden.fechaActualizacion!));
    final dataEntry = entryHistory.copyWith(fecha: entryOrden.fechaActualizacion!);

    if (entryHistory.monto > 0) {
      await ordenHistoryDao.insertHistory(data);
      return;
    }
    await ordenHistoryDao.updateHistory(dataEntry);
  }

  Future<void> updateItemsOrden(OrdenConDetallesModel orden) async {
    final items = orden.items;
    for (final item in items) {
      final itemWithOrdenId = item.toEntry();
      await itemServicioOrdenDao.updateItem(itemWithOrdenId);
    }
  }
}
