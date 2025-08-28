import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/data/datasources/categoria_servicio_write_data_source.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/repositories/categoria_servicio_write_repository.dart';

@LazySingleton(as: CategoriaServicioWriteRepository)
class CategoriaServicioWriteRepositoryImpl implements CategoriaServicioWriteRepository {
  final CategoriaServicioWriteDataSource dataSource;

  CategoriaServicioWriteRepositoryImpl(this.dataSource);

  @override
  Future<int> createCategoriaServicio(CategoriaServicioEntity categoriaServicio) async {
    final model = categoriaServicio.toModel();
    final id = await dataSource.insertCategoria(model);
    return id;
  }

  @override
  Future<void> deleteCategoriaServicio(CategoriaServicioEntity entity) async {
    final model = entity.toModel();
    await dataSource.deleteCategoria(model);
  }

  @override
  Future<void> updateCategoriaServicio(CategoriaServicioEntity categoriaServicio) async {
    await dataSource.updateCategoria(categoriaServicio.toModel());
  }
}
