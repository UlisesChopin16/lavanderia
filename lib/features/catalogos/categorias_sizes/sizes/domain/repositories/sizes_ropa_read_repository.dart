import 'package:lavanderia/core/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';

abstract class SizesRopaReadRepository {
  Future<List<SizesRopaEntity>> getAllSizesRopa();
  Future<SizesRopaEntity?> getSizeRopaById(int id);
  Stream<List<SizesRopaEntity>> watchAllSizesRopa(FiltrosBase filtros);
}
