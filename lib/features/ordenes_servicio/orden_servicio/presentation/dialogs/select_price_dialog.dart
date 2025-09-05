import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/view_model/select_price_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/widgets/item_servicio_selected.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/button_clear_filters.dart';

import '../widgets/filtros/filtros.dart';

class SelectPriceDialog extends ConsumerStatefulWidget {
  final List<ItemConPrecioEntity> itemsSelected;
  const SelectPriceDialog({super.key, required this.itemsSelected});

  @override
  ConsumerState<SelectPriceDialog> createState() => _SelectPriceDialogState();
}

class _SelectPriceDialogState extends ConsumerState<SelectPriceDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectNotifier = ref.read(selectPriceViewModelProvider.notifier);
      selectNotifier.init(
        widget.itemsSelected,
        // _gridKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);
    final (items, filtros) = ref.watch(
      selectPriceViewModelProvider.select(
        (state) => (state.filteredItems, state.filtros),
      ),
    );

    return BaseDialog(
      title: 'Seleccione los precios',
      onActionPressed: () {
        Navigator.of(context).pop(selectPriceNotifier.getSelectedItems());
      },
      content: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 1400,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SearchAndAdd(
                  controller: controller,
                  onSearchChanged: selectPriceNotifier.setSearchTerm,
                  haveFilters: filtros.haveFilters,
                  onClearFilters: () {
                    selectPriceNotifier.clearFilters();
                    controller.text = '';
                  },
                ),
                const Divider(),
                Flexible(
                  child: GridView.builder(
                    // key: _gridKey,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: isSmall ? 380 : 250,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemServicioSelected(
                        item: item,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _Filters extends StatelessWidget {
//   const _Filters({
//     required this.onClearFilters,
//     required this.haveFilters,
//     required this.filters,
//   });

//   final void Function()? onClearFilters;
//   final bool haveFilters;
//   final List<Widget> filters;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       alignment: WrapAlignment.end,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       runAlignment: WrapAlignment.end,
//       spacing: 10,
//       runSpacing: 10,
//       children: [

//         ...filters,
//       ],
//     );
//   }
// }

class _SearchAndAdd extends HookConsumerWidget {
  const _SearchAndAdd({
    required this.onSearchChanged,
    required this.controller,
    required this.haveFilters,
    required this.onClearFilters,
  });

  final bool haveFilters;
  final void Function()? onClearFilters;
  final ValueChanged<String> onSearchChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final blockUI = ref.watch(
    //   configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    // );

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.end,
      children: [
        if (haveFilters)
          ButtonClearFilters(
            onPressed: onClearFilters,
          ),
        TextField(
          controller: controller,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 300),
            labelText: 'Buscar',
            suffixIcon: Icon(
              Icons.search,
            ),
          ),
        ),
        const FiltroCategoria(),
        const FiltroSize(),
      ],
    );
  }
}
