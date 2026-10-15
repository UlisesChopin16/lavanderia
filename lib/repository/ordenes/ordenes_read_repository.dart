import 'package:lavanderia/models/data/ordenes/filtros_ordenes.dart';
import 'package:lavanderia/models/data/ordenes/orden_con_detalles_entity.dart';

abstract class OrdenesReadRepository {
  Stream<List<OrdenConDetallesEntity>> observeAll(FiltrosOrdenes filtros);
  Future<List<HistoryItemEntity>> getHistoryByOrden(int ordenId);
  Future<List<ItemConPrecioEntity>> getItemsByOrden(int ordenId);
}