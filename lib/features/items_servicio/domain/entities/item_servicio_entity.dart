import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_servicio_entity.freezed.dart';

@freezed
sealed class ItemServicioEntity with _$ItemServicioEntity {
  const factory ItemServicioEntity({
    required int id,
    required String nombre,
    required String descripcion,
    required double importe,
    required String tipoUnidad,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemServicioEntity;
}