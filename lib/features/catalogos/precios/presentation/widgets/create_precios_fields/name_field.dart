import 'package:flutter/material.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';

class NameField extends StatelessWidget {
  final String name;
  final ValueChanged<String> onNameChanged;

  const NameField({
    super.key,
    required this.onNameChanged,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: name,
      decoration: const InputDecoration(
        constraints: BoxConstraints(maxWidth: 300),
        labelText: 'Nombre del concepto',
        hintText: 'Ej: Playera, Pantalón, Camisa, etc.',
        prefixIcon: Icon(IconsManager.clotheIcon),
      ),
      onChanged: (value) {
        onNameChanged(value.normalizeSpaces());
      },
    );
  }
}
