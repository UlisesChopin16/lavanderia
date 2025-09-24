import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/select_items/view_model/select_price_view_model.dart';

import 'change_cantidad.dart';

class ItemServicioList extends ConsumerWidget {
  const ItemServicioList({
    super.key,
    required this.item,
    required this.index,
  });

  final ItemConPrecioEntity item;
  final int index;

  static const double sizeIcon = 16.0;
  static const double textSize = 12.0;
  static const crossAxis = CrossAxisAlignment.center;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.precio.nombreConcepto)),
                    Checkbox(
                      value: item.isSelected,
                      onChanged: (value) {
                        selectPriceNotifier.setSelected(index, value ?? false);
                      },
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            // ListTile(
            //   leading: const Icon(IconsManager.selectedCategoriasIcon),
            //   title: Text(item.precio.categoria.nombre),
            // ),
            // ListTile(
            //   leading: const Icon(IconsManager.selectedSizesIcon),
            //   title: Text(item.precio.size.nombre),
            // ),
            // ListTile(
            //   leading: const Icon(IconsManager.selectedPreciosIcon),
            //   title: Text(item.importe.toStringAsFixed(2)),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      spacing: 10,
                      crossAxisAlignment: crossAxis,
                      children: [
                        const Icon(IconsManager.selectedSizesIcon, size: sizeIcon),
                        Text(item.precio.size.nombre, style: const TextStyle(fontSize: textSize)),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: crossAxis,
                      children: [
                        const Icon(IconsManager.selectedCategoriasIcon, size: sizeIcon),
                        Text(
                          item.precio.categoria.nombre,
                          style: const TextStyle(fontSize: textSize),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: crossAxis,
                      children: [
                        const Icon(IconsManager.selectedPreciosIcon, size: sizeIcon),
                        Text(
                          item.importe.toStringAsFixed(2),
                          style: const TextStyle(fontSize: textSize),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: crossAxis,
                      children: [
                        const Icon(Icons.event, size: sizeIcon),
                        Text(
                          item.precio.daysText,
                          style: const TextStyle(fontSize: textSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // if (item.isSelected)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: item.isSelected ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !item.isSelected,
                child: ChangeCantidad(
                  cantidad: item.cantidad,
                  color: backgroundColor,
                  unidad: item.unidad,
                  onChanged: (newCantidad) {
                    selectPriceNotifier.setCantidad(index, newCantidad);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
