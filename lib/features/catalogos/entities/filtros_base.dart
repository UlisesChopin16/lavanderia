import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
export 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
export 'package:lavanderia/core/types/estatus_type.dart';

part 'filtros_base.freezed.dart';

@freezed
sealed class FiltrosBase with _$FiltrosBase {
  const FiltrosBase._();
  const factory FiltrosBase({
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(false) bool ascendente,
    @Default(ColumnNamesType.fechaCreacion) ColumnNamesType ordenamiento,
  }) = _FiltrosBase;

  bool get haveFilters {
    return nombre.isNotEmpty ||
        estatus != EstatusType.activo ||
        ordenamiento != ColumnNamesType.fechaCreacion;
  }
}
