import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/views/view_model/categoria_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class UpdateCategoria extends ConsumerStatefulWidget {
  const UpdateCategoria({
    super.key,
    required this.categoria,
  });

  final CategoriaServicioEntity categoria;

  @override
  ConsumerState<UpdateCategoria> createState() => _UpdateCategoriaState();
}

class _UpdateCategoriaState extends ConsumerState<UpdateCategoria> {
  late final categoriaBefore = widget.categoria;
  late CategoriaServicioEntity categoria = widget.categoria;
  late final controller = TextEditingController(text: categoria.diasEntrega.toString());
  late final controllerName = TextEditingController(text: categoria.nombre.normalizeSpaces());

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
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
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
                constraints: BoxConstraints(maxWidth: 200),
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
    const messageConfirmUpdate = '¿Deseas actualizar todos los conceptos de esta categoría?';

    final categoriaNotifier = ref.read(categoriaViewModelProvider.notifier);

    categoriaNotifier.updateCategoria(
      categoriaBefore: categoriaBefore,
      categoria: categoria,
      onConfirm: () async {
        return await context.showWarningDialog(
          message: message,
        );
      },
      onConfirmUpdatePrecios: () async {
        return await context.showWarningDialog(
          message: messageConfirmUpdate,
        );
      },
      onSuccess: () {
        context.pop();
      },
    );
  }
}
