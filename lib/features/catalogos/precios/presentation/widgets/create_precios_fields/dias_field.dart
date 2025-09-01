import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

class DiasField extends StatelessWidget {
  final String dias;
  final ValueChanged<String> onDiasChanged;

  const DiasField({
    super.key,
    required this.onDiasChanged,
    required this.dias,
  });

  static const width = 180.0;

  @override
  Widget build(BuildContext context) {
    final value = dias == '0' ? '' : dias;
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: value,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          prefixIcon: Icon(Icons.calendar_today_rounded),
          label: Text(
            'Días de entrega',
            maxLines: 2,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Ej: 1, 2, 3, etc.',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
          LengthLimitingTextInputFormatter(12),
        ],
        onChanged: (value) {
          onDiasChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
