import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';

part 'size_ropa_entity.freezed.dart';

@freezed
sealed class SizesRopaEntity with _$SizesRopaEntity {
  const SizesRopaEntity._();

  const factory SizesRopaEntity({
    @Default(-1) int id,
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(null) DateTime? fechaCreacion,
    @Default(null) DateTime? fechaActualizacion,
    @Default(null) DateTime? fechaEliminacion,
  }) = _SizesRopaEntity;

  bool get isInactive => estatus == EstatusType.inactivo;
}

// required int id,
    // required String nombre,
    // required String estatus,
    // required DateTime fechaCreacion,
    // DateTime? fechaActualizacion,
    // DateTime? fechaEliminacion,