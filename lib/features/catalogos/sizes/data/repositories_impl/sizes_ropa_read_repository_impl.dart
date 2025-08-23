import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/sizes/data/datasources/size_ropa_read_data_source.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/repositories/sizes_ropa_read_repository.dart';

@LazySingleton(as: SizesRopaReadRepository)
class SizesRopaReadRepositoryImpl implements SizesRopaReadRepository {
  final SizeRopaReadDataSource dataSource;

  const SizesRopaReadRepositoryImpl(this.dataSource);

  @override
  Future<List<SizesRopaEntity>> getAllSizesRopa() async {
    final sizes = await dataSource.getAllSizesRopa();
    return sizes.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SizesRopaEntity?> getSizeRopaById(int id) async {
    final size = await dataSource.getSizeRopaById(id);
    return size?.toEntity();
  }

  @override
  Stream<List<SizesRopaEntity>> watchAllSizesRopa(FiltrosBase filtros) {
    final stream = dataSource.watchAllSizesRopa(filtros);
    final mappedStream = stream.map(
          (sizes) => sizes.map((e) => e.toEntity()).toList(),
        );
    return mappedStream;
  }
}
