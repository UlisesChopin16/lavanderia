import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'base_dialog.dart';

class AnimatedImageDialog extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;
  final String actionText;
  final String closeText;
  final bool actionVisible;
  final VoidCallback? onActionPressed;

  const AnimatedImageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
    this.actionVisible = true,
    this.actionText = 'Aceptar',
    this.closeText = 'Cerrar',
    this.onActionPressed,
  });

  Widget get icon => Lottie.asset(
        imagePath,
        animate: true,
        repeat: true,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      );

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    return BaseDialog(
      icon: icon,
      title: title,
      closeText: closeText,
      actionText: actionText,
      actionVisible: actionVisible,
      requestFocus: true,
      onActionPressed: () {
        onActionPressed?.call();
        context.pop(true);
      },
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: labelLarge,
      ),
    );
  }
}
