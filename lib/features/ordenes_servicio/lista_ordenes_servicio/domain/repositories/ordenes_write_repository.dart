import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

abstract class OrdenesWriteRepository {
  Future<void> insertOrdenWithItems(OrdenConDetallesEntity orden);
  Future<void> updateOrden(OrdenConDetallesEntity orden);
  Future<void> updateItemsOrden(OrdenConDetallesEntity orden);
}