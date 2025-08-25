import 'package:freezed_annotation/freezed_annotation.dart';

part 'concepto_model.freezed.dart';
part 'concepto_model.g.dart';

@freezed
sealed class ConceptoModel with _$ConceptoModel {
  const factory ConceptoModel({
    required int id,
    required int categoriaId,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ConceptoModel;

  factory ConceptoModel.fromJson(Map<String, dynamic> json) =>
      _$ConceptoModelFromJson(json);
}
