import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/clothe_size_type.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/types/column_precios_name.dart';

export 'package:lavanderia/core/types/estatus_type.dart';
export 'package:lavanderia/features/catalogos/precios/presentation/types/column_precios_name.dart';

part 'filtros_precios.freezed.dart';

@freezed
sealed class FiltrosPrecios with _$FiltrosPrecios {
  const FiltrosPrecios._();
  const factory FiltrosPrecios({
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(false) bool ascendente,
    @Default(CategoriaServicioEntity()) CategoriaServicioEntity categoria,
    @Default(null) ClotheSizeType? clotheSize,
    @Default(ColumnPreciosName.fechaCreacion) ColumnPreciosName ordenamiento,
  }) = _FiltrosPrecios;

  bool get haveFilters {
    return nombre.isNotEmpty ||
        estatus != EstatusType.activo ||
        ordenamiento != ColumnPreciosName.fechaCreacion ||
        clotheSize != null ||
        categoria.id != -1;
  }
}
