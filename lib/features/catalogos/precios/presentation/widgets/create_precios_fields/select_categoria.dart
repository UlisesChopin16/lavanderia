import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class SelectCategoria extends HookConsumerWidget {
  final CategoriaServicioEntity categoriaValue;
  final ValueChanged<CategoriaServicioEntity> onCategoriaChanged;

  const SelectCategoria({
    super.key,
    required this.categoriaValue,
    required this.onCategoriaChanged,
  });

  List<DropdownMenuEntry<CategoriaServicioEntity>> _dropdownItems(List<CategoriaServicioEntity> categorias) {
    return categorias.map((categoria) {
      return DropdownMenuEntry(
        value: categoria,
        label: categoria.nombre,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(preciosViewModelProvider.select((state) => state.categorias));
    final controller = useTextEditingController();
    controller.text = categoriaValue.nombre;

    return DropdownMenuBase<CategoriaServicioEntity>(
      label: 'Categoría',
      width: 250,
      controller: controller,
      items: _dropdownItems(categorias),
      leadingIcon: const Icon(IconsManager.selectedCategoriasIcon),
      value: categoriaValue,
      onChanged: (value) {
        onCategoriaChanged(value ?? const CategoriaServicioEntity());
      },
    );
  }
}
