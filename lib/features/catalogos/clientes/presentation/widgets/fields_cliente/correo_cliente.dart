import 'package:flutter/material.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

class CorreoCliente extends StatelessWidget {
  final String correo;
  final ValueChanged<String> onCorreoChanged;

  const CorreoCliente({
    super.key,
    required this.onCorreoChanged,
    required this.correo,
  });

  static const width = 200.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: correo,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          prefixIcon: Icon(Icons.email_rounded),
          label: Text(
            'Correo',
            maxLines: 2,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Ej: juan@example.com',
        ),
        onChanged: (value) {
          onCorreoChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
