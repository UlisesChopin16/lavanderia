import 'package:flutter/foundation.dart';
import 'package:lavanderia/exceptions/exception_manager.dart';
import 'package:lavanderia/types/callbacks_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension SafeCallExt<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  Future<void> safeCall({
    AsyncCallback? actionBefore,
    AsyncCallback? actionAfter,
    AsyncCallback? action,
    AsyncCallbackError? actionOnError,
  }) async {
    try {
      await actionBefore?.call();
      await action?.call();
      await actionAfter?.call();
    } catch (e, s) {
      final message = await ExceptionManager.instance.handleException(
        exception: e,
        stackTrace: s,
      );
      await actionOnError?.call(e, message);
    } 
  }
}
