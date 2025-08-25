extension StringExtensions on String {
  String normalizeSpaces() => trim() // quita espacios al inicio y al final
      .replaceAll(RegExp(r'\s+'), ' '); // reemplaza dobles, triples, etc. por un solo espacio

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringNullExtensions on String? {
  String normalizeSpaces() {
    if (this == null) return '';

    return this!.trim() // quita espacios al inicio y al final
        .replaceAll(RegExp(r'\s+'), ' '); // reemplaza dobles, triples, etc. por un solo espacio
  }

  String capitalize() {
    if (this == null || this!.isEmpty) return '';
    return this![0].toUpperCase() + this!.substring(1);
  }
}
