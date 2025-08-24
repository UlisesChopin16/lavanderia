import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This dialog return a [Future] that resolves to a boolean value indicating the user's action.
class BaseDialog extends StatelessWidget {
  final bool actionVisible;
  final String title;
  final String closeText;
  final String actionText;
  final bool requestFocus;
  final VoidCallback? onActionPressed;
  final Widget content;
  final Widget? icon;

  const BaseDialog({
    super.key,
    required this.title,
    required this.content,
    this.actionVisible = true,
    this.actionText = 'Aceptar',
    this.closeText = 'Cerrar',
    this.icon,
    this.onActionPressed,
    this.requestFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    return AlertDialog.adaptive(
      icon: icon,
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          autofocus: actionVisible ? false : requestFocus,
          onPressed: () {
            context.pop();
          },
          child: Text(
            closeText,
            style: labelLarge?.copyWith(color: Colors.redAccent),
          ),
        ),
        if (actionVisible)
          FilledButton(
            autofocus: requestFocus,
            onPressed: () {
              // Add any additional action if needed
              onActionPressed?.call();
            },
            child: Text(
              actionText,
            ),
          ),
      ],
    );
  }
}
