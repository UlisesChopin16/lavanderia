import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

import '../dialogs/edit_cliente_dialog.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final ClienteEntity cliente;
  final bool isSmall;
  const ActionsRow({
    super.key,
    required this.cliente,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isSmall => widget.isSmall;
  ClienteEntity get cliente => widget.cliente;

  @override
  Widget build(BuildContext context) {
    // final blockUI = ref.watch(
    //   configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    // );
    return ActionsButtons(
      isSmall: isSmall,
      actions: [
        // DataAction(
        //   // canPop: false,
        //   callbackIndex: onShowConceptos,
        //   icon: Icons.visibility,
        //   isNotEnabled: false,
        //   color: Colors.blue,
        //   tooltip: 'Ver conceptos de ropa',
        // ),
        DataAction(
          color: Colors.yellow,
          callbackIndex: onEditCliente,
          icon: Icons.edit,
          isNotEnabled: false,
          tooltip: 'Editar cliente',
        ),
      ],
    );
  }

  Future<void> showEditDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditClienteDialog(cliente: cliente);
      },
    );
  }

  void onEditCliente() async {
    // Acción al presionar el botón de agregar cliente
    await showEditDialog();
  }
}
