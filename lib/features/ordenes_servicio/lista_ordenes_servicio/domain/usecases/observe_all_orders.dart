import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_read_repository.dart';

@lazySingleton
class ObserveAllOrders {
  final OrdenesReadRepository repository;

  ObserveAllOrders(this.repository);

  Stream<List<OrdenConDetallesEntity>> call(FiltrosOrdenes filtros) {
    return repository.observeAll(filtros);
  }

}