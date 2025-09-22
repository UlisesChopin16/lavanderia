import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_read_repository.dart';

@lazySingleton
class ObtainHistory {
  final OrdenesReadRepository repository;

  ObtainHistory(this.repository);

  Future<List<HistoryItemEntity>> call(int idOrden) {
    return repository.getHistoryByOrden(idOrden);
  }
}
