import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';

part 'concepto_entity.freezed.dart';

@freezed
sealed class ConceptoEntity with _$ConceptoEntity {
  const ConceptoEntity._();

  const factory ConceptoEntity({
    @Default(-1) int id,
    @Default(-1) int categoriaId,
    @Default('') String nombre,
    @Default(EstatusType.inactivo) EstatusType estatus,
    @Default(null) DateTime? fechaCreacion,
    @Default(null) DateTime? fechaActualizacion,
    @Default(null) DateTime? fechaEliminacion,
  }) = _ConceptoEntity;

  bool get isInactive => estatus == EstatusType.inactivo;
}
