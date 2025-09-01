import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

import '../dialogs/edit_precio_dialog.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final PrecioConDetallesEntity precio;
  final bool isSmall;

  const ActionsRow({
    super.key,
    required this.precio,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isActive => precio.isActive;
  bool get isSmall => widget.isSmall;
  PrecioConDetallesEntity get precio => widget.precio;
  String get nombre => precio.nombreConcepto;

  @override
  Widget build(BuildContext context) {
    return ActionsButtons(
      isSmall: isSmall,
      actions: [
        if (isActive)
          DataAction(
            color: Colors.blue,
            callbackIndex: onEditConcepto,
            icon: Icons.edit,
            isNotEnabled: false,
            tooltip: 'Editar concepto de ropa',
          ),
        if (isActive)
          DataAction(
            color: Colors.red,
            callbackIndex: onDeleteConcepto,
            icon: Icons.delete,
            isNotEnabled: false,
            tooltip: 'Eliminar concepto de ropa',
          ),
        if (!isActive)
          DataAction(
            color: Colors.green,
            callbackIndex: onRestoreConcepto,
            icon: Icons.restore,
            isNotEnabled: false,
            tooltip: 'Activar concepto de ropa',
          ),
      ],
    );
  }

  Future<void> showEditDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditPrecioDialog(precio: precio);
      },
    );
  }

  void onEditConcepto() async {
    // Acción al presionar el botón de agregar tamaño
    await showEditDialog();
  }

  void onDeleteConcepto() async {
    final question =
        '¿Estás seguro de desactivar el concepto "${precio.nombreConcepto}" de la categoría "${precio.categoria.nombre}" con el tamaño "${precio.size.nombre}"?';
    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);

    final response = await context.showWarningDialog(message: question);

    if (response == true) {
      preciosNotifier.desactivatePrecio(precio);
    }
  }

  void onRestoreConcepto() async {
    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message:
          '¿Estás seguro de activar el concepto "${precio.nombreConcepto}" de la categoría "${precio.categoria.nombre}" con el tamaño "${precio.size.nombre}"?',
    );
    if (response == true) {
      preciosNotifier.activatePrecio(precio);
    }
  }
}
