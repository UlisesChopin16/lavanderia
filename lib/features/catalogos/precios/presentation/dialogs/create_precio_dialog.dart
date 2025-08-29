import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/widgets/row_fields_precio.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';

class CreatePrecioDialog extends ConsumerStatefulWidget {
  const CreatePrecioDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePrecioDialogState();
}

class _CreatePrecioDialogState extends ConsumerState<CreatePrecioDialog> {
  List<PrecioConDetallesEntity> precios = [];

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(preciosViewModelProvider.select((state) => state.isLoading));
    return Stack(
      children: [
        BaseDialog(
          title: 'Crear Precios',
          content: Column(
            spacing: 15,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    children: [
                      // Aquí puedes agregar los campos para crear un nuevo precio
                      ...List.generate(precios.length, (index) {
                        final precio = precios[index];
                        return RowFieldsPrecio(
                          index: index,
                          precio: precio,
                          onChangePrecio: (index, newPrecio) {
                            setState(() {
                              final newPrecios = [...precios];
                              newPrecios[index] = newPrecio;
                              precios = newPrecios;
                            });
                          },
                          onRemove: () {
                            checkIsEmpty(index);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  void addNewPrecio() {
    setState(() {
      final newPrecios = [...precios, const PrecioConDetallesEntity()];
      precios = newPrecios;
    });
  }

  void checkIsEmpty(int index) async {
    final precio = precios[index];
    if (precio.isEmpty) {
      removePrecio(index);
      return;
    }

    final newIndex = index + 1;
    final confirm = await context.showWarningDialog(
      message: 'El Concepto #$newIndex no está vacío\n¿Seguro que deseas eliminarlo?',
    );

    if (confirm == true) {
      removePrecio(index);
    }
  }

  void removePrecio(int index) {
    setState(() {
      final newPrecios = [...precios];
      newPrecios.removeAt(index);
      precios = newPrecios;
    });
  }
}
