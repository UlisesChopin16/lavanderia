import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class FiltroSize extends HookConsumerWidget {
  final SizesRopaEntity sizeRopaValue;

  const FiltroSize({
    super.key,
    required this.sizeRopaValue,
  });

  List<DropdownMenuEntry<SizesRopaEntity>> _dropdownItems(
    List<SizesRopaEntity> sizesRopa,
  ) {
    return sizesRopa.map((size) {
      return DropdownMenuEntry(
        value: size,
        label: size.nombre,
      );
    }).toList();
  }

  static const width = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);

    final sizesRopa = ref.watch(
      preciosViewModelProvider.select(
        (state) => state.sizesRopa,
      ),
    );

    final controller = useTextEditingController();
    controller.text = sizeRopaValue.nombre;

    return SizedBox(
      width: width,
      child: DropdownMenuBase<SizesRopaEntity>(
        label: 'Filtrar por tamaño',
        width: width,
        controller: controller,
        items: _dropdownItems(sizesRopa),
        leadingIcon: const Icon(IconsManager.selectedCategoriasIcon),
        value: sizeRopaValue,
        onChanged: (value) {
          preciosNotifier.setSizeRopa(value ?? const SizesRopaEntity());
        },
      ),
    );
  }
}
