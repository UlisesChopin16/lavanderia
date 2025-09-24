import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/select_items/view_model/select_price_view_model.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class FiltroSize extends HookConsumerWidget {

  const FiltroSize({
    super.key,
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
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);

    final (sizesRopa, size) = ref.watch(
      selectPriceViewModelProvider.select(
        (state) => (state.sizesRopa, state.filtros.sizeRopa),
      ),
    );

    final List<SizesRopaEntity> newList = List.from(sizesRopa)
      ..add(ConstantsManager.defaultSizeRopa);

    final controller = useTextEditingController();
    controller.text = size?.nombre ?? '';

    return SizedBox(
      width: width,
      child: DropdownMenuBase<SizesRopaEntity>(
        label: 'Filtrar por tamaño',
        width: width,
        controller: controller,
        items: _dropdownItems(newList),
        leadingIcon: const Icon(IconsManager.selectedSizesIcon),
        value: size,
        onChanged: (value) {
          selectPriceNotifier.setSizeRopa(value ?? const SizesRopaEntity());
        },
      ),
    );
  }
}
