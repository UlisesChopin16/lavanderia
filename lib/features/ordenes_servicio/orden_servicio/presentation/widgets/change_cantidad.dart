import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangeCantidad extends HookWidget {
  final double cantidad;
  final ValueChanged<double>? onChanged;
  final Color? color;

  const ChangeCantidad({super.key, required this.cantidad, this.onChanged, this.color});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final backgroundColor = color ?? Theme.of(context).colorScheme.surfaceContainer;
    controller.text = cantidad.toStringAsFixed(2);
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: cantidad > 1,
          child: InkWell(
            onTap: () {
              // Decrease quantity
              if (onChanged != null) onChanged!(cantidad - 1);
            },
            child: Card(
              margin: EdgeInsets.zero,
              // shape: const CircleBorder(),
              color: backgroundColor,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.remove),
              ),
            ),
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 60, maxHeight: 30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          ),
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // FilteringTextInputFormatter.deny(RegExp(r'^[^\d.]+$')),
          ],
          onChanged: (value) {
            final newCantidad = double.tryParse(value) ?? 1.0;
            if (onChanged != null && newCantidad > 0) {
              onChanged!(newCantidad);
            }
          },
        ),
        InkWell(
          onTap: () {
            // Increase quantity
            if (onChanged != null) onChanged!(cantidad + 1);
          },
          child: Card(
            margin: EdgeInsets.zero,
            // shape: const CircleBorder(),
            color: backgroundColor,
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
