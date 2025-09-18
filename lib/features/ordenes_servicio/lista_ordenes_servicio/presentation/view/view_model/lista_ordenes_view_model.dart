import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lista_ordenes_view_model.freezed.dart';
part 'lista_ordenes_view_model.g.dart';

@freezed
sealed class ListaOrdenesModel with _$ListaOrdenesModel {
  const factory ListaOrdenesModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(FiltrosOrdenes()) FiltrosOrdenes filtros,
  }) = _ListaOrdenesModel;
}


@riverpod
class ListaOrdenesViewModel extends _$ListaOrdenesViewModel {
  final _observeAll = instance<ObserveAllOrders>();

  @override
  ListaOrdenesModel build() {
    return const ListaOrdenesModel();
  }

  void setNombre(String nombre) {
    final filtros = state.filtros.copyWith(busqueda: nombre);
    state = state.copyWith(filtros: filtros);
  }

  void setEstatus(EstatusOrdenType estatus) {
    final filtros = state.filtros.copyWith(estatus: estatus);
    state = state.copyWith(filtros: filtros);
  }

  void clearFilters() {
    state = state.copyWith(filtros: const FiltrosOrdenes());
  }

  void setSort(bool sort) {
    state = state.copyWith(filtros: state.filtros.copyWith(ascendente: sort));
  }

  void setOrden(ColumnsOrdenesNames orden) {
    state = state.copyWith(filtros: state.filtros.copyWith(ordenamiento: orden));
  }

  void setOrdenAndSort(ColumnsOrdenesNames orden, bool sort) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        ordenamiento: orden,
        ascendente: sort,
      ),
    );
  }

  Stream<List<OrdenConDetallesEntity>> observeOrders() {
    return _observeAll.call(state.filtros);
  }

}