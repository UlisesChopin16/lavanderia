import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

abstract class OrdenesReadRepository {
  Stream<List<OrdenConDetallesEntity>> observeAll();
  Future<List<HistoryItemEntity>> getHistoryByOrden(int ordenId);
  Future<List<ItemConPrecioEntity>> getItemsByOrden(int ordenId);
}