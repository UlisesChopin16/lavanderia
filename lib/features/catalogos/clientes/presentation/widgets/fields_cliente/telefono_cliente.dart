import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

class TelefonoCliente extends StatelessWidget {
  final String telefono;
  final ValueChanged<String> onTelefonoChanged;

  const TelefonoCliente({
    super.key,
    required this.onTelefonoChanged,
    required this.telefono,
  });

  static const width = 250.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: telefono,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          prefixIcon: Icon(Icons.phone_rounded),
          label: Text(
            'Teléfono',
            maxLines: 2,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Ej: 123 456 7890',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
          // phoneMask,
        ],
        onChanged: (value) {
          onTelefonoChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
