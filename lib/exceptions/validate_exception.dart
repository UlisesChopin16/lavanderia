class ValidateException implements Exception {
  final String message;

  const ValidateException({required this.message});

  @override
  String toString() {
    return 'ValidateException: $message';
  }
}