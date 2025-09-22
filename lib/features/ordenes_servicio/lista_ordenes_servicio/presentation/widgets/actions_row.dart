import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/dialogs/show_history.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final OrdenConDetallesEntity ordenServicio;
  final bool isSmall;
  const ActionsRow({
    super.key,
    required this.ordenServicio,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isCerrada => ordenServicio.isCerrada;
  bool get isSmall => widget.isSmall;
  OrdenConDetallesEntity get ordenServicio => widget.ordenServicio;
  String get folio => ordenServicio.folio;

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
          callbackIndex: showHistoryOrder,
          icon: Icons.history_rounded,
          isNotEnabled: false,
          color: Colors.blue,
          tooltip: 'Ver historial de la orden',
        ),
        if (!isCerrada)
          DataAction(
            color: Colors.yellow,
            callbackIndex: () {},
            icon: Icons.edit,
            isNotEnabled: blockUI,
            tooltip: 'Editar tamaño de ropa',
          ),
        if (!isCerrada)
          DataAction(
            color: Colors.red,
            callbackIndex: () {},
            icon: Icons.delete,
            isNotEnabled: blockUI,
            tooltip: 'Eliminar tamaño de ropa',
          ),
        // if (size.estatus == EstatusType.inactivo)
        //   DataAction(
        //     color: Colors.green,
        //     callbackIndex: onRestoreSize,
        //     icon: Icons.restore,
        //     isNotEnabled: blockUI,
        //     tooltip: 'Activar tamaño de ropa',
        //   ),
      ],
    );
  }

  Future<void> showHistoryOrder() async {
    // const title = 'Historial de la orden';
    await showDialog<void>(
      context: context,
      builder: (context) {
        return ShowHistory(orden: ordenServicio);
      },
    );
  }

  // void onShowConceptos() async {
  //   // Acción al presionar el botón de ver conceptos
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return ShowPreciosDialog(sizeRopa: size);
  //     },
  //   );
  // }

  // void onEditSize() async {
  //   final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
  //   // Acción al presionar el botón de agregar tamaño
  //   final nombre = await showNombreDialog();

  //   if (nombre == null) return;
  //   if (nombre.isEmpty) return;
  //   if (!mounted) return;

  //   final confirm = await context.showWarningDialog(
  //     message: '¿Estás seguro de editar este tamaño?',
  //   );

  //   if (confirm == true) {
  //     sizeRopaNotifier.updateSize(size.copyWith(nombre: nombre));
  //   }
  // }

  // void onDeleteSize() async {
  //   final question = '¿Estás seguro de desactivar el tamaño "${size.nombre}"?';
  //   const message =
  //       'Al desactivarlo, ya no estará disponible para su uso y se desactivarán todos los conceptos relacionados con él.';
  //   final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
  //   final response = await context.showWarningDialog(
  //     message: '$question\n$message',
  //   );
  //   if (response == true) {
  //     sizeRopaNotifier.desactivateSize(size);
  //   }
  // }

  // void onRestoreSize() async {
  //   final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
  //   final response = await context.showWarningDialog(
  //     message: '¿Estás seguro de activar el tamaño "${size.nombre}"?',
  //   );
  //   if (response == true) {
  //     sizeRopaNotifier.activateSize(size);
  //   }
  // }
}
