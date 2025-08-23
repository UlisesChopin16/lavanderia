import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_read_repository.dart';

@lazySingleton
class ObtainSizeRopaById {
  final SizesRopaReadRepository repository;

  ObtainSizeRopaById(this.repository);

  Future<SizesRopaEntity?> call(int id) => repository.getSizeRopaById(id);
  
}