import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class VerifyPasswordDialog extends ConsumerStatefulWidget {
  const VerifyPasswordDialog({super.key});

  @override
  ConsumerState<VerifyPasswordDialog> createState() => _VerifyPasswordDialogState();
}

class _VerifyPasswordDialogState extends ConsumerState<VerifyPasswordDialog> {
  String password = '';
  @override
  Widget build(BuildContext context) {
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return BaseDialog(
      title: 'Ingresar al modo administrador',
      closeText: 'Cancelar',
      actionText: 'Verificar',
      onActionPressed: validatePassword,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            const Text('Ingresa tu contraseña para continuar.'),
            TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              onChanged: (value) {
                password = value;
              },
              onEditingComplete: validatePassword,
            ),
          ],
        ),
      ),
    );
  }

  void validatePassword() async {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final isValid = configuracionNotifier.verifyPassword(password);
    if (isValid) {
      final confirm = await context.showWarningDialog(
        message: '¿Estás seguro de entrar al modo administrador?\n'
            'Esta acción habilitará botones de creación, edición y eliminación.',
      );
      if (!mounted) return;
      if (confirm == true) {
        configuracionNotifier.setBlockUI(false);
        await context.showSuccessDialog(
          'Modo administrador habilitado.\n'
          'Recuerda desactivar el modo administrador cuando termines.',
        );
      }
      if (!mounted) return;
      context.pop();
    }
  }
}
