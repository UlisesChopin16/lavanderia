import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/types/clothe_size_type.dart';
import 'package:lavanderia/utils/icons_manager.dart';
import 'package:lavanderia/ui/views/orden_servicio/dialogs/select_items/view_model/select_price_view_model.dart';
import 'package:lavanderia/ui/shared/widgets/dropdown_menu_base.dart';

class FiltroSize extends HookConsumerWidget {

  const FiltroSize({
    super.key,
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

  static const width = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);

    final (clotheSize) = ref.watch(
      selectPriceViewModelProvider.select(
        (state) => (state.filtros.clotheSize),
      ),
    );


    final controller = useTextEditingController();
    controller.text = clotheSize?.description ?? '';

    return SizedBox(
      width: width,
      child: DropdownMenuBase<ClotheSizeType>(
        label: 'Filtrar por tamaño',
        width: width,
        controller: controller,
        items: _dropdownItems(),
        leadingIcon: const Icon(IconsManager.selectedSizesIcon),
        value: clotheSize,
        onChanged: (value) {
          selectPriceNotifier.setSizeRopa(value ?? ClotheSizeType.emptySize);
        },
      ),
    );
  }
}
