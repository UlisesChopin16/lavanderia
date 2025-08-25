import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

abstract class ConceptosReadRepository {
  Future<List<ConceptoEntity>> getAllConceptos();
  Future<ConceptoEntity?> getConceptoById(int id);
  Stream<List<ConceptoEntity>> watchAllConceptos({
    required int idCategoria,
    required FiltrosBase filtros,
  });
}
