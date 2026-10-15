import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';

abstract class PreciosChangeRepository {
  Future<void> activatePreciosByCategoria(int categoriaId);
  Future<void> deactivatePreciosByCategoria(int categoriaId);
  Future<void> changeDiasPreciosByCategoria(CategoriaServicioEntity categoria);
}
