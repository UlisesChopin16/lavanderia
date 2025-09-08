import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';

abstract class PreciosChangeRepository {
  Future<void> activatePreciosBySize(int sizeId);
  Future<void> deactivatePreciosBySize(int sizeId);
  Future<void> activatePreciosByCategoria(int categoriaId);
  Future<void> deactivatePreciosByCategoria(int categoriaId);
  Future<void> changeDiasPreciosByCategoria(CategoriaServicioEntity categoria);
}
