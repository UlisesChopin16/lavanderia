import 'package:freezed_annotation/freezed_annotation.dart';

part 'orden_servicio_entity.freezed.dart';

@freezed
sealed class OrdenServicioEntity with _$OrdenServicioEntity {
  const factory OrdenServicioEntity({
    required String id,
    required String clienteId,
    required String folio,
    required DateTime fechaEntrega,
    required DateTime fechaLista,
    required DateTime fechaRecogida,
    String? descripcion,
    required String estatus,
    required double total,
    required String metodoPago,
    double? pago,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,

    /// ✅ Relación 1:N
    @Default([]) List<ItemOrdenEntity> items,
  }) = _OrdenServicioEntity;
}

@freezed
sealed class ItemOrdenEntity with _$ItemOrdenEntity {
  const factory ItemOrdenEntity({
    required String id,
    required String ordenId,
    required String itemId,
    required double cantidad,
    required double importe,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemOrdenEntity;
}