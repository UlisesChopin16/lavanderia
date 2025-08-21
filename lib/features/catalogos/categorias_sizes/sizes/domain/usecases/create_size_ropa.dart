
import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/repositories/sizes_ropa_write_repository.dart';

@lazySingleton
class CreateSizeRopa {
  final SizesRopaWriteRepository repository;

  CreateSizeRopa(this.repository);

  Future<int> call(SizesRopaEntity sizeRopa) {
    return repository.createSizeRopa(sizeRopa);
  }
}