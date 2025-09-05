import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeCantidad extends StatelessWidget {
  final double cantidad;
  final ValueChanged<double>? onChanged;

  const ChangeCantidad({super.key, required this.cantidad, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (cantidad > 1)
          InkWell(
            onTap: () {
              // Decrease quantity
              if (onChanged != null) onChanged!(cantidad - 1);
            },
            child: Card(
              margin: EdgeInsets.zero,
              // shape: const CircleBorder(),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.remove),
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
          controller: TextEditingController(text: cantidad.toStringAsFixed(2)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.\d+?$')),
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
