
import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/sizes/data/models/sizes_ropa_model.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';

@lazySingleton
class SizeRopaReadDataSource {
  final SizesRopaDao sizesRopaDao;

  SizeRopaReadDataSource(this.sizesRopaDao);

  Future<List<SizesRopaModel>> getAllSizesRopa() async {
    final sizesRopa = await sizesRopaDao.getAll();
    return sizesRopa.map((e) => e.toModel()).toList();
  }

  Future<SizesRopaModel?> getSizeRopaById(int id) async {
    final sizeRopa = await sizesRopaDao.getById(id);
    return sizeRopa?.toModel();
  }

  Stream<List<SizesRopaModel>> watchAllSizesRopa() {
    final sizesRopaStream = sizesRopaDao.watchAll();
    return sizesRopaStream.map((sizesRopa) => sizesRopa.map((e) => e.toModel()).toList());
  }
}