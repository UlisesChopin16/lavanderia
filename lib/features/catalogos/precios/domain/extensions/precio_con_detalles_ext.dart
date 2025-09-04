import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_entry/precio_con_detalles_entry.dart';
import 'package:lavanderia/features/catalogos/precios/data/models/precio_con_detalles_model/precio_con_detalles_model.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/extensions/sizes_ropa_ext.dart';

extension PrecioConDetallesEntityX on PrecioConDetallesEntity {
  PrecioConDetallesModel toModel() {
    return PrecioConDetallesModel(
      idPrecio: idPrecio,
      categoria: categoria.toModel(),
      size: size.toModel(),
      nombreConcepto: nombreConcepto,
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

extension PrecioConDetallesModelX on PrecioConDetallesModel {
  PrecioConDetallesEntity toEntity() {
    return PrecioConDetallesEntity(
      idPrecio: idPrecio,
      categoria: categoria.toEntity(),
      size: size.toEntity(),
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
      categoriaId: categoria.id,
      sizeRopaId: size.id,
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
      categoriaId: categoria.id,
      sizeRopaId: size.id,
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
      categoria: categoria.toModel(),
      size: size.toModel(),
      nombreConcepto: precio.nombreConcepto,
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
