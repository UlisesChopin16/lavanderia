import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente_model.freezed.dart';
part 'cliente_model.g.dart';

@freezed
sealed class ClienteModel with _$ClienteModel {
  const factory ClienteModel({
    required int id,
    required String nombres,
    required String apellidos,
    required String correo,
    required String telefono,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ClienteModel;

  factory ClienteModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteModelFromJson(json);
}
