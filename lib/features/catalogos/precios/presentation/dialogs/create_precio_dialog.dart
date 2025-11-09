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

class CreatePrecioDialog extends ConsumerStatefulWidget {
  const CreatePrecioDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePrecioDialogState();
}

class _CreatePrecioDialogState extends ConsumerState<CreatePrecioDialog> {
  late PrecioConDetallesEntity precio = const PrecioConDetallesEntity();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoria = ref.read(
        preciosViewModelProvider.select((state) => state.categoria),
      );
      if (categoria != null) {
        setState(() {
          precio = precio.copyWith(
            categoria: categoria,
            diasEntrega: categoria.diasEntrega,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(preciosViewModelProvider.select((state) => state.isLoading));
    return Stack(
      children: [
        BaseDialog(
          title: 'Crear concepto de ropa',
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
    const message = '¿Estás seguro de crear este concepto?';

    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);

    preciosNotifier.createPrecio(
      precio: precio,
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
