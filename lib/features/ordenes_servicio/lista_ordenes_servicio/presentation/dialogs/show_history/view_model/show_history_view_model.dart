import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_history_view_model.freezed.dart';
part 'show_history_view_model.g.dart';

@freezed
sealed class ShowHistoryModel with _$ShowHistoryModel {
  const ShowHistoryModel._();

  const factory ShowHistoryModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default([]) List<HistoryItemEntity> history,
    @Default(OrdenConDetallesEntity()) OrdenConDetallesEntity orden,
  }) = _ShowHistoryModel;

  double get totalAbonado {
    return history.fold(0.0, (previousValue, element) => previousValue + element.monto);
  }

  double get restante {
    return orden.restante;
  }

  double get total {
    return orden.total;
  }

  EstatusOrdenType get estatus {
    return orden.estatus;
  }
}

@riverpod
class ShowHistoryViewModel extends _$ShowHistoryViewModel {
  @override
  ShowHistoryModel build() {
    return const ShowHistoryModel();
  }

  void initiate(OrdenConDetallesEntity orden) {
    state = state.copyWith(orden: orden);
  }

  Future<void> fetchHistory() async {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
      ),
      action: () async {
        final listaOrdenesNotifier = ref.read(listaOrdenesViewModelProvider.notifier);
        final newHistory = await listaOrdenesNotifier.obtainHistory(state.orden.id);
        state = state.copyWith(history: newHistory);
      },
    );
  }
}
