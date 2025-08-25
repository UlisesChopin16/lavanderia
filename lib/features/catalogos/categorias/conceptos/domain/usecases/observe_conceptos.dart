import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_read_repository.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

@lazySingleton
class ObserveConceptos {
  final ConceptosReadRepository repository;

  ObserveConceptos(this.repository);

  Stream<List<ConceptoEntity>> call({
    required int idCategoria,
    required FiltrosBase filtros,
  }) =>
      repository.watchAllConceptos(
        idCategoria: idCategoria,
        filtros: filtros,
      );
}
