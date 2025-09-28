import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_read_repository.dart';
export 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

@lazySingleton
class ObtainItems {
  final OrdenesReadRepository repository;

  ObtainItems(this.repository);

  Future<List<ItemConPrecioEntity>> call(int idOrden) {
    return repository.getItemsByOrden(idOrden);
  }
}
