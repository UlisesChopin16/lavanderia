import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_entry/precio_con_detalles_entry.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_model/precio_con_detalles_model.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

extension PrecioConDetallesEntityX on PrecioConDetallesEntity {
  PrecioConDetallesModel toModel() {
    return PrecioConDetallesModel(
      idPrecio: idPrecio,
      idCategoria: idCategoria,
      idSize: idSize,
      nombreConcepto: nombreConcepto,
      nombreCategoria: nombreCategoria,
      nombreSize: nombreSize,
      diasEntrega: diasEntrega,
      tipoUnidad: tipoUnidad.value,
      importe: importe,
      estatus: estatus.value,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      fechaEliminacion: fechaEliminacion,
    );
  }
}

extension SizesRopaModelX on PrecioConDetallesModel {
  PrecioConDetallesEntity toEntity() {
    return PrecioConDetallesEntity(
      idPrecio: idPrecio,
      idCategoria: idCategoria,
      idSize: idSize,
      nombreConcepto: nombreConcepto,
      diasEntrega: diasEntrega,
      tipoUnidad: UnitType.fromString(tipoUnidad),
      importe: importe,
      estatus: EstatusType.fromString(estatus),
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  PreciosConceptosEntry toEntry() {
    return PreciosConceptosEntry(
      id: idPrecio,
      categoriaId: idCategoria,
      sizeRopaId: idSize,
      nombreConcepto: nombreConcepto,
      diasEntrega: diasEntrega,
      tipoUnidad: tipoUnidad,
      importe: importe,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  PreciosConceptosCompanion toCompanion() {
    final now = DateTime.now();
    return PreciosConceptosCompanion.insert(
      categoriaId: idCategoria,
      sizeRopaId: idSize,
      nombreConcepto: nombreConcepto,
      diasEntrega: diasEntrega,
      tipoUnidad: tipoUnidad,
      importe: importe,
      estatus: estatus,
      fechaCreacion: now,
      fechaActualizacion: Value(now)
    );
  }
}

extension PreciosConceptosEntryX on PrecioConDetallesEntry {
  PrecioConDetallesModel toModel() {
    return PrecioConDetallesModel(
      idPrecio: precio.id,
      idCategoria: precio.categoriaId,
      idSize: precio.sizeRopaId,
      nombreConcepto: precio.nombreConcepto,
      nombreCategoria: categoria.nombre,
      nombreSize: size.nombre,
      diasEntrega: precio.diasEntrega,
      tipoUnidad: precio.tipoUnidad,
      importe: precio.importe,
      estatus: precio.estatus,
      fechaCreacion: precio.fechaCreacion,
      fechaActualizacion: precio.fechaActualizacion,
      fechaEliminacion: precio.fechaEliminacion,
    );
  }
}
