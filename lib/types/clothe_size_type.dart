enum ClotheSizeType {
  chica(description: "Talla Chica"),
  mediana(description: "Talla Mediana"),
  grande(description: "Talla Grande"),
  extraGrande(description: "Talla Extra Grande"),
  individual(description: "Tamaño Individual"),
  matrimonial(description: "Tamaño Matrimonial"),
  queen(description: "Tamaño Queen"),
  king(description: "Tamaño King"),
  jumbo(description: "Tamaño Jumbo"),
  emptySize(description: "Sin tamaño");

  final String description;
  const ClotheSizeType({
    required this.description,
  });

  factory ClotheSizeType.fromString(String value) {
    return ClotheSizeType.values.firstWhere(
      (element) => element.description == value,
      orElse: () => ClotheSizeType.emptySize,
    );
  }
}
