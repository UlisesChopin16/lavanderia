import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/usecases/obtain_all_categorias_servicios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/usecases/obtain_all_precios.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/usecases/obtain_all_sizes_ropa.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_price_view_model.freezed.dart';
part 'select_price_view_model.g.dart';

@freezed
sealed class SelectPriceModel with _$SelectPriceModel {
  const factory SelectPriceModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default([]) List<ItemConPrecioEntity> items,
    @Default([]) List<ItemConPrecioEntity> filteredItems,
    @Default([]) List<CategoriaServicioEntity> categorias,
    @Default([]) List<SizesRopaEntity> sizesRopa,
    @Default(FiltrosPrecios()) FiltrosPrecios filtros,
  }) = _SelectPriceModel;
}

@riverpod
class SelectPriceViewModel extends _$SelectPriceViewModel {
  final _obtainAllPrecios = instance<ObtainAllPrecios>();
  final _obtainCategoriasCase = instance<ObtainAllCategoriasServicios>();
  final _obtainSizesCase = instance<ObtainAllSizesRopa>();

  @override
  SelectPriceModel build() {
    return const SelectPriceModel();
  }

  Future<void> init(
    List<ItemConPrecioEntity> itemsSelected,
  ) async {
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
        final precios = await _obtainAllPrecios.call();
        final items = precios.map(ItemConPrecioEntity.fromPrecio).toList();
        final filteredItems = filtrarItems(items: items, itemsSelected: itemsSelected);

        // gridKey.currentState?.insertAllItems(
        //   0,
        //   filteredItems.length,
        // );

        final categorias = await _obtainCategoriasCase.call();
        final sizesRopa = await _obtainSizesCase.call();

        state = state.copyWith(
          items: filteredItems,
          filteredItems: filteredItems,
          categorias: categorias,
          sizesRopa: sizesRopa,
        );
        // for (var i = 0; i < filteredItems.length; i++) {
        //   gridKey.currentState?.insertItem(i);
        //   await Future.delayed(const Duration(milliseconds: 50));
        // }
      },
    );
  }

  List<ItemConPrecioEntity> filtrarItems({
    required List<ItemConPrecioEntity> items,
    required List<ItemConPrecioEntity> itemsSelected,
  }) {
    if (itemsSelected.isEmpty) return items;

    final idsSeleccionados = itemsSelected.map((e) => e.precio.idPrecio).toSet();
    return items.where((item) => !idsSeleccionados.contains(item.precio.idPrecio)).toList();
  }

  void setCantidad(int filteredIndex, double cantidad) {
    final item = state.filteredItems[filteredIndex];
    final index = state.items.indexWhere((i) => i.precio.idPrecio == item.precio.idPrecio);
    if (index == -1) return;
    final importe = item.precio.importe * cantidad;
    final updatedItem = item.copyWith(
      cantidad: cantidad,
      importe: importe,
    );

    final updatedItems = List<ItemConPrecioEntity>.from(state.items)..[index] = updatedItem;
    final updatedFilteredItems = List<ItemConPrecioEntity>.from(state.filteredItems)
      ..[filteredIndex] = updatedItem;

    state = state.copyWith(items: updatedItems, filteredItems: updatedFilteredItems);
    // gridKey.currentState?.insertItem(index);
  }

  void setSelected(int filteredIndex, bool isSelected) {
    final item = state.filteredItems[filteredIndex];
    final index = state.items.indexWhere((i) => i.precio.idPrecio == item.precio.idPrecio);
    if (index == -1) return;

    final updatedItem = item.copyWith(isSelected: isSelected);
    final updatedItems = List<ItemConPrecioEntity>.from(state.items)..[index] = updatedItem;
    final updatedFilteredItems = List<ItemConPrecioEntity>.from(state.filteredItems)
      ..[filteredIndex] = updatedItem;

    state = state.copyWith(items: updatedItems, filteredItems: updatedFilteredItems);
  }

  void clearFilters() {
    state = state.copyWith(filtros: const FiltrosPrecios());
    applyFilters();
  }

  void setCategoria(CategoriaServicioEntity categoria) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        categoria: categoria,
      ),
    );
    applyFilters();
  }

  void setSizeRopa(SizesRopaEntity sizeRopa) {
    state = state.copyWith(filtros: state.filtros.copyWith(sizeRopa: sizeRopa));
    applyFilters();
  }

  void setSearchTerm(String searchTerm) {
    state = state.copyWith(filtros: state.filtros.copyWith(nombre: searchTerm));
    applyFilters();
  }

  void applyFilters() async {
    // Aquí aplicas los filtros al listado de items
    List<ItemConPrecioEntity> filteredItems = List.from(state.items);

    final filtros = state.filtros;

    if (filtros.categoria.id != -1) {
      filteredItems = filteredItems
          .where((item) => item.precio.categoria.id == filtros.categoria.id)
          .toList();
    }

    if (filtros.sizeRopa?.nombre.isNotEmpty == true) {
      filteredItems = filteredItems
          .where((item) => item.precio.size.id == filtros.sizeRopa?.id)
          .toList();
    }

    if (filtros.nombre.isNotEmpty) {
      filteredItems = filteredItems
          .where(
            (item) =>
                item.precio.nombreConcepto.toLowerCase().contains(filtros.nombre.toLowerCase()),
          )
          .toList();
    }
    state = state.copyWith(filteredItems: filteredItems);
  }

  List<ItemConPrecioEntity> getSelectedItems() {
    return state.items.where((item) => item.isSelected).toList();
  }
}
