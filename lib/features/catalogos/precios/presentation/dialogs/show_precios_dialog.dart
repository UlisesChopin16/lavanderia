import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/precios_view.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class ShowPreciosDialog extends StatefulWidget {
  final CategoriaServicioEntity? categoria;
  final SizesRopaEntity? sizeRopa;
  const ShowPreciosDialog({super.key, this.categoria, this.sizeRopa});

  @override
  State<ShowPreciosDialog> createState() => _ShowPreciosDialogState();
}

class _ShowPreciosDialogState extends State<ShowPreciosDialog> {
  CategoriaServicioEntity? get categoria => widget.categoria;
  SizesRopaEntity? get sizeRopa => widget.sizeRopa;
  String get title {
    if (categoria != null) {
      return 'Conceptos de la categoría "${categoria!.nombre}"';
    }
    if (sizeRopa != null) {
      return 'Conceptos del tamaño "${sizeRopa!.nombre}"';
    }
    return 'Conceptos de ropa';
  }

  @override
  Widget build(BuildContext context) {
    // Printer.i('Mostrando dialogo de precios');
    // Printer.i('Categoria: ${categoria?.nombre}');
    // Printer.i('Tamaño: ${sizeRopa?.nombre}');

    return BaseDialog(
      title: title,
      onActionPressed: () {
        context.pop();
      },
      content: PreciosView(
        categoria: categoria,
        sizeRopa: sizeRopa,
        showInCard: false,
      ),
    );
  }
}
