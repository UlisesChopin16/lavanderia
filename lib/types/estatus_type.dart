enum EstatusType {
  todos(value: 'Todos'),
  activo(value: 'Activo'),
  inactivo(value: 'Inactivo');

  final String value;
  const EstatusType({
    required this.value,
  });

  factory EstatusType.fromString(String value) {
    return EstatusType.values.firstWhere(
      (estatus) => estatus.value == value,
      orElse: () => EstatusType.inactivo, // Default to inactivo if not found
    );
  }
}
