import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/sizes/data/models/sizes_ropa_model.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';

@lazySingleton
class SizeRopaWriteDataSource {
  final SizesRopaDao sizesRopaDao;

  const SizeRopaWriteDataSource(this.sizesRopaDao);

  Future<int> insertSizeRopa(SizesRopaModel sizeRopa) async {
    return await sizesRopaDao.insertSizes(sizeRopa.toCompanion());
  }

  Future<void> updateSizeRopa(SizesRopaModel sizeRopa) async {
    await sizesRopaDao.updateSizes(sizeRopa.toEntry());
  }

  Future<void> deleteSizeRopa(SizesRopaModel model) async {
    final entry = model.toEntry();
    await sizesRopaDao.deleteSizes(entry);
  }
}
