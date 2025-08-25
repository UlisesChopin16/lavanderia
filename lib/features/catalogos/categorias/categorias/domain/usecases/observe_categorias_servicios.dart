import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/repositories/categoria_servicio_read_repository.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

@lazySingleton
class ObserveCategoriasServicios {
  final CategoriaServicioReadRepository repository;

  ObserveCategoriasServicios(this.repository);

  Stream<List<CategoriaServicioEntity>> call(FiltrosBase filtros) =>
      repository.watchAllCategoriasServicios(filtros);
}
