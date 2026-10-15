import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/ui/views/precios/precios_view.dart';
import 'package:lavanderia/ui/shared/dialogs/base_dialog.dart';

class ShowPreciosDialog extends StatefulWidget {
  final CategoriaServicioEntity? categoria;
  const ShowPreciosDialog({super.key, this.categoria});

  @override
  State<ShowPreciosDialog> createState() => _ShowPreciosDialogState();
}

class _ShowPreciosDialogState extends State<ShowPreciosDialog> {
  CategoriaServicioEntity? get categoria => widget.categoria;
  String get title {
    if (categoria != null) {
      return 'Conceptos de la categoría "${categoria!.nombre}"';
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
        showInCard: false,
      ),
    );
  }
}
