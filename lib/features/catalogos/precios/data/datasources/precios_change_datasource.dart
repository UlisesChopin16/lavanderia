import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/categorias/data/models/categoria_servicio_model.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/extensions/categoria_servicio_ext.dart';

@lazySingleton
class PreciosChangeDatasource {
  final PreciosConceptosDao preciosDao;

  PreciosChangeDatasource(this.preciosDao);

  Future<void> activatePreciosByCategoria(int categoriaId) async {
    await preciosDao.activatePreciosByCategoria(categoriaId);
  }

  Future<void> deactivatePreciosByCategoria(int categoriaId) async {
    await preciosDao.deactivatePreciosByCategoria(categoriaId);
  }

  Future<void> changeDiasPreciosByCategoria(CategoriaServicioModel categoria) async {
    final entry = categoria.toEntry();
    await preciosDao.changeDiasPreciosByCategoria(entry);
  }
}
