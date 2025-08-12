import 'package:flutter/material.dart';
import 'package:lavanderia/shared/dialogs/error_dialog.dart';
import 'package:lavanderia/shared/dialogs/success_dialog.dart';
import 'package:lavanderia/shared/dialogs/warning_dialog.dart';

extension BuildContextExt on BuildContext {
  // Add your extension methods here
  Future<void> showSuccessDialog(String message) async {
    await showDialog(
      context: this,
      builder: (context) {
        return SuccessDialog(message: message);
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: this,
      builder: (context) {
        return ErrorDialog(message: message);
      },
    );
  }

  Future<bool?> showWarningDialog(String message, {String title = 'Advertencia'}) async {
    return await showDialog<bool?>(
      context: this,
      builder: (context) {
        return WarningDialog(
          title: title,
          message: message,
        );
      },
    );
  }
}