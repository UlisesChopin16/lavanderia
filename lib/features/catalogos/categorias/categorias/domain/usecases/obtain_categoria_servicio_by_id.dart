import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/repositories/categoria_servicio_read_repository.dart';

@lazySingleton
class ObtainCategoriaServicioById {
  final CategoriaServicioReadRepository repository;

  ObtainCategoriaServicioById(this.repository);

  Future<CategoriaServicioEntity?> call(int id) => repository.getCategoriaServicioById(id);
  
}