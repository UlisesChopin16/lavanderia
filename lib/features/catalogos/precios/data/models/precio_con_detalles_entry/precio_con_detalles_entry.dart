import 'package:lavanderia/core/database/app_database.dart';

class PrecioConDetallesEntry {
  final PreciosConceptosEntry precio;
  final SizesRopaEntry size;
  final CategoriaServicioEntry categoria;

  const PrecioConDetallesEntry(
    this.precio,
    this.size,
    this.categoria,
  );
}