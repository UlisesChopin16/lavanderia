import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';

class ImporteField extends StatelessWidget {
  final String importe;
  final ValueChanged<String> onPrecioChanged;

  const ImporteField({
    super.key,
    required this.onPrecioChanged,
    required this.importe,
  });

  @override
  Widget build(BuildContext context) {
    final value = importe == '0.0' ? '' : importe;
    return SizedBox(
      width: 150,
      child: TextFormField(
        initialValue: value,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: 150),
          prefixIcon: Icon(IconsManager.selectedPreciosIcon),
          labelText: 'Precio',
          hintText: 'Ej: 55.50, 100, 300, etc.',
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        onChanged: (value) {
          onPrecioChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
