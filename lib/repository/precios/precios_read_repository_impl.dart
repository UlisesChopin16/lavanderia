import 'package:injectable/injectable.dart';
import 'package:lavanderia/datasource/local/precios/precios_read_datasource.dart';
import 'package:lavanderia/models/dto/precios/precio_con_detalles_model.dart';
import 'package:lavanderia/models/data/precios/filtros_precios.dart';
import 'package:lavanderia/models/data/precios/precio_con_detalles_entity.dart';
import 'package:lavanderia/extensions/precio_con_detalles_ext.dart';
import 'package:lavanderia/repository/precios/precios_read_repository.dart';

@LazySingleton(as: PreciosReadRepository)
class PreciosReadRepositoryImpl implements PreciosReadRepository {
  final PreciosReadDatasource datasource;

  const PreciosReadRepositoryImpl(this.datasource);

  @override
  Stream<List<PrecioConDetallesEntity>> watchAllByCategoria({
    required int categoriaId,
    required FiltrosPrecios filtros,
  }) {
    // Implementación de la lógica para observar todos los precios por categoría
    final data = datasource.watchAllByCategoria(categoriaId: categoriaId, filtros: filtros);
    return convertToEntity(data);
  }

  @override
  Stream<List<PrecioConDetallesEntity>> watchAll({
    required FiltrosPrecios filtros
  }) {
    // Implementación de la lógica para observar todos los precios
    final data = datasource.watchAll(filtros: filtros);
    return convertToEntity(data);
  }

  Stream<List<PrecioConDetallesEntity>> convertToEntity(Stream<List<PrecioConDetallesModel>> stream) {
    return stream.map(convertToEntityList);
  }

  List<PrecioConDetallesEntity> convertToEntityList(List<PrecioConDetallesModel> entries) {
    return entries.map((e) => e.toEntity()).toList();
  }
  
  @override
  Future<List<PrecioConDetallesEntity>> getAll() async {
    final data = await datasource.getAll();
    return convertToEntityList(data);
  }
}
