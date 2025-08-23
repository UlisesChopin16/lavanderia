extension StringExtensions on String {
  String normalizeSpaces() => trim() // quita espacios al inicio y al final
      .replaceAll(RegExp(r'\s+'), ' '); // reemplaza dobles, triples, etc. por un solo espacio
}
