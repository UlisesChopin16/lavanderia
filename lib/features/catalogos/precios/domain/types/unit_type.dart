enum UnitType {
  pieza(value: 'Pieza', letters: 'Pz'),
  kilo(value: 'Kg', letters: 'Kg'),
  // juego(value: 'Juego', le),
  litro(value: 'Litro', letters: 'Li'),
  metro(value: 'Metro', letters: 'M'),
  gramo(value: 'Gramo', letters: 'Gr'),
  miligramo(value: 'Miligramo', letters: 'Ml'),
  mililitro(value: 'Mililitro', letters: 'Mg');

  // Agrega más tipos de unidad según sea necesario
  final String value;
  final String letters;

  const UnitType({required this.value, required this.letters});

  factory UnitType.fromString(String value) {
    return UnitType.values.firstWhere(
      (unit) => unit.value == value,
      orElse: () => UnitType.pieza, // Default to pieza if not found
    );
  }
}
