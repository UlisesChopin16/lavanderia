import 'package:lavanderia/features/catalogos/categorias/domain/entities/categorias/categoria_servicio_entity.dart';

abstract class CategoriaServicioWriteRepository {
  Future<int> createCategoriaServicio(CategoriaServicioEntity categoriaServicio);
  Future<void> updateCategoriaServicio(CategoriaServicioEntity categoriaServicio);
  Future<void> deleteCategoriaServicio(CategoriaServicioEntity categoriaServicio);
}
