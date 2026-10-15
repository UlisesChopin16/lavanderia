import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/models/data/ordenes/item_con_precio_entity.dart';
import 'package:lavanderia/ui/views/orden_servicio/dialogs/select_items/select_price_dialog.dart';
import 'package:lavanderia/ui/views/orden_servicio/view_model/orden_servicio_view_model.dart';

class ButtonAddConceptos extends ConsumerWidget {
  const ButtonAddConceptos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    final selectedItems = ref.watch(
      ordenServicioViewProvider.select((value) => value.selectedItems),
    );
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton(
        onPressed: () async {
          final result = await showDialog<List<ItemConPrecioEntity>>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return SelectPriceDialog(itemsSelected: selectedItems);
            },
          );
          if (result != null && result.isNotEmpty) {
            ordenNotifier.setSelectedItems(result);
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.playlist_add_rounded),
              Flexible(child: Text('Agregar conceptos')),
            ],
          ),
        ),
      ),
    );
  }
}
