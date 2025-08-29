typedef AsyncCallbackError = Future<void> Function(Object error, String message);
typedef IndexValueChange<T> = void Function(int index, T value);