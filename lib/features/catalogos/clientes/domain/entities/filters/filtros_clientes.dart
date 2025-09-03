import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/types/column_clientes_name.dart';

export 'package:lavanderia/features/catalogos/clientes/presentation/types/column_clientes_name.dart';

part 'filtros_clientes.freezed.dart';

@freezed
sealed class FiltrosClientes with _$FiltrosClientes {
  const FiltrosClientes._();
  const factory FiltrosClientes({
    @Default('') String nombre,
    @Default(false) bool ascendente,

    @Default(ColumnClientesName.fechaCreacion) ColumnClientesName ordenamiento,
  }) = _FiltrosClientes;

  bool get haveFilters {
    return nombre.isNotEmpty ||
        ordenamiento != ColumnClientesName.fechaCreacion;
  }
}
