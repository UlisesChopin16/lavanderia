import 'package:lavanderia/models/data/ordenes/orden_con_detalles_entity.dart';

abstract class OrdenesWriteRepository {
  Future<OrdenConDetallesEntity> insertOrdenWithItems(OrdenConDetallesEntity orden);
  Future<void> updateOrden(OrdenConDetallesEntity orden);
  Future<void> updateItemsOrden(OrdenConDetallesEntity orden);
}