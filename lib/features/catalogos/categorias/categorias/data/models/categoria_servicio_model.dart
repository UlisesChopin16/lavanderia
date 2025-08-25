import 'package:freezed_annotation/freezed_annotation.dart';

part 'categoria_servicio_model.freezed.dart';
part 'categoria_servicio_model.g.dart';

@freezed
sealed class CategoriaServicioModel with _$CategoriaServicioModel {
  const factory CategoriaServicioModel({
    required int id,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _CategoriaServicioModel;

  factory CategoriaServicioModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriaServicioModelFromJson(json);
}
