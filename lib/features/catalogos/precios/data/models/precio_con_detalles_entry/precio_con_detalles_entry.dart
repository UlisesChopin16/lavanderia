import 'package:lavanderia/core/database/app_database.dart';

class PrecioConDetallesEntry {
  final PreciosConceptosEntry precio;
  final CategoriaServicioEntry categoria;

  const PrecioConDetallesEntry(
    this.precio,
    this.categoria,
  );
}
