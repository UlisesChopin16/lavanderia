import 'package:flutter/foundation.dart';
import 'package:lavanderia/core/error/exception_manager.dart';
import 'package:lavanderia/core/types/callbacks_types.dart';

extension SafeCallExt<T> on T? {
  Future<void> safeCall({
    AsyncCallback? actionBefore,
    AsyncCallback? actionAfter,
    AsyncCallback? action,
    AsyncCallbackError? onError,
  }) async {
    if (this == null) return;
    try {
      await actionBefore?.call();
      await action?.call();
    } catch (e, s) {
      final message = await ExceptionManager.instance.getErrorMessage(
        exception: e,
        stackTrace: s,
      );
      await onError?.call(e, message);
    } finally {
      await actionAfter?.call();
    }
  }
}
