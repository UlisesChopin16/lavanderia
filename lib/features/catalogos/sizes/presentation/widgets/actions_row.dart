import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/dialogs/show_precios_dialog.dart';
import 'package:lavanderia/features/catalogos/presentation/dialogs/nombre_dialog.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/views/view_model/sizes_view_model.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final SizesRopaEntity size;
  final bool isSmall;
  const ActionsRow({
    super.key,
    required this.size,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isInactive => size.isInactive;
  bool get isSmall => widget.isSmall;
  SizesRopaEntity get size => widget.size;
  String get nombre => size.nombre;

  @override
  Widget build(BuildContext context) {
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    return ActionsButtons(
      isSmall: isSmall,
      actions: [
        DataAction(
          // canPop: false,
          callbackIndex: onShowConceptos,
          icon: Icons.visibility,
          isNotEnabled: false,
          color: Colors.blue,
          tooltip: 'Ver conceptos de ropa',
        ),
        if (!isInactive)
          DataAction(
            color: Colors.yellow,
            callbackIndex: onEditSize,
            icon: Icons.edit,
            isNotEnabled: blockUI,
            tooltip: 'Editar tamaño de ropa',
          ),
        if (!isInactive)
          DataAction(
            color: Colors.red,
            callbackIndex: onDeleteSize,
            icon: Icons.delete,
            isNotEnabled: blockUI,
            tooltip: 'Eliminar tamaño de ropa',
          ),
        if (size.estatus == EstatusType.inactivo)
          DataAction(
            color: Colors.green,
            callbackIndex: onRestoreSize,
            icon: Icons.restore,
            isNotEnabled: blockUI,
            tooltip: 'Activar tamaño de ropa',
          ),
      ],
    );
  }

  Future<String?> showNombreDialog() {
    const title = 'Editar tamaño de ropa';
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return NombreDialog(
          title: title,
          nombre: nombre,
          label: 'Nombre del tamaño',
          hintText: 'Ej: Chica, Mediana, Kingsize',
        );
      },
    );
  }

  void onShowConceptos() async {
    // Acción al presionar el botón de ver conceptos
    await showDialog(
      context: context,
      builder: (context) {
        return ShowPreciosDialog(sizeRopa: size);
      },
    );
  }


  void onEditSize() async {
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    // Acción al presionar el botón de agregar tamaño
    final nombre = await showNombreDialog();

    if (nombre == null) return;
    if (nombre.isEmpty) return;
    if (!mounted) return;

    final confirm = await context.showWarningDialog(
      message: '¿Estás seguro de editar este tamaño?',
    );

    if (confirm == true) {
      sizeRopaNotifier.updateSize(size.copyWith(nombre: nombre));
    }
  }

  void onDeleteSize() async {
    final question = '¿Estás seguro de desactivar el tamaño "${size.nombre}"?';
    const message =
        'Al desactivarlo, ya no estará disponible para su uso y se desactivarán todos los conceptos relacionados con él.';
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '$question\n$message',
    );
    if (response == true) {
      sizeRopaNotifier.desactivateSize(size);
    }
  }

  void onRestoreSize() async {
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '¿Estás seguro de activar el tamaño "${size.nombre}"?',
    );
    if (response == true) {
      sizeRopaNotifier.activateSize(size);
    }
  }
}
