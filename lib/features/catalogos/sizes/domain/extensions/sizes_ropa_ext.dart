import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/data/models/sizes_ropa_model.dart';

extension SizeRopaEntityX on SizesRopaEntity {
  SizesRopaModel toModel() {
    return SizesRopaModel(
      id: id,
      nombre: nombre,
      estatus: estatus.value,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      fechaEliminacion: fechaEliminacion,
    );
  }
}

extension SizesRopaModelX on SizesRopaModel {
  SizesRopaEntity toEntity() {
    return SizesRopaEntity(
      id: id,
      nombre: nombre,
      estatus: EstatusType.fromString(estatus),
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  SizesRopaEntry toEntry() {
    return SizesRopaEntry(
      id: id,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  SizesRopaCompanion toCompanion() {
    final now = DateTime.now();
    return SizesRopaCompanion.insert(
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
  }
}

extension SizesRopaEntryX on SizesRopaEntry {
  SizesRopaModel toModel() {
    return SizesRopaModel(
      id: id,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}
