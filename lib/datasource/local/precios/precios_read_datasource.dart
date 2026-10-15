import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/models/dto/precios/precio_con_detalles_model.dart';
import 'package:lavanderia/models/data/precios/filtros_precios.dart';
import 'package:lavanderia/extensions/precio_con_detalles_ext.dart';

@lazySingleton
class PreciosReadDatasource {
  final PreciosConceptosDao preciosDao;

  PreciosReadDatasource(this.preciosDao);

  Future<List<PrecioConDetallesModel>> getAll() async {
    final precios = await preciosDao.getAll();
    return convertToModelList(precios);
  }

  Stream<List<PrecioConDetallesModel>> watchAllByCategoria({
    required int categoriaId,
    required FiltrosPrecios filtros,
  }) {
    final preciosStream = preciosDao.watchAllByCategoria(
      categoriaId: categoriaId,
      filtros: filtros,
    );
    return convertToModel(preciosStream);
  }

  Stream<List<PrecioConDetallesModel>> watchAll({
    required FiltrosPrecios filtros,
  }) {
    final preciosStream = preciosDao.watchAll(
      filtros: filtros,
    );
    return convertToModel(preciosStream);
  }

  Stream<List<PrecioConDetallesModel>> convertToModel(Stream<List<PrecioConDetallesEntry>> stream) {
    return stream.map(convertToModelList);
  }

  List<PrecioConDetallesModel> convertToModelList(List<PrecioConDetallesEntry> entries) {
    return entries.map((e) => e.toModel()).toList();
  }

}
