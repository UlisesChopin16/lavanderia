import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_model/precio_con_detalles_model.dart';

part 'item_con_precio_model.freezed.dart';
part 'item_con_precio_model.g.dart';

@freezed
sealed class ItemConPrecioModel with _$ItemConPrecioModel {
  const factory ItemConPrecioModel({
    required int id,
    required int ordenId,
    required PrecioConDetallesModel precio,
    required int cantidad,
    required double importe,
    required bool estaEntregado,
    required DateTime fechaEntrega,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemConPrecioModel;

  factory ItemConPrecioModel.fromJson(Map<String, dynamic> json) =>
      _$ItemConPrecioModelFromJson(json);
}