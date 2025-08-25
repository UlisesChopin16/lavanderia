import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';

part 'categoria_servicio_entity.freezed.dart';

@freezed
sealed class CategoriaServicioEntity with _$CategoriaServicioEntity {
  const CategoriaServicioEntity._();

  const factory CategoriaServicioEntity({
    @Default(-1) int id,
    @Default('') String nombre,
    @Default(EstatusType.inactivo) EstatusType estatus,
    @Default(null) DateTime? fechaCreacion,
    @Default(null) DateTime? fechaActualizacion,
    @Default(null) DateTime? fechaEliminacion,
  }) = _CategoriaServicioEntity;

  bool get isInactive => estatus == EstatusType.inactivo;
}

// required int id,
    // required String nombre,
    // required String estatus,
    // required DateTime fechaCreacion,
    // DateTime? fechaActualizacion,
    // DateTime? fechaEliminacion,