import 'package:lavanderia/models/data/precios/filtros_precios.dart';
import 'package:lavanderia/models/data/precios/precio_con_detalles_entity.dart';

abstract class PreciosReadRepository {

  Stream<List<PrecioConDetallesEntity>> watchAllByCategoria({
    required int categoriaId,
    required FiltrosPrecios filtros,
  });
  
  Stream<List<PrecioConDetallesEntity>> watchAll({
    required FiltrosPrecios filtros
  });
  
  Future<List<PrecioConDetallesEntity>> getAll();
}
