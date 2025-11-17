import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_write_repository.dart';

@lazySingleton
class UpdateOrden {
  final OrdenesWriteRepository repository;
  
  UpdateOrden(this.repository);

  Future<void> call(OrdenConDetallesEntity orden) async {
    return await repository.updateOrden(orden);
  }
}