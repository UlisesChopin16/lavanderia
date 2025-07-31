import 'package:flutter/foundation.dart';

class ExceptionManager {
  static const defaultMessage = 'Ocurrió un error en la operación, reintente más tarde.';

  ExceptionManager._();

  static final ExceptionManager _instance = ExceptionManager._();

  static ExceptionManager get instance => _instance;

  Future<String> handleException({
    required dynamic exception,
    required StackTrace stackTrace,
    String? customMessage,
    bool sendCrash = false,
  }) async {
    final message = await getErrorMessage(
      exception: exception,
      stackTrace: stackTrace,
      customMessage: customMessage,
    );

    return customMessage ?? message;
  }

  Future<String> getErrorMessage({
    required dynamic exception,
    required StackTrace stackTrace,
    String? customMessage,
  }) async {
    // Implement logic to convert exception to a user-friendly message
    // return customMessage ?? 'An unexpected error occurred';
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);

    print('Exception: $exception');
    return customMessage ?? defaultMessage;
  }
}
