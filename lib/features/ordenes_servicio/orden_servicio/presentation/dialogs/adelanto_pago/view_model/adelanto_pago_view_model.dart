import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/obtain_items.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'adelanto_pago_view_model.freezed.dart';
part 'adelanto_pago_view_model.g.dart';

@freezed
sealed class AdelantoPagoModel with _$AdelantoPagoModel {
  const AdelantoPagoModel._();

  const factory AdelantoPagoModel({
    @Default(false) bool isLoading,
    @Default(false) bool entregarTodo,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default([]) List<ItemConPrecioEntity> items,
    @Default(HistoryItemEntity()) HistoryItemEntity history,
    @Default(0.0) double restante,
  }) = _AdelantoPagoModel;

  double get newRestante => history.monto - restante;
}

@riverpod
class AdelantoPagoViewModel extends _$AdelantoPagoViewModel {
  final _obtainItems = instance<ObtainItems>();

  @override
  AdelantoPagoModel build() {
    return const AdelantoPagoModel();
  }

  void init(OrdenConDetallesEntity orden) async {
    state = state.copyWith(restante: orden.restante);
    await obtainItems(orden.id);
  }

  Future<void> obtainItems(int idOrden) async {
    await safeCall(
      actionBefore: () async => state = state.copyWith(isLoading: true),
      actionAfter: () async => state = state.copyWith(isLoading: false),
      actionOnError: (error, message) async => state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      ),
      action: () async {
        final orderItems = await _obtainItems.call(idOrden);

        state = state.copyWith(items: orderItems);
      },
    );
  }

  void setAdelanto(String adelanto) {
    final newAdelanto = double.tryParse(adelanto) ?? 0.0;
    final history = state.history;
    state = state.copyWith(
      history: history.copyWith(monto: newAdelanto),
    );
  }

  void setMetodo(MetodoPagoType metodoPago) {
    final history = state.history;
    state = state.copyWith(
      history: history.copyWith(
        metodoPago: metodoPago,
      ),
    );
  }

  void setEntregaTodo(bool entregaTodo) {
    state = state.copyWith(entregarTodo: entregaTodo);
  }
}
