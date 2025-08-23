import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_write_repository.dart';

@lazySingleton
class UpdateSizeRopa {
  final SizesRopaWriteRepository repository;

  UpdateSizeRopa(this.repository);

  Future<void> call(SizesRopaEntity sizeRopa) {
    return repository.updateSizeRopa(sizeRopa);
  }
}