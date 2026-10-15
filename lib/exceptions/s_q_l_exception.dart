class SQLException implements Exception {
  final String message;

  const SQLException({required this.message});

  @override
  String toString() {
    return 'SQLException: $message';
  }
}