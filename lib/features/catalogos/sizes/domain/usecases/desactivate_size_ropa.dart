import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_write_repository.dart';

@lazySingleton
class DesactivateSizeRopa {
  final SizesRopaWriteRepository repository;

  DesactivateSizeRopa(this.repository);

  Future<void> call(SizesRopaEntity sizeRopa) => repository.deleteSizeRopa(sizeRopa);
}
