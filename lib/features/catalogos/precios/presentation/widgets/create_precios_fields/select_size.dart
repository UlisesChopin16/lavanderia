import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class SelectSize extends HookConsumerWidget {
  final SizesRopaEntity sizeRopa;
  final ValueChanged<SizesRopaEntity> onSizeChanged;

  const SelectSize({
    super.key,
    required this.sizeRopa,
    required this.onSizeChanged,
  });

  List<DropdownMenuEntry<SizesRopaEntity>> _dropdownItems(List<SizesRopaEntity> sizes) {
    return sizes.map((size) {
      return DropdownMenuEntry(
        value: size,
        label: size.nombre,
      );
    }).toList();
  }

  static const width = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizes = ref.watch(preciosViewModelProvider.select((state) => state.sizesRopa));
    final controller = useTextEditingController();
    controller.text = sizeRopa.nombre;

    return SizedBox(
      width: width,
      child: DropdownMenuBase<SizesRopaEntity>(
        label: 'Tamaño de ropa',
        width: width,
        controller: controller,
        items: _dropdownItems(sizes),
        leadingIcon: const Icon(IconsManager.selectedSizesIcon),
        value: sizeRopa,
        onChanged: (value) {
          onSizeChanged(value ?? const SizesRopaEntity());
        },
      ),
    );
  }
}
