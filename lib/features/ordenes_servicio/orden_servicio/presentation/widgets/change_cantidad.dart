import 'package:flutter/material.dart';

class ChangeCantidad extends StatelessWidget {
  final int cantidad;
  final ValueChanged<int>? onChanged;
  const ChangeCantidad({super.key, required this.cantidad, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cantidad > 1)
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              // Decrease quantity
            },
          ),
        Text('$cantidad'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Increase quantity
          },
        ),
      ],
    );
  }
}
