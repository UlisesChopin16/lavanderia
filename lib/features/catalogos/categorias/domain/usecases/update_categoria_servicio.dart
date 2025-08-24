import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/repositories/categoria_servicio_write_repository.dart';

@lazySingleton
class UpdateCategoriaServicio {
  final CategoriaServicioWriteRepository repository;

  UpdateCategoriaServicio(this.repository);

  Future<void> call(CategoriaServicioEntity categoriaServicio) {
    return repository.updateCategoriaServicio(categoriaServicio);
  }
}