import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/data/datasources/conceptos_read_data_source.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/extensions/concepto_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_read_repository.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

@LazySingleton(as: ConceptosReadRepository)
class ConceptosReadRepositoryImpl implements ConceptosReadRepository {
  final ConceptosReadDataSource dataSource;

  const ConceptosReadRepositoryImpl(this.dataSource);

  @override
  Future<List<ConceptoEntity>> getAllConceptos() async {
    final conceptos = await dataSource.getAllConceptos();
    return conceptos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ConceptoEntity?> getConceptoById(int id) async {
    final concepto = await dataSource.getConceptoById(id);
    return concepto?.toEntity();
  }

  @override
  Stream<List<ConceptoEntity>> watchAllConceptos({
    required int idCategoria,
    required FiltrosBase filtros,
  }) {
    final stream = dataSource.watchAllConceptos(
      filtros: filtros,
      idCategoria: idCategoria,
    );
    final mappedStream = stream.map(
      (categorias) => categorias.map((e) => e.toEntity()).toList(),
    );
    return mappedStream;
  }
}
