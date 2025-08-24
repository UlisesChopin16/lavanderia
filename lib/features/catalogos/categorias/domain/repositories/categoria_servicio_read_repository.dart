import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categorias/categoria_servicio_entity.dart';

abstract class CategoriaServicioReadRepository {
  Future<List<CategoriaServicioEntity>> getAllCategoriasServicios();
  Future<CategoriaServicioEntity?> getCategoriaServicioById(int id);
  Stream<List<CategoriaServicioEntity>> watchAllCategoriasServicios(FiltrosBase filtros);
}
