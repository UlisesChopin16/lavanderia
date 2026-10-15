enum UnitType {
  pieza(value: 'Pieza', plural: 'Piezas'),
  // pieza(value: 'Juego', plural: 'Juegos'),
  kilo(value: 'Kg', plural: 'Kgs'),
  // juego(value: 'Juego', le),
  litro(value: 'Litro', plural: 'Litros'),
  metro(value: 'Metro', plural: 'Metros'),
  gramo(value: 'Gramo', plural: 'Gramos'),
  miligramo(value: 'Miligramo', plural: 'Mililitros'),
  mililitro(value: 'Mililitro', plural: 'Miligramos');

  // Agrega más tipos de unidad según sea necesario
  final String value;
  final String plural;

  const UnitType({required this.value, required this.plural});

  factory UnitType.fromString(String value) {
    return UnitType.values.firstWhere(
      (unit) => unit.value == value,
      orElse: () => UnitType.pieza, // Default to pieza if not found
    );
  }
}
