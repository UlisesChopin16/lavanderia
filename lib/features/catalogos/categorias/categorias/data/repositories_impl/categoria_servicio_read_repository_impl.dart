import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/data/datasources/categoria_servicio_read_data_source.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/repositories/categoria_servicio_read_repository.dart';

@LazySingleton(as: CategoriaServicioReadRepository)
class CategoriaServicioReadRepositoryImpl implements CategoriaServicioReadRepository {
  final CategoriaServicioReadDataSource dataSource;

  const CategoriaServicioReadRepositoryImpl(this.dataSource);

  @override
  Future<List<CategoriaServicioEntity>> getAllCategoriasServicios() async {
    final categorias = await dataSource.getAllCategorias();
    return categorias.map((e) => e.toEntity()).toList();
  }

  @override
  Future<CategoriaServicioEntity?> getCategoriaServicioById(int id) async {
    final categoria = await dataSource.getCategoriaById(id);
    return categoria?.toEntity();
  }

  @override
  Stream<List<CategoriaServicioEntity>> watchAllCategoriasServicios(FiltrosBase filtros) {
    final stream = dataSource.watchAllCategorias(filtros);
    final mappedStream = stream.map(
          (categorias) => categorias.map((e) => e.toEntity()).toList(),
        );
    return mappedStream;
  }
}
