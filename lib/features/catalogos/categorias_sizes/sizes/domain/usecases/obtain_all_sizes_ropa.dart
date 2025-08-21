import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/repositories/sizes_ropa_read_repository.dart';

@lazySingleton
class ObtainAllSizesRopa {
  final SizesRopaReadRepository repository;

  ObtainAllSizesRopa(this.repository);

  Future<List<SizesRopaEntity>> call() {
    return repository.getAllSizesRopa();
  }
}