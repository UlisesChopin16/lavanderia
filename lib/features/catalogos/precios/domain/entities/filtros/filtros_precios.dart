import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/types/column_precios_name.dart';
import 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
export 'package:lavanderia/features/catalogos/precios/presentation/types/column_precios_name.dart';
export 'package:lavanderia/core/types/estatus_type.dart';


part 'filtros_precios.freezed.dart';

@freezed
sealed class FiltrosPrecios with _$FiltrosPrecios {
  const FiltrosPrecios._();
  const factory FiltrosPrecios({
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(false) bool ascendente,
    @Default(ColumnPreciosName.fechaCreacion) ColumnPreciosName ordenamiento,
  }) = _FiltrosPrecios;

  bool get haveFilters {
    return nombre.isNotEmpty ||
        estatus != EstatusType.activo ||
        ordenamiento != ColumnNamesType.fechaCreacion;
  }
}
