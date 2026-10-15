import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item_model.freezed.dart';
part 'history_item_model.g.dart';

@freezed
sealed class HistoryItemModel with _$HistoryItemModel {
  const factory HistoryItemModel({
    required int id,
    required int ordenId,
    required double monto,
    required double restante,
    required String metodoPago, // "Efectivo", "Tarjeta", "Transferencia"
    required DateTime fecha,
  }) = _HistoryItemModel;

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) => _$HistoryItemModelFromJson(json);
}