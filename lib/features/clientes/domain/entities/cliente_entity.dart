import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente_entity.freezed.dart';

@freezed
sealed class ClienteEntity with _$ClienteEntity {
  const factory ClienteEntity({
    required int id,
    required String nombres,
    required String apellidos,
    required String correo,
    required String telefono,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ClienteEntity;
}