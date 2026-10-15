import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/inject/injector.dart';
import 'package:lavanderia/types/range_dates_types.dart';
import 'package:lavanderia/services/printer.dart';
import 'package:lavanderia/extensions/safe_call_ext.dart';
import 'package:lavanderia/models/data/ordenes/filtros_ordenes.dart';
import 'package:lavanderia/models/data/ordenes/orden_con_detalles_entity.dart';
import 'package:lavanderia/repository/ordenes/ordenes_read_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lista_ordenes_view_model.freezed.dart';
part 'lista_ordenes_view_model.g.dart';

const perPage = 15;

@freezed
sealed class ListaOrdenesModel with _$ListaOrdenesModel {
  const ListaOrdenesModel._();

  const factory ListaOrdenesModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(FiltrosOrdenes()) FiltrosOrdenes filtros,
    @Default(0) int totalItems,
    @Default(1) int currentPage,
  }) = _ListaOrdenesModel;

  int get totalPages {
    if (totalItems == 0) return 1;
    return (totalItems / perPage).ceil();
  }

  int get inicioItems {
    if (totalItems == 0) return 0;
    final inicio = (currentPage - 1) * perPage;
    if (inicio >= totalItems) {
      return totalItems;
    }
    return inicio;
  }

  int get finItems {
    if (totalItems == 0) return 0;
    final fin = inicioItems + perPage;
    if (fin > totalItems) {
      return totalItems;
    }
    return fin;
  }
}

@riverpod
class ListaOrdenesViewModel extends _$ListaOrdenesViewModel {
  final _readRepository = instance<OrdenesReadRepository>();
  final rangeMonth = RangeDatesTypes.month.range;

  @override
  ListaOrdenesModel build() {
    return const ListaOrdenesModel(
      // filtros: FiltrosOrdenes(
      //   fechas: rangeMonth,
      // ),
    );
  }

  void setNombre(String nombre) {
    final filtros = state.filtros.copyWith(busqueda: nombre);
    state = state.copyWith(filtros: filtros);
  }

  void setEstatus(EstatusOrdenType estatus) {
    final filtros = state.filtros.copyWith(estatus: estatus);
    state = state.copyWith(filtros: filtros);
  }

  void setFechas(List<DateTime?> fechas) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        fechas: fechas,
      ),
    );
  }

  void clearFechas() {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        fechas: [],
      ),
    );
  }

  void changePage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setTotalItems(int total) {
    Printer.e('Total items: $total');
    state = state.copyWith(totalItems: total);
    Printer.e('Total pages: ${state.inicioItems} - ${state.finItems}');
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

  void clearFiltros() {
    state = state.copyWith(filtros: const FiltrosOrdenes());
  }

  Stream<List<OrdenConDetallesEntity>> observeOrders() {
    final stream = _readRepository.observeAll(state.filtros);
    return stream;
  }

  Future<List<HistoryItemEntity>> obtainHistory(int idOrden) async {
    final history = await _readRepository.getHistoryByOrden(idOrden);
    Printer.e('history length: $history');
    return history;
  }

  Future<List<ItemConPrecioEntity>> obtainItems(int idOrden) async {
    List<ItemConPrecioEntity> items = [];
    await safeCall(
      actionBefore: () async => state = state.copyWith(isLoading: true),
      actionAfter: () async => state = state.copyWith(isLoading: false),
      actionOnError: (error, message) async => state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      ),
      action: () async {
        final orderItems = await _readRepository.getItemsByOrden(idOrden);

        items = orderItems;
      },
    );

    return items;
  }
}
