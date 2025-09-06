import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/view/view_model/orden_servicio_view_model.dart';

import 'item_servicio_selected.dart';

class ItemsListSelected extends ConsumerWidget {
  const ItemsListSelected({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
    final items = ref.watch(
      ordenServicioViewProvider.select(
        (value) => value.selectedItems,
      ),
    );
    if (items.isEmpty) {
      return const Center(
        child: Text('Agregue conceptos para la orden de servicio'),
      );
    }
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemServicioSelected(
          item: item,
          index: index,
        );
      },
    );
  }
}
