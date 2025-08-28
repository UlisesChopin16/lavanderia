import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

abstract class PreciosWriteRepository {
  Future<int> insertPrecio({required PrecioConDetallesEntity precio});
  Future<bool> updatePrecio({required PrecioConDetallesEntity precio});
  Future<bool> deletePrecio({required PrecioConDetallesEntity precio});
  Future<void> rowExists(PrecioConDetallesEntity precio);
}
