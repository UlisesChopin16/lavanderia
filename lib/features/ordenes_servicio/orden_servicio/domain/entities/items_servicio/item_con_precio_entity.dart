import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

part 'item_con_precio_entity.freezed.dart';

@freezed
sealed class ItemConPrecioEntity with _$ItemConPrecioEntity {
  const ItemConPrecioEntity._();

  const factory ItemConPrecioEntity({
    @Default(-1) int id,
    @Default(-1) int ordenId,
    @Default(PrecioConDetallesEntity()) PrecioConDetallesEntity precio,
    @Default(1.0) double cantidad,
    @Default(0.0) double importe,
    @Default(false) bool estaEntregado,
    @Default(false) bool isSelected,
    @Default(null) DateTime? fechaEntrega,
    @Default(null) DateTime? fechaCreacion,
  }) = _ItemConPrecioEntity;

  factory ItemConPrecioEntity.fromPrecio(PrecioConDetallesEntity precio) {
    DateTime fechaEntrega = DateTime.now();

    if (precio.diasEntrega > 1) {
      Printer.i('Dias de Entrega: ${precio.diasEntrega}');
      fechaEntrega = fechaEntrega.add(Duration(days: precio.diasEntrega));
    }
    Printer.i('Fecha Entrega: $fechaEntrega');

    return ItemConPrecioEntity(
      precio: precio,
      cantidad: 1,
      importe: precio.importe,
      fechaEntrega: fechaEntrega,
    );
  }

  UnitType get unidad => precio.tipoUnidad;
}
