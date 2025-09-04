import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

part 'item_con_precio_entity.freezed.dart';

@freezed
sealed class ItemConPrecioEntity with _$ItemConPrecioEntity {
  const ItemConPrecioEntity._();

  const factory ItemConPrecioEntity({
    @Default(-1) int id,
    @Default(-1) int ordenId,
    @Default(PrecioConDetallesEntity()) PrecioConDetallesEntity precio,
    @Default(0) int cantidad,
    @Default(0.0) double importe,
    @Default(false) bool estaEntregado,
    @Default(false) bool isSelected,
    @Default(null) DateTime? fechaEntrega,
    @Default(null) DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemConPrecioEntity;

  factory ItemConPrecioEntity.fromPrecio(PrecioConDetallesEntity precio) {
    final fechaEntrega = DateTime.now();

    if(precio.diasEntrega > 1) fechaEntrega.add(Duration(days: precio.diasEntrega));
    
    return ItemConPrecioEntity(
      precio: precio,
      cantidad: 1,
      importe: precio.importe,
      fechaEntrega: fechaEntrega,
    );
  }
}
