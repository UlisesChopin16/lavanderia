import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/filtros/filtros_categoria.dart';

abstract class CategoriaServicioReadRepository {
  Future<List<CategoriaServicioEntity>> getAllCategoriasServicios();
  Future<CategoriaServicioEntity?> getCategoriaServicioById(int id);
  Stream<List<CategoriaServicioEntity>> watchAllCategoriasServicios(FiltrosCategoria filtros);
}
