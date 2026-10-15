import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/models/data/categorias/filtros_categoria.dart';

abstract class CategoriaServicioReadRepository {
  Future<List<CategoriaServicioEntity>> getAllCategoriasServicios();
  Future<CategoriaServicioEntity?> getCategoriaServicioById(int id);
  Stream<List<CategoriaServicioEntity>> watchAllCategoriasServicios(FiltrosCategoria filtros);
}
