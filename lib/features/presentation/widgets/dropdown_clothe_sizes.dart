import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/types/clothe_size_type.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class DropdownClotheSizes extends HookConsumerWidget {
  final ClotheSizeType? clotheSize;
  final ValueChanged<ClotheSizeType?> onSizeChanged;
  final double? width;
  final bool? showDelete;

  const DropdownClotheSizes({
    super.key,
    required this.clotheSize,
    required this.onSizeChanged,
    this.width,
    this.showDelete,
  });

  static const clotheSizes = ClotheSizeType.values;

  List<DropdownMenuEntry<ClotheSizeType>> _dropdownItems() {
    return clotheSizes.map((size) {
      return DropdownMenuEntry(
        value: size,
        label: size.description,
      );
    }).toList();
  }

  bool get showDeleteButton => showDelete ?? (clotheSize != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    controller.text = clotheSize?.description ?? '';


    return SizedBox(
      width: width,
      child: DropdownMenuBase<ClotheSizeType>(
        label: 'Tamaño de ropa',
        width: width,
        controller: controller,
        items: _dropdownItems(),
        leadingIcon: const Icon(IconsManager.selectedSizesIcon),
        value: clotheSize,
        onChanged: onSizeChanged,
        showDelete: showDeleteButton,
        onDelete: () => onSizeChanged(null),
      ),
    );
  }
}
