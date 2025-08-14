import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_read_repository.dart';

@lazySingleton
class ObtainAllSizesRopa {
  final SizesRopaReadRepository repository;

  ObtainAllSizesRopa(this.repository);

  Future<List<SizesRopaEntity>> call() {
    return repository.getAllSizesRopa();
  }
}