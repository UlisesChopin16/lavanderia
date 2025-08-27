import 'package:lavanderia/core/database/app_database.dart';

class PrecioConDetalles {
  final PreciosConceptosEntry precio;
  final ItemServicioEntry item;
  final SizesRopaEntry size;
  final CategoriaServicioEntry categoria;

  const PrecioConDetalles(
    this.precio,
    this.item,
    this.size,
    this.categoria,
  );
}