import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/data/datasources/size_ropa_write_data_source.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_write_repository.dart';

@LazySingleton(as: SizesRopaWriteRepository)
class SizesRopaWriteRepositoryImpl implements SizesRopaWriteRepository {
  final SizeRopaWriteDataSource dataSource;

  SizesRopaWriteRepositoryImpl(this.dataSource);

  @override
  Future<int> createSizeRopa(SizesRopaEntity sizeRopa) async {
    final model = sizeRopa.toModel();
    final id = await dataSource.insertSizeRopa(model);
    return id;
  }

  @override
  Future<void> deleteSizeRopa(int id) async {
    await dataSource.deleteSizeRopa(id);
  }

  @override
  Future<void> updateSizeRopa(SizesRopaEntity sizeRopa) async {
    await dataSource.updateSizeRopa(sizeRopa.toModel());
  }
}
