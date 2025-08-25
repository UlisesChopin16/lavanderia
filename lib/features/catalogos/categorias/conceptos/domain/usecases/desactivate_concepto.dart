import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/repositories/conceptos_write_repository.dart';

@lazySingleton
class DesactivateConcepto {
  final ConceptosWriteRepository repository;

  DesactivateConcepto(this.repository);

  Future<void> call(ConceptoEntity concepto) => repository.deleteConcepto(concepto);
}
