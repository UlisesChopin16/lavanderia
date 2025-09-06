import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/view/view_model/orden_servicio_view_model.dart';
import 'package:lavanderia/shared/widgets/date_picker_component.dart';

import 'change_cantidad.dart';

class ItemServicioSelected extends ConsumerWidget {
  final ItemConPrecioEntity item;
  final int index;
  const ItemServicioSelected({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 480;
    final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    final blackColor = Theme.of(context).colorScheme.surfaceContainerLow;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final newColor = isDark ? color : blackColor;
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return Card(
      elevation: 1,
      color: newColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(IconsManager.clotheIcon),
            ),
            title: Text(item.precio.nombreConcepto),
            subtitle: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    const Icon(IconsManager.selectedSizesIcon),
                    Flexible(child: Text(item.precio.size.nombre)),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    const Icon(IconsManager.selectedCategoriasIcon),
                    Flexible(child: Text(item.precio.categoria.nombre)),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ordenNotifier.removeSelectedItem(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              textDirection: isSmall ? TextDirection.rtl : TextDirection.ltr,
              children: [
                DatePickerComponent(
                  labelText: 'Entrega',
                  currentDate: item.fechaEntrega,
                  firstDate: DateTime.now().add(Duration(days: item.precio.diasEntrega)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  changeDate: (value) => ordenNotifier.setFechaEntrega(index, value!),
                ),
                Column(
                  spacing: 5,
                  children: [
                    Text(
                      '\$${item.importe.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChangeCantidad(
                      cantidad: item.cantidad,
                      onChanged: (newCantidad) {
                        ordenNotifier.setCantidad(index, newCantidad);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(5),
        ],
      ),
    );
  }
}
