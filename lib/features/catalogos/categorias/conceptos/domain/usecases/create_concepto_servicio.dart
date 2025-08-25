import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_write_repository.dart';

@lazySingleton
class CreateConceptoServicio {
  final ConceptosWriteRepository repository;

  CreateConceptoServicio(this.repository);

  Future<int> call(ConceptoEntity concepto) {
    return repository.createConcepto(concepto);
  }
}
