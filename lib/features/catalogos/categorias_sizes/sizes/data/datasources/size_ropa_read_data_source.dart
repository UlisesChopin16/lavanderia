
import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/core/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/data/models/sizes_ropa_model.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/extensions/sizes_ropa_ext.dart';

@lazySingleton
class SizeRopaReadDataSource {
  final SizesRopaDao sizesRopaDao;

  const SizeRopaReadDataSource(this.sizesRopaDao);

  Future<List<SizesRopaModel>> getAllSizesRopa() async {
    final sizesRopa = await sizesRopaDao.getAll();
    return sizesRopa.map((e) => e.toModel()).toList();
  }

  Future<SizesRopaModel?> getSizeRopaById(int id) async {
    final sizeRopa = await sizesRopaDao.getById(id);
    return sizeRopa?.toModel();
  }

  Stream<List<SizesRopaModel>> watchAllSizesRopa(FiltrosBase filtros) {
    final sizesRopaStream = sizesRopaDao.watchAll(filtros);
    return sizesRopaStream.map((sizesRopa) => sizesRopa.map((e) => e.toModel()).toList());
  }
}