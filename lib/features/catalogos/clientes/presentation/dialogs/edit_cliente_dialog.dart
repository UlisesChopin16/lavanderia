import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/views/view_model/clientes_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';

import '../widgets/row_fields_cliente.dart';

class EditClienteDialog extends ConsumerStatefulWidget {
  final ClienteEntity cliente;

  const EditClienteDialog({
    super.key,
    required this.cliente,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditClienteDialogState();
}

class _EditClienteDialogState extends ConsumerState<EditClienteDialog> {
  late ClienteEntity cliente = widget.cliente;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(clientesViewModelProvider.select((state) => state.isLoading));
    return Stack(
      children: [
        BaseDialog(
          title: 'Editar cliente',
          icon: const Icon(Icons.person),
          onActionPressed: validateFields,
          content: SizedBox(
            width: 350,
            child: SingleChildScrollView(
              child: RowFieldsCliente(
                cliente: cliente,
                onChangeCliente: (newCliente) {
                  setState(() {
                    cliente = newCliente;
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
    final clientesNotifier = ref.read(clientesViewModelProvider.notifier);

    const message = '¿Estás seguro de editar a este cliente?';
    // final confirm = await context.showWarningDialog(
    //   message: message,
    // );

    clientesNotifier.updateCliente(
      entity: cliente,
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
