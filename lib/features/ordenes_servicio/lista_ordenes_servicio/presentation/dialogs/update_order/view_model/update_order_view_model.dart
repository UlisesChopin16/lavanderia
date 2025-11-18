import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/error/validate_exception.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/update_items.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/update_orden.dart';
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
  HistoryItemEntity get history => orden.history;

  double get restante => orden.restante - orden.history.monto;

  bool get allItemsDelivered {
    for (final item in items) {
      if (!item.estaEntregado) {
        return false;
      }
    }
    return true;
  }

  EstatusOrdenType get newEstatus {
    if (allItemsDelivered && restante <= 0.0) {
      return EstatusOrdenType.cerrada;
    } else if (restante <= 0.0) {
      return EstatusOrdenType.pagado;
    } else {
      return EstatusOrdenType.enCurso;
    }
  }

  bool get montoHasChanged => orden.restante != restante;
  bool get itemsChanged {
    for (final item in items) {
      final originalItem = orden.items.firstWhere((i) => i.id == item.id);
      if (item.estaEntregado != originalItem.estaEntregado) {
        return true;
      }
    }
    return false;
  }

  bool get hasChanges {
    if (montoHasChanged) return true;
    if (itemsChanged) return true;
    return false;
  }
}

@riverpod
class UpdateOrderViewModel extends _$UpdateOrderViewModel {
  final updateOrderCase = instance<UpdateOrden>();
  final updateItemsCase = instance<UpdateItems>();


  @override
  UpdateOrderModel build() {
    return const UpdateOrderModel();
  }

  void initiate(OrdenConDetallesEntity orden) {
    final newOrder = orden.copyWith.history(
      monto: 0.0,
      metodoPago: null,
    );
    state = state.copyWith(orden: newOrder);
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

    if (item.wasDelivered) return;
    if (!item.canDeliver) return;

    final newItem = item.copyWith(estaEntregado: entregado);
    items[index] = newItem;

    state = state.copyWith.orden(items: items);
  }

  void setAllEntregado() {
    List<ItemConPrecioEntity> items = state.items.map((item) {
      if (item.wasDelivered) return item;
      if (!item.canDeliver) return item;
      return item.copyWith(estaEntregado: true);
    }).toList();

    state = state.copyWith.orden(items: items);
  }

  Future<void> updateOrder() async {
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
        validateInfo();
        final restante = state.restante < 0.0 ? 0.0 : state.restante;
        final restanteOrden = state.orden.restante;

        final estatus = state.newEstatus;
        final history = state.orden.history;
        final adelanto = history.monto;
        final newOrder = state.orden.copyWith(
          restante: restante,
          estatus: estatus,
          history: history.copyWith(
            metodoPago: state.orden.hasAdelanto ? history.metodoPago : null,
            monto: adelanto > restanteOrden ? restanteOrden : adelanto,
          ),
        );

        if(state.montoHasChanged || state.orden.estatus != estatus) {
          await updateOrderCase.call(newOrder);
        }
        if(state.itemsChanged) {
          await updateItemsCase.call(newOrder);
        }
      },
    );
  }

  void validateInfo() {
    final history = state.orden.history;
    if (state.restante > 0.0 && state.allItemsDelivered) {
      throw const ValidateException(message: 'No se puede entregar una orden con saldo pendiente.');
    }
    if (history.monto > 0.0 && history.metodoPago == null) {
      throw const ValidateException(message: 'Seleccione un método de pago para el adelanto.');
    }
    if (history.monto < 0.0) {
      throw const ValidateException(message: 'El adelanto no puede ser negativo.');
    }
  }
}
