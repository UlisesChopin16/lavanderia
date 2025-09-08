import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/features/catalogos/precios/data/datasources/precios_change_datasource.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_change_repository.dart';

@LazySingleton(as: PreciosChangeRepository)
class PreciosChangeRepositoryImpl implements PreciosChangeRepository {
  final PreciosChangeDatasource datasource;

  const PreciosChangeRepositoryImpl(this.datasource);

  @override
  Future<void> activatePreciosBySize(int sizeId) async {
    await datasource.activatePreciosBySize(sizeId);
  }

  @override
  Future<void> deactivatePreciosBySize(int sizeId) async {
    await datasource.deactivatePreciosBySize(sizeId);
  }

  @override
  Future<void> activatePreciosByCategoria(int categoriaId) async {
    await datasource.activatePreciosByCategoria(categoriaId);
  }

  @override
  Future<void> deactivatePreciosByCategoria(int categoriaId) async {
    await datasource.deactivatePreciosByCategoria(categoriaId);
  }

  @override
  Future<void> changeDiasPreciosByCategoria(CategoriaServicioEntity categoria) async {
    final model = categoria.toModel();
    await datasource.changeDiasPreciosByCategoria(model);
  }
}
