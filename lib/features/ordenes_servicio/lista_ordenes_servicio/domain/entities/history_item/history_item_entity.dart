import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';

part 'history_item_entity.freezed.dart';

@freezed
sealed class HistoryItemEntity with _$HistoryItemEntity {
  const HistoryItemEntity._();

  const factory HistoryItemEntity({
    @Default(-1) int id,
    @Default(-1) int ordenId,
    @Default(0.0) double monto,
    @Default(0.0) double restante,
    @Default(null) MetodoPagoType? metodoPago, // "Efectivo", "Tarjeta", "Transferencia"
    @Default(null) DateTime? fecha,
  }) = _HistoryItemEntity;

  String get metodoPagoString => 'Metodo: ${metodoPago?.value ?? 'N/A'}';
}
