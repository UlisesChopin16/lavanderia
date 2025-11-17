import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/item_con_precio_entry/item_con_precio_entry.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/item_con_precio_model/item_con_precio_model.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/extensions/precio_con_detalles_ext.dart';

extension ItemConPrecioEntityX on ItemConPrecioEntity {
  ItemConPrecioModel toModel() {
    return ItemConPrecioModel(
      id: id,
      ordenId: ordenId,
      precio: precio.toModel(),
      cantidad: cantidad,
      estaEntregado: estaEntregado,
      fechaEntrega: fechaEntrega ?? DateTime.now(),
      importe: importe,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaEntegado: fechaEntegado,
    );
  }
}

extension ItemConPrecioModelX on ItemConPrecioModel {
  ItemConPrecioEntity toEntity() {
    return ItemConPrecioEntity(
      id: id,
      ordenId: ordenId,
      precio: precio.toEntity(),
      cantidad: cantidad,
      estaEntregado: estaEntregado,
      fechaEntrega: fechaEntrega,
      importe: importe,
      fechaCreacion: fechaCreacion,
      fechaEntegado: fechaEntegado,
    );
  }

  ItemServicioOrdenEntry toEntry() {
    return ItemServicioOrdenEntry(
      id: id,
      ordenId: ordenId,
      cantidad: cantidad,
      precioConceptoId: precio.idPrecio,
      estaEntregado: estaEntregado,
      fechaEntrega: fechaEntrega,
      importe: importe,
      fechaCreacion: fechaCreacion,
      fechaEntegado: fechaEntegado,
    );
  }

  ItemServicioOrdenCompanion toCompanion(int idOrden) {
    final now = DateTime.now();
    return ItemServicioOrdenCompanion.insert(
      ordenId: idOrden,
      precioConceptoId: precio.idPrecio,
      cantidad: cantidad,
      estaEntregado: Value(estaEntregado),
      importe: importe,
      fechaEntrega: fechaEntrega,
      fechaCreacion: now,
      fechaEntegado: Value(fechaEntegado),
    );
  }
}

extension PreciosConceptosEntryX on ItemConPrecioEntry {
  ItemConPrecioModel toModel() {
    return ItemConPrecioModel(
      id: item.id,
      ordenId: item.ordenId,
      precio: precio.toModel(),
      cantidad: item.cantidad,
      importe: item.importe,
      estaEntregado: item.estaEntregado,
      fechaEntrega: item.fechaEntrega,
      fechaCreacion: item.fechaCreacion,
      fechaEntegado: item.fechaEntegado,
    );
  }
}
