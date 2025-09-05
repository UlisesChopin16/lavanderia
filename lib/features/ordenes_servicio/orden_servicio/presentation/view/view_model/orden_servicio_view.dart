import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/usecases/obtain_all_clientes.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orden_servicio_view.freezed.dart';
part 'orden_servicio_view.g.dart';

@freezed
sealed class OrdenServicioModel with _$OrdenServicioModel {
  const factory OrdenServicioModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default([]) List<ClienteEntity> clientes,
    @Default([]) List<ClienteEntity> clientesFiltrados,
    @Default([]) List<ItemConPrecioEntity> selectedItems,
    @Default('') String filtro,
  }) = _OrdenServicioModel;
}


@riverpod
class OrdenServicioView extends _$OrdenServicioView {
  final _obtainClientsCase = instance<ObtainAllClientes>();

  @override
  OrdenServicioModel build() {
    return const OrdenServicioModel();
  }

  Future<void> getClientes() async {
    await safeCall(
      actionBefore: () async => state = state.copyWith(
        errorMessage: '',
        successMessage: '',
        isLoading: true,
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final clientes = await _obtainClientsCase.call();

        state = state.copyWith(
          clientes: clientes,
          clientesFiltrados: clientes,
        );
        // for (var i = 0; i < filteredItems.length; i++) {
        //   gridKey.currentState?.insertItem(i);
        //   await Future.delayed(const Duration(milliseconds: 50));
        // }
      },
    );
  }

}