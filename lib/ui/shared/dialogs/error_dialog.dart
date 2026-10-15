import 'package:material_ui/material_ui.dart';
import 'package:lavanderia/utils/assets/assets.gen.dart';
import 'package:lavanderia/ui/shared/dialogs/animated_image_dialog.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedImageDialog(
      title: 'Error',
      message: message,
      imagePath: Assets.error.path, // Path to your error animation
      actionVisible: false,
    );
  }
}