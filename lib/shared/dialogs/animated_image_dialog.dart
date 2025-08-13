import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    return AlertDialog.adaptive(
      title: Text(title),
      content: Column(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            imagePath,
            animate: true,
            repeat: true,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: labelLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            closeText,
            style: labelLarge?.copyWith(color: Colors.redAccent),
          ),
        ),
        if (actionVisible)
          FilledButton(
            onPressed: () {
              // Add any additional action if needed
              onActionPressed?.call();
              context.pop(true);
            },
            child: Text(
              actionText,
            ),
          ),
      ],
    );
  }
}
