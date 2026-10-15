import 'package:material_ui/material_ui.dart';
import 'package:lavanderia/extensions/string_ext.dart';
import 'package:lavanderia/utils/icons_manager.dart';

class NameField extends StatelessWidget {
  final String name;
  final ValueChanged<String> onNameChanged;

  const NameField({
    super.key,
    required this.onNameChanged,
    required this.name,
  });

  static const width = 200.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: name,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: width),
          labelText: 'Nombre del concepto',
          hintText: 'Ej: Playera, Pantalón, Camisa, etc.',
          prefixIcon: Icon(IconsManager.clotheIcon),
        ),
        onChanged: (value) {
          onNameChanged(value.normalizeSpaces());
        },
      ),
    );
  }
}
