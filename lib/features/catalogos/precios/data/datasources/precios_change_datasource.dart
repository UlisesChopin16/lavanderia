import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';

@lazySingleton
class PreciosChangeDatasource {
  final PreciosConceptosDao preciosDao;

  PreciosChangeDatasource(this.preciosDao);

  Future<void> activatePreciosBySize(int sizeId) async {
    await preciosDao.activatePreciosBySize(sizeId);
  }

  Future<void> deactivatePreciosBySize(int sizeId) async {
    await preciosDao.deactivatePreciosBySize(sizeId);
  }

  Future<void> activatePreciosByCategoria(int categoriaId) async {
    await preciosDao.activatePreciosByCategoria(categoriaId);
  }

  Future<void> deactivatePreciosByCategoria(int categoriaId) async {
    await preciosDao.deactivatePreciosByCategoria(categoriaId);
  }
}
