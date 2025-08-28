import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_write_repository.dart';

@lazySingleton
class DesactivatePrecio {
  final PreciosWriteRepository repository;

  DesactivatePrecio(this.repository);

  Future<void> call(PrecioConDetallesEntity precio) async {
    await repository.deletePrecio(precio: precio);
  }
}
