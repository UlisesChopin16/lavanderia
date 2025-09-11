import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/core/database/daos/daos.dart';

class ItemConPrecioEntry {
  final PrecioConDetallesEntry precio;
  final ItemServicioOrdenEntry item;

  const ItemConPrecioEntry(
    this.item,
    this.precio,
  );
}
