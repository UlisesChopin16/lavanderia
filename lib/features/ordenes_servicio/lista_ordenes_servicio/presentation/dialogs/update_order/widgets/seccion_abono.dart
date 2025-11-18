import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/dialogs/update_order/view_model/update_order_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/widgets/estatus_container.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/widgets/select_metodo_pago.dart';

class SeccionAbono extends ConsumerWidget {
  const SeccionAbono({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateOrderNotifier = ref.read(updateOrderViewModelProvider.notifier);
    final (metodoPago, estatus, orden) = ref.watch(
      updateOrderViewModelProvider.select(
        (value) => (value.history.metodoPago, value.orden.estatus, value.orden),
      ),
    );
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IgnorePointer(
            ignoring: orden.isPaid || orden.isClosed,
            child: Row(
              spacing: 10,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: SelectMetodoPago(
                    metodoPago: metodoPago,
                    onChange: (value) {
                      updateOrderNotifier.setMetodoPago(value);
                    },
                  ),
                ),
                const Expanded(child: AdelantoPago()),
              ],
            ),
          ),
        ),
        if (orden.isPaid || orden.isClosed)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: EstatusContainer(estatus: estatus)),
            ),
          ),
      ],
    );
  }
}

class AdelantoPago extends HookConsumerWidget {
  const AdelantoPago({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (restante, metodoPago) = ref.watch(
      updateOrderViewModelProvider.select(
        (state) => (state.orden.restante, state.orden.history.metodoPago),
      ),
    );
    final controller = useTextEditingController(text: '0.00');
    final updateOrdenNotifier = ref.read(updateOrderViewModelProvider.notifier);

    _addListener(ref, controller);
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: .end,
        mainAxisSize: .min,
        spacing: 5,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              // FilteringTextInputFormatter.deny(RegExp(r'^[^\d.]+$')),
            ],
            decoration: InputDecoration(
              labelText: 'Adelanto',
              prefixIcon: const Icon(Icons.attach_money),
              constraints: const BoxConstraints(maxWidth: 200),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              updateOrdenNotifier.setAdelanto(value);
            },
          ),
          TextButton(
            onPressed: () => updateOrdenNotifier.setAdelanto('$restante'),
            child: const Text('Adelantar todo'),
          ),
        ],
      ),
    );
  }

  void _addListener(WidgetRef ref, TextEditingController controller) {
    ref.listen(
      updateOrderViewModelProvider.select((state) => state.orden.history.monto),
      (previous, next) {
        final text = next.toStringAsFixed(2);

        if (controller.text != text) {
          controller.text = text;
          // controller.selection = TextSelection.fromPosition(
          //   TextPosition(offset: controller.text.length - 3),
          // );
        }
      },
    );
  }
}
