import 'package:flutter/material.dart';
import 'package:lavanderia/core/assets/assets.gen.dart';
import 'package:lavanderia/shared/dialogs/animated_image_dialog.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  const SuccessDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedImageDialog(
      title: 'Éxito',
      message: message,
      imagePath: Assets.success.path, // Path to your success animation
      actionVisible: false,
    );
  }
}