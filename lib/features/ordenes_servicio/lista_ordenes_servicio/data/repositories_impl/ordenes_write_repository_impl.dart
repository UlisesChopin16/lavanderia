import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/datasources/ordenes_write_datasource.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/extensions/orden_con_detalles_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/repositories/ordenes_write_repository.dart';

@LazySingleton(as: OrdenesWriteRepository)
class OrdenesWriteRepositoryImpl implements OrdenesWriteRepository {
  final OrdenesWriteDatasource _datasource;

  OrdenesWriteRepositoryImpl(this._datasource);

  @override
  Future<OrdenConDetallesEntity> insertOrdenWithItems(OrdenConDetallesEntity orden) async {
    final ordenModel = orden.toModel();
    final model = await _datasource.insertOrdenWithItems(ordenModel);
    final entity = model.toEntity();
    return entity;
  }

  @override
  Future<void> updateItemsOrden(OrdenConDetallesEntity orden) async {
    final ordenModel = orden.toModel();
    return await _datasource.updateItemsOrden(ordenModel);
  }

  @override
  Future<void> updateOrden(OrdenConDetallesEntity orden) async {
    final ordenModel = orden.toModel();
    return await _datasource.updateOrden(ordenModel);
  }
}
