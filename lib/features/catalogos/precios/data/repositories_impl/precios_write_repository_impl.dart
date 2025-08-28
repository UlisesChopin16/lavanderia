import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/precios/data/datasources/precios_write_datasource.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/extensions/precio_con_detalles_ext.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_write_repository.dart';

@LazySingleton(as: PreciosWriteRepository)
class PreciosWriteRepositoryImpl implements PreciosWriteRepository {

  final PreciosWriteDatasource datasource;

  const PreciosWriteRepositoryImpl(this.datasource);

  @override
  Future<int> insertPrecio({required PrecioConDetallesEntity precio}) async {
    // Implementación de la inserción de precios
    final model = precio.toModel();
    return await datasource.insertPrecio(precio: model);
  }

  @override
  Future<bool> updatePrecio({required PrecioConDetallesEntity precio}) async {
    // Implementación de la actualización de precios
    final model = precio.toModel();
    return await datasource.updatePrecio(precio: model);
  }

  @override
  Future<bool> deletePrecio({required PrecioConDetallesEntity precio}) async {
    // Implementación de la eliminación de precios
    final model = precio.toModel();
    return await datasource.deletePrecio(precio: model);
  }

  @override
  Future<void> rowExists(PrecioConDetallesEntity precio) async {
    // Implementación de la verificación de existencia de fila
    final model = precio.toModel();
    await datasource.rowExists(model);
  }
}
