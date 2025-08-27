enum UnitType {
  pieza(title: 'Pieza'),
  kilo(title: 'Kg'),
  litro(title: 'Litro'),
  metro(title: 'Metro'),
  gramo(title: 'Gramo'),
  miligramo(title: 'Mg'),
  mililitro(title: 'Ml');

  // Agrega más tipos de unidad según sea necesario
  final String title;


  const UnitType({required this.title});

  factory UnitType.fromString(String value) {
    return UnitType.values.firstWhere(
      (unit) => unit.title == value,
      orElse: () => UnitType.pieza, // Default to pieza if not found
    );
  }
}
