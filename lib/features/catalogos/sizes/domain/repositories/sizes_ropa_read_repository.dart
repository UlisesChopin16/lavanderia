import 'package:lavanderia/features/catalogos/sizes/domain/entities/size_ropa_entity.dart';

abstract class SizesRopaReadRepository {
  Future<List<SizesRopaEntity>> getAllSizesRopa();
  Future<SizesRopaEntity> getSizeRopaById(int id);
  Stream<List<SizesRopaEntity>> watchAllSizesRopa();
}
