import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/error/validate_exception.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/estatus_orden_type.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';

export 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
export 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';
export 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
export 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/estatus_orden_type.dart';

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

  // double get restanteReal => total - adelantoPago;
  // double get totalReal => total;

  bool get hasCliente => cliente.id != -1;
  bool get hasItems => items.isNotEmpty;
  bool get hasAdelanto => adelantoPago > 0;
  bool get hasMetodoPago => metodoPago != null;
  bool get isCerrada => estatus == EstatusOrdenType.cerrada;

  String get title => 'Orden: $folio';
  String get creacion => 'Creada: ${fechaCreacion.formatDate}';

  void validate() {
    final errors = <String>[];

    if (!hasCliente) {
      errors.add(' - Debe seleccionar un cliente para la orden de servicio.');
    }
    if (!hasItems) {
      errors.add(' - Debe agregar al menos un concepto a la orden de servicio.');
    }
    if (hasAdelanto && !hasMetodoPago) {
      errors.add(' - Debe seleccionar un método de pago si hay un adelanto.');
    }

    if (errors.isNotEmpty) {
      final unionError = errors.join('\n');
      throw ValidateException(message: unionError);
    }
  }
}
