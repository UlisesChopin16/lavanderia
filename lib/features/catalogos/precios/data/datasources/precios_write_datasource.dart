import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_model/precio_con_detalles_model.dart';
import 'package:lavanderia/features/catalogos/precios/domain/extensions/precio_con_detalles_ext.dart';

@lazySingleton
class PreciosWriteDatasource {
  final PreciosConceptosDao preciosDao;

  PreciosWriteDatasource(this.preciosDao);

  Future<int> insertPrecio({required PrecioConDetallesModel precio}) async {
    final row = precio.toCompanion();
    final id = await preciosDao.insertPrecio(row);
    return id;
  }

  Future<bool> updatePrecio({required PrecioConDetallesModel precio}) async {
    final entry = precio.toEntry();
    return await preciosDao.updateRelacion(entry);
  }

  Future<bool> deletePrecio({required PrecioConDetallesModel precio}) async {
    final entry = precio.toEntry();
    return await preciosDao.deleteRelacion(entry);
  }

  Future<void> rowExists(PrecioConDetallesModel precio) async {
    final row = precio.toCompanion();
    await preciosDao.rowExists(row);
  }
}
