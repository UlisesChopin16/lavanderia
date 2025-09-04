import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/view_model/select_price_view_model.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class FiltroCategoria extends HookConsumerWidget {
  const FiltroCategoria({
    super.key,
  });

  List<DropdownMenuEntry<CategoriaServicioEntity>> _dropdownItems(
    List<CategoriaServicioEntity> categorias,
  ) {
    return categorias.map((categoria) {
      return DropdownMenuEntry(
        value: categoria,
        label: categoria.nombre,
      );
    }).toList();
  }

  static const width = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);
    final (categorias, categoria) = ref.watch(
      selectPriceViewModelProvider.select(
        (state) => (state.categorias, state.filtros.categoria),
      ),
    );
    final controller = useTextEditingController();
    controller.text = categoria.nombre;

    return SizedBox(
      width: width,
      child: DropdownMenuBase<CategoriaServicioEntity>(
        label: 'Filtrar por categoría',
        width: width,
        controller: controller,
        items: _dropdownItems(categorias),
        leadingIcon: const Icon(IconsManager.selectedCategoriasIcon),
        value: categoria,
        onChanged: (value) {
          selectPriceNotifier.setCategoria(value ?? const CategoriaServicioEntity());
        },
      ),
    );
  }
}
