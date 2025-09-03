import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/catalogos/clientes/data/models/cliente_model.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';

extension ClienteEntityX on ClienteEntity {
  ClienteModel toModel() {
    return ClienteModel(
      id: id,
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      telefono: telefono,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      fechaEliminacion: fechaEliminacion,
    );
  }
}

extension ClienteModelX on ClienteModel {
  ClienteEntity toEntity() {
    return ClienteEntity(
      id: id,
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      telefono: telefono,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  ClienteEntry toEntry() {
    return ClienteEntry(
      id: id,
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      telefono: telefono,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  ClienteCompanion toCompanion() {
    final now = DateTime.now();
    return ClienteCompanion.insert(
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      telefono: telefono,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: Value(fechaActualizacion ?? now),
    );
  }
}

extension ClienteEntryX on ClienteEntry {
  ClienteModel toModel() {
    return ClienteModel(
      id: id,
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      telefono: telefono,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}
