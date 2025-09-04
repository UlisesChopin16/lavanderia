import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/view_model/select_price_view_model.dart';

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
    final selectPriceNotifier = ref.read(selectPriceViewModelProvider.notifier);
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const Gap(10),
            Text(item.precio.categoria.nombre),
            Text(item.precio.size.nombre),
            Text('Precio: \$${item.importe.toStringAsFixed(2)}'),
            const Gap(10),
            if (item.isSelected)
              ChangeCantidad(
                cantidad: item.cantidad,
                onChanged: (newCantidad) {
                  selectPriceNotifier.setCantidad(index, newCantidad);
                },
              ),
          ],
        ),
      ),
    );
  }
}
