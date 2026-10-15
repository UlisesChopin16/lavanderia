import 'package:injectable/injectable.dart';
import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/datasource/local/precios/precios_change_datasource.dart';
import 'package:lavanderia/repository/precios/precios_change_repository.dart';

@LazySingleton(as: PreciosChangeRepository)
class PreciosChangeRepositoryImpl implements PreciosChangeRepository {
  final PreciosChangeDatasource datasource;

  const PreciosChangeRepositoryImpl(this.datasource);

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
