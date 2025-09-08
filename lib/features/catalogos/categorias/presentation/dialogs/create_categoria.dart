import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/views/view_model/categoria_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class CreateCategoria extends ConsumerStatefulWidget {
  const CreateCategoria({
    super.key,
  });

  @override
  ConsumerState<CreateCategoria> createState() => _CreateCategoriaState();
}

class _CreateCategoriaState extends ConsumerState<CreateCategoria> {
  CategoriaServicioEntity categoria = const CategoriaServicioEntity();
  final controller = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Nueva categoría de ropa',
      onActionPressed: validateFields,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              onEditingComplete: validateFields,
              onChanged: onChangeNombre,
              decoration: const InputDecoration(
                labelText: 'Nombre de la categoría',
                hintText: 'Ej: Lavandería, Planchado, Tintorería',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: controller,
              onEditingComplete: validateFields,
              onChanged: onChangeDiasEntrega,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              decoration: const InputDecoration(
                labelText: 'Días de entrega',
                constraints: BoxConstraints(maxWidth: 180),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChangeNombre(String nombre) {
    setState(() {
      categoria = categoria.copyWith(nombre: nombre.normalizeSpaces());
    });
  }

  void onChangeDiasEntrega(String dias) {
    setState(() {
      final days = dias.isEmpty ? '1' : dias;
      categoria = categoria.copyWith(diasEntrega: int.parse(days));
      if (dias.isEmpty) controller.text = days;
    });
  }

  void validateFields() async {
    const message = '¿Estás seguro de crear esta categoría?';

    final categoriaNotifier = ref.read(categoriaViewModelProvider.notifier);

    categoriaNotifier.createCategoria(
      categoria: categoria,
      onConfirm: () async {
        return await context.showWarningDialog(
          message: message,
        );
      },
      onSuccess: () {
        context.pop();
      },
    );
  }
}
