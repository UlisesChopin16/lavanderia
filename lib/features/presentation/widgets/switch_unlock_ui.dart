import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/presentation/dialogs/verify_password_dialog.dart';

class SwitchUnlockUi extends ConsumerWidget {
  const SwitchUnlockUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    final icon = blockUI ? Icons.lock_rounded : Icons.lock_open_rounded;
    return Switch(
      value: blockUI,
      onChanged: (value) {
        if (!value) {
          showDialog(
            context: context,
            builder: (context) {
              return const VerifyPasswordDialog();
            },
          );
          return;
        }
        configuracionNotifier.setBlockUI(value);
      },
      thumbIcon: WidgetStatePropertyAll(
        Icon(
          icon,
        ),
      ),
    );
  }
}
