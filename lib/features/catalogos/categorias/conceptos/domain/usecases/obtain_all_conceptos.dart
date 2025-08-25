import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_read_repository.dart';

@lazySingleton
class ObtainAllConceptos {
  final ConceptosReadRepository repository;

  ObtainAllConceptos(this.repository);

  Future<List<ConceptoEntity>> call() {
    return repository.getAllConceptos();
  }
}
