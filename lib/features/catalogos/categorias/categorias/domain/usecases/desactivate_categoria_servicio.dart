import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/repositories/categoria_servicio_write_repository.dart';

@lazySingleton
class DesactivateCategoriaServicio {
  final CategoriaServicioWriteRepository repository;

  DesactivateCategoriaServicio(this.repository);

  Future<void> call(CategoriaServicioEntity categoriaServicio) =>
      repository.deleteCategoriaServicio(categoriaServicio);
}
