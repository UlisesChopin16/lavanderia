import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
// import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/usecases/obtain_all_clientes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orden_servicio_view_model.freezed.dart';
part 'orden_servicio_view_model.g.dart';

@freezed
sealed class OrdenServicioModel with _$OrdenServicioModel {
  const OrdenServicioModel._();

  const factory OrdenServicioModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default([]) List<ClienteEntity> clientes,
    @Default('') String filtro,
    @Default(OrdenConDetallesEntity()) OrdenConDetallesEntity orden,
  }) = _OrdenServicioModel;

  List<ItemConPrecioEntity> get selectedItems => orden.items;
  ClienteEntity get clienteSeleccionado => orden.cliente;

  double get total {
    if (selectedItems.isEmpty) return 0.0;
    if (orden.total != 0.0) return orden.total;
    return selectedItems.fold(0.0, (sum, item) => sum + item.importe);
  }

  // double get total => orden.total;
  double get restante => total - orden.history.monto;
}

@riverpod
class OrdenServicioView extends _$OrdenServicioView {
  final _obtainClientsCase = instance<ObtainAllClientes>();
  final _createOrdenCase = instance<CreateOrden>();

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
        );
        // for (var i = 0; i < filteredItems.length; i++) {
        //   gridKey.currentState?.insertItem(i);
        //   await Future.delayed(const Duration(milliseconds: 50));
        // }
      },
    );
  }

  List<ClienteEntity> setFilter(String filtro) {
    final filtroLower = filtro.toLowerCase();
    final clientesFiltrados = state.clientes.where((cliente) {
      final fullName = cliente.fullName.toLowerCase();
      final telefono = cliente.telefono.toLowerCase();
      final correo = cliente.correo.toLowerCase();
      return fullName.contains(filtroLower) ||
          telefono.contains(filtroLower) ||
          correo.contains(filtroLower);
    }).toList();

    // state = state.copyWith(
    //   filtro: filtro,
    //   clientesFiltrados: clientesFiltrados,
    // );
    return clientesFiltrados;
  }

  void setClienteSeleccionado(ClienteEntity cliente) {
    state = state.copyWith.orden(
      cliente: cliente,
    );
  }

  ClienteEntity? getCliente(String data) {
    final normalized = data.normalizeSpaces();
    if (normalized.isEmail) {
      return ClienteEntity(correo: normalized);
    }
    if (normalized.isOnlyNumbers) {
      final telefono = normalized.length > 10 ? normalized.substring(0, 10) : normalized;
      return ClienteEntity(telefono: telefono);
    }
    if (normalized.isNotEmpty && !normalized.isOnlyNumbers && !normalized.isEmail) {
      return ClienteEntity(nombres: normalized);
    }

    return null;
  }

  void setSelectedItems(List<ItemConPrecioEntity> items) {
    final selectedItems = state.selectedItems;
    final allItems = [...items, ...selectedItems];

    // ordenar por fecha de entrega
    allItems.sort((a, b) {
      final dateA = a.fechaEntrega ?? DateTime.now();
      final dateB = b.fechaEntrega ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    state = state.copyWith.orden(
      items: allItems,
    );
  }

  void removeSelectedItem(int index) {
    List<ItemConPrecioEntity> selectedItems = [...state.selectedItems];
    selectedItems.removeAt(index);
    
    state = state.copyWith.orden(
      items: selectedItems,
    );
  }

  void setCantidad(int index, double cantidad) {
    List<ItemConPrecioEntity> selectedItems = [...state.selectedItems];
    final item = selectedItems[index];
    final importe = item.precio.importe * cantidad;
    final updatedItem = item.copyWith(
      cantidad: cantidad,
      importe: importe,
    );

    selectedItems[index] = updatedItem;

    state = state.copyWith.orden(
      items: selectedItems,
    );
  }

  void setFechaEntrega(int index, DateTime date) {
    List<ItemConPrecioEntity> selectedItems = [...state.selectedItems];
    final item = selectedItems[index];
    final updatedItem = item.copyWith(fechaEntrega: date);
    selectedItems[index] = updatedItem;

    state = state.copyWith.orden(
      items: selectedItems,
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

  void setDescripcion(String descripcion) {
    state = state.copyWith.orden(
      descripcion: descripcion.trim(),
    );
  }

  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void createOrden({required void Function(OrdenConDetallesEntity orden) onShow}) async {
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
        state.orden.validate();
        final total = state.total;
        final restante = state.restante < 0.0 ? 0.0 : state.restante;
        final estatus = restante == 0.0 ? EstatusOrdenType.pagado : EstatusOrdenType.enCurso;
        final history = state.orden.history;
        final adelanto = history.monto;
        final newOrder = state.orden.copyWith(
          total: total,
          restante: restante,
          estatus: estatus,
          history: history.copyWith(
            metodoPago: state.orden.hasAdelanto ? history.metodoPago : null,
            monto: adelanto > total ? total : adelanto,
          )
        );

        final orden = await _createOrdenCase.call(newOrder);

        onShow(orden);

        state = state.copyWith(
          successMessage: 'Orden de servicio creada exitosamente.',
          // orden: OrdenConDetallesEntity(id: newOrderId),
        );

        state = state.copyWith(
          orden: const OrdenConDetallesEntity(),
        );
      },
    );
  }

  // void setSelectedItems(List<ItemConPrecioEntity> items) {
  //   final selectedItems = state.selectedItems;
  //   final dateItems = <String, DateItemsEntity>{};

  //   if (selectedItems.isNotEmpty) {
  //     for (var dateItem in selectedItems) {
  //       final key = dateItem.date.formatDate;
  //       dateItems[key] = dateItem;
  //     }
  //   }

  //   for (var item in items) {
  //     final dateKey = item.fechaCreacion.formatDate;
  //     if (dateItems.containsKey(dateKey)) {
  //       final datedItem = dateItems[dateKey]!;
  //       dateItems[dateKey] = datedItem.copyWith(
  //         items: [...datedItem.items, item],
  //       );
  //     } else {
  //       dateItems[dateKey] = DateItemsEntity(
  //         date: item.fechaCreacion!,
  //         items: [item],
  //       );
  //     }
  //   }
  //   state = state.copyWith(selectedItems: dateItems.values.toList());
  // }

  // void changeAllDate(int index, DateTime date) {
  //   // Actualizamos todos los items del día seleccionado
  //   List<DateItemsEntity> selectedItems = [...state.selectedItems];
  //   final dateItems = selectedItems[index];
  //   final updatedItems = dateItems.items.map((item) => item.copyWith(fechaEntrega: date)).toList();
  //   final updatedDateItems = dateItems.copyWith(
  //     date: date,
  //     items: updatedItems,
  //   );

  //   // Buscamos si la fecha seleccionada ya existe en otra posición
  //   final existingIndex = selectedItems.indexWhere(
  //     (d) => d.date.formatDate == updatedDateItems.date.formatDate,
  //   );

  //   if (existingIndex != -1) {
  //     // Si existe, actualizamos los items de esa posición
  //     final existingDateItems = selectedItems[existingIndex];

  //     final updatedExistingDateItems = existingDateItems.copyWith(
  //       date: date,
  //       items: [...existingDateItems.items, ...updatedItems],
  //     );
  //     selectedItems[existingIndex] = updatedExistingDateItems;

  //     // Removemos la posición actual para evitar duplicados
  //     selectedItems.removeAt(index);

  //     state = state.copyWith(selectedItems: [...selectedItems]);

  //     return;
  //   }

  //   selectedItems[index] = updatedDateItems;
  //   state = state.copyWith(selectedItems: [...selectedItems]);
  // }

  // void removeItem(int dateIndex, int itemIndex) {
  //   List<DateItemsEntity> selectedItems = [...state.selectedItems];
  //   final dateItems = selectedItems[dateIndex];
  //   List<ItemConPrecioEntity> items = [...dateItems.items];
  //   items.removeAt(itemIndex);

  //   if (items.isEmpty) {
  //     selectedItems.removeAt(dateIndex);
  //   } else {
  //     selectedItems[dateIndex] = dateItems.copyWith(items: items);
  //   }

  //   state = state.copyWith(selectedItems: [...selectedItems]);
  // }

  // void changeItemDate (int dateIndex, int itemIndex, DateTime date) {
  //   List<DateItemsEntity> selectedItems = [...state.selectedItems];
  //   final dateItems = selectedItems[dateIndex];
  //   List<ItemConPrecioEntity> items = [...dateItems.items];
  //   if(items.length == 1){
  //     // Si solo hay un item en la fecha, cambiamos toda la fecha
  //     changeAllDate(dateIndex, date);
  //     return;
  //   }

  //   final item = items[itemIndex];
  //   final updatedItem = item.copyWith(fechaEntrega: date);
  //   items[itemIndex] = updatedItem;

  //   // Verificamos si ya existe una sección con la nueva fecha
  //   final newDateKey = date.formatDate;

  //   final existingIndex = selectedItems.indexWhere(
  //     (d) => d.date.formatDate == newDateKey,
  //   );

  //   if (existingIndex != -1) {
  //     // Si existe, actualizamos los items de esa posición
  //     final existingDateItems = selectedItems[existingIndex];

  //     final updatedExistingDateItems = existingDateItems.copyWith(
  //       items: [...existingDateItems.items, updatedItem],
  //     );
  //     selectedItems[existingIndex] = updatedExistingDateItems;

  //     // Removemos el item de la posición actual
  //     items.removeAt(itemIndex);

  //     selectedItems[dateIndex] = dateItems.copyWith(items: items);

  //     state = state.copyWith(selectedItems: [...selectedItems]);
  //     return;
  //   }

  //   state = state.copyWith(selectedItems: [...selectedItems]);
  // }

  // void setCantidad(int dateIndex, int itemIndex, double cantidad) {
  //   List<DateItemsEntity> selectedItems = [...state.selectedItems];
  //   final dateItems = selectedItems[dateIndex];
  //   List<ItemConPrecioEntity> items = [...dateItems.items];

  //   final item = items[itemIndex];
  //   final importe = item.precio.importe * cantidad;
  //   final updatedItem = item.copyWith(
  //     cantidad: cantidad,
  //     importe: importe,
  //   );

  //   items[itemIndex] = updatedItem;
  //   selectedItems[dateIndex] = dateItems.copyWith(items: items);

  //   state = state.copyWith(selectedItems: [...selectedItems]);
  //   // gridKey.currentState?.insertItem(index);
  // }
}
