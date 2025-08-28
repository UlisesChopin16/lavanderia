enum UnitType {
  pieza(value: 'Pieza'),
  kilo(value: 'Kg'),
  litro(value: 'Litro'),
  metro(value: 'Metro'),
  gramo(value: 'Gramo'),
  miligramo(value: 'Mg'),
  mililitro(value: 'Ml');

  // Agrega más tipos de unidad según sea necesario
  final String value;


  const UnitType({required this.value});

  factory UnitType.fromString(String value) {
    return UnitType.values.firstWhere(
      (unit) => unit.value == value,
      orElse: () => UnitType.pieza, // Default to pieza if not found
    );
  }
}
