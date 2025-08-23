import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

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
    final labelLarge = Theme.of(context).textTheme.labelLarge;

    return AlertDialog(
      title: Text(widget.title),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
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
            onChanged: onChangeNombre,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: labelLarge?.copyWith(color: Colors.redAccent),
          ),
        ),
        FilledButton(
          onPressed: () {
            // Add any additional action if needed
            validateNombre();
          },
          child: const Text(
            'Aceptar',
          ),
        ),
      ],
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
