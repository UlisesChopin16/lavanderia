import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';

abstract class SizesRopaReadRepository {
  Future<List<SizesRopaEntity>> getAllSizesRopa();
  Future<SizesRopaEntity?> getSizeRopaById(int id);
  Stream<List<SizesRopaEntity>> watchAllSizesRopa(FiltrosBase filtros);
}
