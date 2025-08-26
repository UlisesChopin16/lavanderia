import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/presentation/views/view_model/conceptos_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';

class AddConceptoDialog extends ConsumerStatefulWidget {
  const AddConceptoDialog({
    super.key,
  });

  @override
  ConsumerState<AddConceptoDialog> createState() => _AddConceptoDialogState();
}

class _AddConceptoDialogState extends ConsumerState<AddConceptoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  late String _nombre = '';
  final Set<CategoriaServicioEntity> _categoriasSeleccionadas = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final (categorias, isLoading) = ref.watch(
      conceptosViewModelProvider.select(
        (value) => (value.categorias, value.isLoading),
      ),
    );

    return Stack(
      children: [
        BaseDialog(
          title: 'Nuevo concepto de ropa',
          onActionPressed: validateNombre,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    onEditingComplete: validateNombre,
                    onChanged: onChangeNombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del concepto',
                      hintText: 'Ej: Playera, Tenis, Sábanas',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.normalizeSpaces().isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                ),
                const Gap(5),
                const Text('Seleccione las categorías en donde también aplica este concepto:'),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: categorias.map((categoria) {
                    return FilterChip(
                      label: Text(categoria.nombre),
                      selected: _categoriasSeleccionadas.contains(categoria),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _categoriasSeleccionadas.add(categoria);
                          } else {
                            _categoriasSeleccionadas.remove(categoria);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  void onChangeNombre(String nombre) {
    setState(() {
      _nombre = nombre.normalizeSpaces();
    });
  }

  void validateNombre() async {
    final conceptoNotifier = ref.read(conceptosViewModelProvider.notifier);
    if (_formKey.currentState?.validate() ?? false) {
      final confirm = await context.showWarningDialog(
        message: '¿Estás seguro de agregar el concepto "$_nombre"?',
      );

      if (!mounted) return;
      if (confirm == true) {
        conceptoNotifier.addConcepto(
          categoriasSeleccionadas: _categoriasSeleccionadas,
          nombre: _nombre,
          onSuccess: () {
            context.pop();
          },
        );
      }
    }
  }
}
