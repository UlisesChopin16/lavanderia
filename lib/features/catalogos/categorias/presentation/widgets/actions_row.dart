import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/views/view_model/categoria_view_model.dart';
// import 'package:lavanderia/features/catalogos/categorias/conceptos/presentation/views/conceptos_view.dart';
import 'package:lavanderia/features/catalogos/presentation/dialogs/nombre_dialog.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

class ActionsRow extends ConsumerStatefulWidget {
  final CategoriaServicioEntity categoria;
  final bool isSmall;
  const ActionsRow({
    super.key,
    required this.categoria,
    this.isSmall = false,
  });

  @override
  ConsumerState<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends ConsumerState<ActionsRow> {
  bool get isInactive => categoria.isInactive;
  bool get isSmall => widget.isSmall;
  CategoriaServicioEntity get categoria => widget.categoria;
  String get nombre => categoria.nombre;

  @override
  Widget build(BuildContext context) {
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    return ActionsButtons(
      isSmall: isSmall,
      actions: [
        // DataAction(
        //   // canPop: false,
        //   callbackIndex: onViewConceptos,
        //   icon: Icons.visibility,
        //   isNotEnabled: false,
        //   color: Colors.blue,
        //   tooltip: 'Ver conceptos de ropa',
        // ),
        if (!isInactive)
          DataAction(
            color: Colors.yellow,
            callbackIndex: onEditCategoria,
            icon: Icons.edit,
            isNotEnabled: blockUI,
            tooltip: 'Editar categoría de ropa',
          ),
        if (!isInactive)
          DataAction(
            color: Colors.red,
            callbackIndex: onDeleteCategoria,
            icon: Icons.delete,
            isNotEnabled: blockUI,
            tooltip: 'Eliminar categoría de ropa',
          ),
        if (categoria.estatus == EstatusType.inactivo)
          DataAction(
            color: Colors.green,
            callbackIndex: onRestoreCategoria,
            icon: Icons.restore,
            isNotEnabled: blockUI,
            tooltip: 'Activar categoría de ropa',
          ),
      ],
    );
  }

  Future<String?> showNombreDialog() {
    const title = 'Editar categoría de ropa';
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return NombreDialog(
          title: title,
          nombre: nombre,
          label: 'Nombre de la categoría',
          hintText: 'Ej: Lavandería, Planchado, Tintorería',
        );
      },
    );
  }

  void onEditCategoria() async {
    final categoriaRopaNotifier = ref.read(categoriaViewModelProvider.notifier);
    // Acción al presionar el botón de agregar tamaño
    final nombre = await showNombreDialog();

    if (nombre == null) return;
    if (nombre.isEmpty) return;
    if (!mounted) return;

    final confirm = await context.showWarningDialog(
      message: '¿Estás seguro de editar esta categoría?',
    );

    if (confirm == true) {
      categoriaRopaNotifier.updateCategoria(categoria.copyWith(nombre: nombre));
    }
  }

  void onDeleteCategoria() async {
    final question = '¿Estás seguro de desactivar la categoría "${categoria.nombre}"?';
    const message =
        'Al desactivarlo, ya no estará disponible para su uso y se desactivarán todos los conceptos relacionados con él.';
    final categoriaRopaNotifier = ref.read(categoriaViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '$question\n$message',
    );
    if (response == true) {
      categoriaRopaNotifier.desactivateCategoria(categoria);
    }
  }

  void onRestoreCategoria() async {
    final categoriaRopaNotifier = ref.read(categoriaViewModelProvider.notifier);
    final response = await context.showWarningDialog(
      message: '¿Estás seguro de activar la categoría "${categoria.nombre}"?',
    );
    if (response == true) {
      categoriaRopaNotifier.updateCategoria(
        categoria.copyWith(
          estatus: EstatusType.activo,
          fechaEliminacion: null,
        ),
      );
    }
  }

  // void onViewConceptos() async {
  //   // Acción al presionar el botón de ver conceptos
  //   await showDialog(context: context, builder: (context) {
  //     return ConceptosView(categoria: categoria);
  //   });
  // }
}
