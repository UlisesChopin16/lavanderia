import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/data/models/categoria_servicio_model.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';

extension CategoriaServicioEntityX on CategoriaServicioEntity {
  CategoriaServicioModel toModel() {
    return CategoriaServicioModel(
      id: id,
      nombre: nombre,
      estatus: estatus.value,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      fechaEliminacion: fechaEliminacion,
    );
  }
}

extension CategoriaServicioModelX on CategoriaServicioModel {
  CategoriaServicioEntity toEntity() {
    return CategoriaServicioEntity(
      id: id,
      nombre: nombre,
      estatus: EstatusType.fromString(estatus),
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  CategoriaServicioEntry toEntry() {
    return CategoriaServicioEntry(
      id: id,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  CategoriaServicioCompanion toCompanion() {
    final now = DateTime.now();
    return CategoriaServicioCompanion.insert(
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
  }
}

extension CategoriaServicioEntryX on CategoriaServicioEntry {
  CategoriaServicioModel toModel() {
    return CategoriaServicioModel(
      id: id,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}
