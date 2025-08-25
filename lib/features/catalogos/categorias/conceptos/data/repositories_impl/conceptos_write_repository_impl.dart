import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/data/datasources/conceptos_write_data_source.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/extensions/concepto_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_write_repository.dart';

@LazySingleton(as: ConceptosWriteRepository)
class ConceptosWriteRepositoryImpl implements ConceptosWriteRepository {
  final ConceptosWriteDataSource dataSource;

  ConceptosWriteRepositoryImpl(this.dataSource);

  @override
  Future<int> createConcepto(ConceptoEntity concepto) async {
    final model = concepto.toModel();
    final id = await dataSource.insertCategoria(model);
    return id;
  }

  @override
  Future<void> deleteConcepto(ConceptoEntity concepto) async {
    final model = concepto.toModel();
    await dataSource.deleteCategoria(model);
  }

  @override
  Future<void> updateConcepto(ConceptoEntity concepto) async {
    await dataSource.updateCategoria(concepto.toModel());
  }
}
