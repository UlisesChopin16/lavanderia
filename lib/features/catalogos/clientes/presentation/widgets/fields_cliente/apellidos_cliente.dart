import 'package:flutter/material.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

class ApellidosCliente extends StatelessWidget {
  final String apellidos;
  final ValueChanged<String> onApellidosChanged;

  const ApellidosCliente({
    super.key,
    required this.onApellidosChanged,
    required this.apellidos,
  });

  static const width = 250.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: apellidos,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          prefixIcon: Icon(Icons.person),
          label: Text(
            'Apellido(s)',
            maxLines: 2,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Ej: Pérez, Gómez, etc.',
        ),
        onChanged: (value) {
          onApellidosChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
