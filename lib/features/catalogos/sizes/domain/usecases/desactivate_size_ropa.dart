import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_write_repository.dart';

@lazySingleton
class DesactivateSizeRopa {
  final SizesRopaWriteRepository repository;

  DesactivateSizeRopa(this.repository);

  Future<void> call(int id) => repository.deleteSizeRopa(id);
}