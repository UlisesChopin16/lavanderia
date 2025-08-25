import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/data/models/concepto_model.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';

extension ConceptoEntityX on ConceptoEntity {
  ConceptoModel toModel() {
    return ConceptoModel(
      id: id,
      categoriaId: categoriaId,
      nombre: nombre,
      estatus: estatus.value,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      fechaEliminacion: fechaEliminacion,
    );
  }
}

extension ConceptoModelX on ConceptoModel {
  ConceptoEntity toEntity() {
    return ConceptoEntity(
      id: id,
      categoriaId: categoriaId,
      nombre: nombre,
      estatus: EstatusType.fromString(estatus),
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  ItemServicioEntry toEntry() {
    return ItemServicioEntry(
      id: id,
      categoriaId: categoriaId,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  ItemServicioCompanion toCompanion() {
    final now = DateTime.now();
    return ItemServicioCompanion.insert(
      categoriaId: categoriaId,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
  }
}

extension ConceptoEntryX on ItemServicioEntry {
  ConceptoModel toModel() {
    return ConceptoModel(
      id: id,
      categoriaId: categoriaId,
      nombre: nombre,
      estatus: estatus,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}
