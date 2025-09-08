import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/types/columns_categoria_type.dart';
export 'package:lavanderia/features/catalogos/categorias/presentation/types/columns_categoria_type.dart';
export 'package:lavanderia/core/types/estatus_type.dart';

part 'filtros_categoria.freezed.dart';

@freezed
sealed class FiltrosCategoria with _$FiltrosCategoria {
  const FiltrosCategoria._();
  const factory FiltrosCategoria({
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(false) bool ascendente,
    @Default(ColumnsCategoriaType.fechaCreacion) ColumnsCategoriaType ordenamiento,
  }) = _FiltrosCategoria;

  bool get haveFilters {
    return nombre.isNotEmpty ||
        estatus != EstatusType.activo ||
        ordenamiento != ColumnsCategoriaType.fechaCreacion;
  }
}
