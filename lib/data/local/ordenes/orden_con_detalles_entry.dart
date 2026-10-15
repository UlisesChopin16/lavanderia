import 'package:lavanderia/data/local/app_database.dart';

class OrdenConDetallesEntry {
  final OrdenServicioEntry orden;
  final OrdenHistoryEntry detalles;
  final ClienteEntry cliente;

  OrdenConDetallesEntry({
    required this.orden,
    required this.detalles,
    required this.cliente,
  });
}
