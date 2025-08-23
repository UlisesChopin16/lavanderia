import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/presentation/dialogs/nombre_dialog.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/views/view_model/sizes_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final SizesRopaEntity size;
  final bool isSmall;
  const ActionsRow({super.key, required this.size, required this.isSmall});

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
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    
    return ActionsButtons(
      isSmall: isSmall,
      actions: [
        if (!isInactive)
          DataAction(
            color: Colors.blue,
            callbackIndex: () async {
              final nombre = await showNombreDialog();
              if (nombre != null && nombre.isNotEmpty) {
                sizeRopaNotifier.updateSize(size.copyWith(nombre: nombre));
              }
            },
            icon: Icons.edit,
            isNotEnabled: false,
            tooltip: 'Editar tamaño de ropa',
          ),
        if (!isInactive)
          DataAction(
            color: Colors.red,
            callbackIndex: () async {
              final response = await context.showWarningDialog(
                message:
                    '¿Estás seguro de desactivar el tamaño "${size.nombre}"?\nAl desactivarlo, ya no estará disponible para su uso.',
              );
              if (response == true) {
                sizeRopaNotifier.desactivateSize(size);
              }
            },
            icon: Icons.delete,
            isNotEnabled: false,
            tooltip: 'Eliminar tamaño de ropa',
          ),
        if (size.estatus == EstatusType.inactivo)
          DataAction(
            color: Colors.green,
            callbackIndex: () async {
              final response = await context.showWarningDialog(
                message: '¿Estás seguro de activar el tamaño "${size.nombre}"?',
              );
              if (response == true) {
                sizeRopaNotifier.updateSize(
                  size.copyWith(
                    estatus: EstatusType.activo,
                    fechaEliminacion: null,
                  ),
                );
              }
            },
            icon: Icons.restore,
            isNotEnabled: false,
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
}
