import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class NombreDialog extends StatefulWidget {
  const NombreDialog({
    super.key,
    required this.label,
    required this.nombre,
    required this.hintText,
    required this.title,
  });

  final String label;
  final String nombre;
  final String hintText;
  final String title;

  @override
  State<NombreDialog> createState() => _NombreDialogState();
}

class _NombreDialogState extends State<NombreDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  late String _nombre = '';

  @override
  void initState() {
    super.initState();
    _nombre = widget.nombre;
    _nombreController.text = _nombre;
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: widget.title,
      onActionPressed: validateNombre,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
            onEditingComplete: validateNombre,
            onChanged: onChangeNombre,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hintText,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.normalizeSpaces().isEmpty) {
                return 'Por favor ingresa un nombre';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  void onChangeNombre(String nombre) {
    setState(() {
      _nombre = nombre.normalizeSpaces();
    });
  }

  void validateNombre() {
    if (_formKey.currentState?.validate() ?? false) {
      context.pop(_nombre);
    }
  }
}
