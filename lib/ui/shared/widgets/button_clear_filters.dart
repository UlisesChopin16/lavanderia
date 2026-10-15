import 'package:flutter/material.dart';

class ButtonClearFilters extends StatelessWidget {
  final VoidCallback? onPressed;
  const ButtonClearFilters({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Icon(Icons.clear_rounded),
          Text('Limpiar Filtros'),
        ],
      ),
    );
  }
}
