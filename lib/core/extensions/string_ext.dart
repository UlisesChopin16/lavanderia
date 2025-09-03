extension StringExtensions on String {
  String normalizeSpaces() => trim() // quita espacios al inicio y al final
      .replaceAll(RegExp(r'\s+'), ' '); // reemplaza dobles, triples, etc. por un solo espacio

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isEmail {
    final regex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(this);
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

  bool get isEmail {
    if (this == null) return false;
    
    final regex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(this!);
  }
}
