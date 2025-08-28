import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_read_repository.dart';

@lazySingleton
class ObservePreciosBySize {
  final PreciosReadRepository repository;

  ObservePreciosBySize(this.repository);

  Stream<List<PrecioConDetallesEntity>> call({
    required int sizeId,
    required FiltrosPrecios filtros,
  }) {
    return repository.watchAllBySize(
      sizeId: sizeId,
      filtros: filtros,
    );
  }
}
