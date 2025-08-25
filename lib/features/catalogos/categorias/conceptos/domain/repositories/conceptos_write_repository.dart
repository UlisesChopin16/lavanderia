import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';

abstract class ConceptosWriteRepository {
  Future<int> createConcepto(ConceptoEntity concepto);
  Future<void> updateConcepto(ConceptoEntity concepto);
  Future<void> deleteConcepto(ConceptoEntity concepto);
}
