import 'package:flutter/material.dart';
import 'package:lavanderia/core/assets/assets.gen.dart';
import 'package:lavanderia/shared/dialogs/animated_image_dialog.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String message;
  const WarningDialog({
    super.key,
    required this.message,
    this.title = 'Advertencia',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedImageDialog(
      title: title,
      message: message,
      closeText: 'Cancelar',
      imagePath: Assets.warning.path, // Path to your warning animation
      actionVisible: true,
    );
  }
}
