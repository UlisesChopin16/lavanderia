import 'package:freezed_annotation/freezed_annotation.dart';

part 'sizes_ropa_model.freezed.dart';
part 'sizes_ropa_model.g.dart';

@freezed
sealed class SizesRopaModel with _$SizesRopaModel {
  const factory SizesRopaModel({
    required int id,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _SizesRopaModel;

  factory SizesRopaModel.fromJson(Map<String, dynamic> json) =>
      _$SizesRopaModelFromJson(json);
}
