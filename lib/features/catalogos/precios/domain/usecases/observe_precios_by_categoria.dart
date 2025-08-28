import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_read_repository.dart';

@lazySingleton
class ObservePreciosByCategoria {
  final PreciosReadRepository repository;

  ObservePreciosByCategoria(this.repository);

  Stream<List<PrecioConDetallesEntity>> call({
    required int categoriaId,
    required FiltrosPrecios filtros,
  }) {
    return repository.watchAllByCategoria(
      categoriaId: categoriaId,
      filtros: filtros,
    );
  }
}
