import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_order_view_model.freezed.dart';
part 'update_order_view_model.g.dart';

@freezed
sealed class UpdateOrderModel with _$UpdateOrderModel {
  const UpdateOrderModel._();
  const factory UpdateOrderModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(OrdenConDetallesEntity()) OrdenConDetallesEntity orden,
  }) = _UpdateOrderModel;

  List<ItemConPrecioEntity> get items => orden.items;
}

@riverpod
class UpdateOrderViewModel extends _$UpdateOrderViewModel {
  @override
  UpdateOrderModel build() {
    return const UpdateOrderModel();
  }

  void initiate(OrdenConDetallesEntity orden) {
    state = state.copyWith(orden: orden);
  }

  Future<void> getItems() async {
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
        final itemsOrder = await listaOrdenesNotifier.obtainItems(state.orden.id);

        itemsOrder.sort((a, b) {
          // 1. primero ordenar por entregado/no entregado
          if (a.estaEntregado != b.estaEntregado) {
            return a.estaEntregado ? 1 : -1; // entregados van al final
          }

          // 2. dentro de cada grupo ordenar por fecha
          final dateA = a.fechaEntrega ?? DateTime.now();
          final dateB = b.fechaEntrega ?? DateTime.now();
          return dateA.compareTo(dateB);
        });

        state = state.copyWith.orden(items: itemsOrder);
      },
    );
  }

  void setAdelanto(String value) {
    final adelanto = double.tryParse(value) ?? 0.0;

    state = state.copyWith.orden.history(
      monto: adelanto,
    );
  }

  void setMetodoPago(MetodoPagoType? metodo) {
    state = state.copyWith.orden.history(
      metodoPago: metodo,
    );
  }

  void setEntregado(int index, bool entregado) {
    List<ItemConPrecioEntity> items = [...state.items];
    final item = items[index];
    final newItem = item.copyWith(estaEntregado: entregado);
    items[index] = newItem;

    state = state.copyWith.orden(items: items);
  }

  void setAllEntregado() {
    List<ItemConPrecioEntity> items = state.items
        .map(
          (item) => item.copyWith(estaEntregado: true),
        )
        .toList();

    state = state.copyWith.orden(items: items);
  }
}
