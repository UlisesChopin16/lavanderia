import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

class SaveEditComponent extends ConsumerWidget {
  const SaveEditComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final (isFirstTime) = ref.watch(
    //   configuracionEmpresaViewModelProvider.select(
    //     (value) => (value.isFirstTime),
    //   ),
    // );

    const title = 'Guardar datos';
    const icon = Icons.save_rounded;

    return FloatingActionButton.extended(
      onPressed: () => saveData(ref, context),
      label: const Text(title),
      icon: const Icon(icon),
    );
  }

  void saveData(WidgetRef ref, BuildContext context) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    configuracionNotifier.saveConfiguracionEmpresa(
      onSuccess: () {
        context.showSuccessDialog('Los datos de la empresa se han guardado correctamente.');
      },
    );
  }
}
