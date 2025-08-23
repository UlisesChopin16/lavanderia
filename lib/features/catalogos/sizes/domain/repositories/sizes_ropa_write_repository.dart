import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';

abstract class SizesRopaWriteRepository {
  Future<int> createSizeRopa(SizesRopaEntity sizeRopa);
  Future<void> updateSizeRopa(SizesRopaEntity sizeRopa);
  Future<void> deleteSizeRopa(SizesRopaEntity sizeRopa);
}
