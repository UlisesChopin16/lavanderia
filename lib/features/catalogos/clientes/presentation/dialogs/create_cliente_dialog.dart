import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/views/view_model/clientes_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';

import '../widgets/row_fields_cliente.dart';

class CreateClienteDialog extends ConsumerStatefulWidget {
  final ClienteEntity? cliente;
  const CreateClienteDialog({super.key, this.cliente});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateClienteDialogState();
}

class _CreateClienteDialogState extends ConsumerState<CreateClienteDialog> {
  late ClienteEntity cliente = widget.cliente ?? const ClienteEntity();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(clientesViewModelProvider.select((state) => state.isLoading));
    return Stack(
      children: [
        BaseDialog(
          title: 'Registrar nuevo cliente',
          icon: const Icon(Icons.person_add),
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
    const message = '¿Estás seguro de registrar a este nuevo cliente?';

    final clientesNotifier = ref.read(clientesViewModelProvider.notifier);

    clientesNotifier.createCliente(
      cliente: cliente,
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
