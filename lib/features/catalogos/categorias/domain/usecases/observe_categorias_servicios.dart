import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/filtros/filtros_categoria.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/repositories/categoria_servicio_read_repository.dart';

@lazySingleton
class ObserveCategoriasServicios {
  final CategoriaServicioReadRepository repository;

  ObserveCategoriasServicios(this.repository);

  Stream<List<CategoriaServicioEntity>> call(FiltrosCategoria filtros) =>
      repository.watchAllCategoriasServicios(filtros);
}
