import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/presentation/views/view_model/conceptos_view_model.dart';
import 'package:lavanderia/features/catalogos/presentation/dialogs/nombre_dialog.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final ConceptoEntity concepto;
  final bool isSmall;
  const ActionsRow({
    super.key,
    required this.concepto,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isInactive => concepto.isInactive;
  bool get isSmall => widget.isSmall;
  ConceptoEntity get concepto => widget.concepto;
  String get nombre => concepto.nombre;

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
          callbackIndex: () {},
          icon: Icons.visibility,
          isNotEnabled: false,
          color: Colors.blue,
          tooltip: 'Ver detalles del concepto',
        ),
        if (!isInactive)
          DataAction(
            color: Colors.yellow,
            callbackIndex: onEditConcepto,
            icon: Icons.edit,
            isNotEnabled: blockUI,
            tooltip: 'Editar concepto de ropa',
          ),
        if (!isInactive)
          DataAction(
            color: Colors.red,
            callbackIndex: onDeleteConcepto,
            icon: Icons.delete,
            isNotEnabled: blockUI,
            tooltip: 'Eliminar concepto de ropa',
          ),
        if (concepto.estatus == EstatusType.inactivo)
          DataAction(
            color: Colors.green,
            callbackIndex: onRestoreConcepto,
            icon: Icons.restore,
            isNotEnabled: blockUI,
            tooltip: 'Activar concepto de ropa',
          ),
      ],
    );
  }

  Future<String?> showNombreDialog() {
    const title = 'Editar concepto de ropa';
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return NombreDialog(
          title: title,
          nombre: nombre,
          label: 'Nombre del concepto',
          hintText: 'Ej: Playera, Tenis, Sábanas',
        );
      },
    );
  }

  void onEditConcepto() async {
    final conceptoNotifier = ref.read(conceptosViewModelProvider.notifier);
    // Acción al presionar el botón de agregar tamaño
    final nombre = await showNombreDialog();

    if (nombre == null) return;
    if (nombre.isEmpty) return;
    if (!mounted) return;

    final confirm = await context.showWarningDialog(
      message: '¿Estás seguro de editar este concepto?',
    );

    if (confirm == true) {
      conceptoNotifier.updateConcepto(concepto.copyWith(nombre: nombre));
    }
  }

  void onDeleteConcepto() async {
    final question = '¿Estás seguro de desactivar el concepto "${concepto.nombre}"?';
    const message =
        'Al desactivarlo, ya no estará disponible para su uso y se desactivarán todos los precios relacionados con él.';
    final conceptoNotifier = ref.read(conceptosViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '$question\n$message',
    );
    if (response == true) {
      conceptoNotifier.desactivateConcepto(concepto);
    }
  }

  void onRestoreConcepto() async {
    final conceptoNotifier = ref.read(conceptosViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '¿Estás seguro de activar el concepto "${concepto.nombre}"?',
    );
    if (response == true) {
      conceptoNotifier.updateConcepto(
        concepto.copyWith(
          estatus: EstatusType.activo,
          fechaEliminacion: null,
        ),
      );
    }
  }
}
