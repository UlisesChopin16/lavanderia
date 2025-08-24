
import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/repositories/categoria_servicio_write_repository.dart';

@lazySingleton
class CreateCategoriaServicio {
  final CategoriaServicioWriteRepository repository;

  CreateCategoriaServicio(this.repository);

  Future<int> call(CategoriaServicioEntity categoriaServicio) {
    return repository.createCategoriaServicio(categoriaServicio);
  }
}