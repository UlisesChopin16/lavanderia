import 'package:flutter/material.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

class NombresCliente extends StatelessWidget {
  final String nombres;
  final ValueChanged<String> onNombresChanged;

  const NombresCliente({
    super.key,
    required this.onNombresChanged,
    required this.nombres,
  });

  static const width = 200.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: nombres,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          prefixIcon: Icon(Icons.person),
          label: Text(
            'Nombre(s)',
            maxLines: 2,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Ej: Juan, María, etc.',
        ),
        onChanged: (value) {
          onNombresChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
