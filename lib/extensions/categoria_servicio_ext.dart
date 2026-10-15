import 'package:drift/drift.dart';
import 'package:lavanderia/data/local/app_database.dart';
import 'package:lavanderia/types/estatus_type.dart';
import 'package:lavanderia/models/dto/categorias/categoria_servicio_model.dart';
import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';

extension CategoriaServicioEntityX on CategoriaServicioEntity {
  CategoriaServicioModel toModel() {
    return CategoriaServicioModel(
      id: id,
      nombre: nombre,
      estatus: estatus.value,
      diasEntrega: diasEntrega,
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
      diasEntrega: diasEntrega,
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
      diasEntrega: diasEntrega,
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
      diasEntrega: diasEntrega,
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
      diasEntrega: diasEntrega,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}
