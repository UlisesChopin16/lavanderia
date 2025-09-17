import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DeleteButton({super.key, this.onPressed});

  static const double size = 16.0;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return IconButton(
      // isSelected: true,
      icon: Icon(
        Icons.cancel,
        color: primaryColor,
      ),
      onPressed: onPressed,
    );
  }
}
