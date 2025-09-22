import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/extensions/cliente_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_entry/orden_con_detalles_entry.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/orden_con_detalles_model/orden_con_detalles_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

import 'item_con_precio_ext.dart';
// import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_entry/precio_con_detalles_entry.dart';
// import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_model/precio_con_detalles_model.dart';
// import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
// import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';

extension OrdenConDetallesEntityX on OrdenConDetallesEntity {
  OrdenConDetallesModel toModel() {
    return OrdenConDetallesModel(
      id: id,
      folio: folio,
      cliente: cliente.toModel(),
      metodoPago: metodoPago?.value,
      descripcion: descripcion,
      adelantoPago: adelantoPago,
      total: total,
      restante: restante,
      estatus: estatus.value,
      fechaCierre: fechaCierre,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      items: items.map((e) => e.toModel()).toList(),
    );
  }
}

extension OrdenConDetallesModelX on OrdenConDetallesModel {
  OrdenConDetallesEntity toEntity() {
    return OrdenConDetallesEntity(
      id: id,
      folio: folio,
      cliente: cliente.toEntity(),
      metodoPago: (metodoPago == null || metodoPago!.isEmpty)
          ? null
          : MetodoPagoType.fromString(metodoPago!),
      descripcion: descripcion ?? '',
      adelantoPago: adelantoPago,
      total: total,
      restante: restante,
      estatus: EstatusOrdenType.fromString(estatus),
      fechaCierre: fechaCierre,
      fechaCreacion: fechaCreacion,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }

  OrdenServicioEntry toEntry() {
    return OrdenServicioEntry(
      id: id,
      clienteId: cliente.id,
      folio: folio,
      descripcion: descripcion,
      estatus: estatus,
      total: total,
      restante: restante,
      fechaCreacion: fechaCreacion,
      fechaCierre: fechaCierre,
    );
  }

  OrdenServicioCompanion toOrdenCompanion() {
    final now = DateTime.now();
    return OrdenServicioCompanion.insert(
      clienteId: cliente.id,
      folio: folio,
      descripcion: Value(descripcion),
      estatus: estatus,
      total: total,
      restante: restante,
      fechaCreacion: now,
      fechaCierre: Value(fechaCierre),
    );
  }

  OrdenHistoryCompanion toHistoryCompanion(int idOrden) {
    final now = DateTime.now();
    return OrdenHistoryCompanion.insert(
      ordenId: idOrden,
      monto: adelantoPago,
      metodoPago: metodoPago ?? '',
      fecha: now,
    );
  }
}

extension PreciosConceptosEntryX on OrdenConDetallesEntry {
  OrdenConDetallesModel toModel() {
    return OrdenConDetallesModel(
      id: orden.id,
      folio: orden.folio,
      cliente: cliente.toModel(),
      metodoPago: detalles.metodoPago,
      descripcion: orden.descripcion,
      adelantoPago: detalles.monto,
      total: orden.total,
      restante: orden.restante,
      estatus: orden.estatus,
      fechaCierre: orden.fechaCierre,
      fechaCreacion: orden.fechaCreacion,
      items: [],
    );
  }
}
