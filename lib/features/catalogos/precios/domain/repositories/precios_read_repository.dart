import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

abstract class PreciosReadRepository {
  Stream<List<PrecioConDetallesEntity>> watchAllBySize({
    required int sizeId,
    required FiltrosPrecios filtros,
  });

  Stream<List<PrecioConDetallesEntity>> watchAllByCategoria({
    required int categoriaId,
    required FiltrosPrecios filtros,
  });
  
  Stream<List<PrecioConDetallesEntity>> watchAll({
    required FiltrosPrecios filtros
  });
}
