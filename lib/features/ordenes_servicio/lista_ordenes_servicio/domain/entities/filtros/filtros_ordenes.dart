import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/range_dates_types.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/columns_ordenes_names.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/estatus_orden_type.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';
export 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/columns_ordenes_names.dart';
export 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/estatus_orden_type.dart';

part 'filtros_ordenes.freezed.dart';

@freezed
sealed class FiltrosOrdenes with _$FiltrosOrdenes {
  const FiltrosOrdenes._();
  const factory FiltrosOrdenes({
    @Default('') String busqueda,
    @Default(EstatusOrdenType.todos) EstatusOrdenType estatus,
    @Default(false) bool ascendente,
    @Default(null) MetodoPagoType? metodoPago,
    @Default(ColumnsOrdenesNames.fechaCreacion) ColumnsOrdenesNames ordenamiento,
    @Default([]) List<DateTime?> fechas,
    // @Default(null) DateTime? fechaInicio,
  }) = _FiltrosOrdenes;

  bool get fechasAreEquals {
    return listEquals(fechas, RangeDatesTypes.month.range);
  }

  bool get haveFilters {
    return estatus != EstatusOrdenType.todos ||
        ordenamiento != ColumnsOrdenesNames.fechaCreacion ||
        metodoPago != null ||
        !fechasAreEquals ||
        busqueda.isNotEmpty;
  }
}
