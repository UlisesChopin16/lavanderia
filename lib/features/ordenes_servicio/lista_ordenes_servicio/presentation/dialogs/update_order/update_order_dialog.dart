import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/dialogs/update_order/view_model/update_order_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/animating_loading.dart';

import 'widgets/widgets.dart';

class UpdateOrderDialog extends ConsumerStatefulWidget {
  final OrdenConDetallesEntity orden;
  const UpdateOrderDialog({super.key, required this.orden});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateOrderDialogState();
}

class _UpdateOrderDialogState extends ConsumerState<UpdateOrderDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final updateOrderNotifier = ref.read(updateOrderViewModelProvider.notifier);
      updateOrderNotifier.initiate(widget.orden);
      updateOrderNotifier.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final (folio, hasChanges, isLoading) = ref.watch(
      updateOrderViewModelProvider.select(
        (value) => (value.orden.folio, value.hasChanges, value.isLoading),
      ),
    );

    return BaseDialog(
      title: "Orden $folio",
      content: SizedBox(
        width: 500,
        child: AnimatingLoading(
          isLoading: isLoading,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(),
              Flexible(child: Body()),
            ],
          ),
        ),
      ),
    );
  }
}
