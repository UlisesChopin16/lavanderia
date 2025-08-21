import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/repositories/sizes_ropa_read_repository.dart';

@lazySingleton
class ObserveSizesRopa {
  final SizesRopaReadRepository repository;

  ObserveSizesRopa(this.repository);

  Stream<List<SizesRopaEntity>> call(FiltrosBase filtros) => repository.watchAllSizesRopa(filtros);
}