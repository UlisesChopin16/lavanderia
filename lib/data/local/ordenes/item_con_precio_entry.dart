import 'package:lavanderia/data/local/app_database.dart';
import 'package:lavanderia/data/local/daos.dart';

class ItemConPrecioEntry {
  final PrecioConDetallesEntry precio;
  final ItemServicioOrdenEntry item;

  const ItemConPrecioEntry(
    this.item,
    this.precio,
  );
}
