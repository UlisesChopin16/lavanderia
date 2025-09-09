import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/estatus_orden_type.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';

export 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
export 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';

part 'orden_con_detalles_entity.freezed.dart';

@freezed
sealed class OrdenConDetallesEntity with _$OrdenConDetallesEntity {
  const OrdenConDetallesEntity._();

  const factory OrdenConDetallesEntity({
    @Default(-1) int id,
    @Default('') String folio,
    @Default(ClienteEntity()) ClienteEntity cliente,
    @Default('') String descripcion,
    @Default(0.0) double adelantoPago,
    @Default(null) MetodoPagoType? metodoPago,
    @Default(EstatusOrdenType.enCurso) EstatusOrdenType estatus,
    @Default(0.0) double total,
    @Default(0.0) double restante,
    @Default(null) DateTime? fechaCreacion,
    @Default(null) DateTime? fechaCierre,
    @Default([]) List<ItemConPrecioEntity> items,
  }) = _OrdenConDetallesEntity;

  double get restanteReal => total - adelantoPago;
  double get totalReal => total;

  bool get hasCliente => cliente.id != -1;
}