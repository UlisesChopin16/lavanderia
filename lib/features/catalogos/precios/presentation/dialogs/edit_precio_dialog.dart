import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';

import '../widgets/row_fields_precio.dart';

class EditPrecioDialog extends ConsumerStatefulWidget {
  final PrecioConDetallesEntity precio;

  const EditPrecioDialog({
    super.key,
    required this.precio,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPrecioDialogState();
}

class _EditPrecioDialogState extends ConsumerState<EditPrecioDialog> {
  late PrecioConDetallesEntity precio = widget.precio;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(preciosViewModelProvider.select((state) => state.isLoading));
    return Stack(
      children: [
        BaseDialog(
          title: 'Editar concepto de ropa',
          icon: const Icon(IconsManager.clotheIcon),
          onActionPressed: validateFields,
          content: SizedBox(
            width: 800,
            child: SingleChildScrollView(
              child: RowFieldsPrecio(
                precio: precio,
                onChangePrecio: (newPrecio) {
                  setState(() {
                    precio = newPrecio;
                  });
                },
              ),
            ),
          ),
        ),
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  void validateFields() async {
    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);

    final message =
        '¿Estás seguro de editar el concepto "${precio.nombreConcepto}" de la categoría "${precio.categoria.nombre}" con el tamaño "${precio.size.description}"?';
    // final confirm = await context.showWarningDialog(
    //   message: message,
    // );

    preciosNotifier.updatePrecio(
      entity: precio,
      onConfirm: () async {
        final confirm = await context.showWarningDialog(
          message: message,
        );
        return confirm;
      },
      onSuccess: () {
        context.pop();
      },
    );
  }
}
