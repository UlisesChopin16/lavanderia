import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/configuracion_empresa/data/models/configuracion_empresa_model.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';

extension ConfiguracionEmpresaX on ConfiguracionEmpresaModel {
  ConfiguracionEmpresaCompanion toCompanion() {
    final now = DateTime.now();
    return ConfiguracionEmpresaCompanion.insert(
      nombre: nombre,
      telefono: telefono,
      correo: correo,
      paginaWeb: paginaWeb,
      logo: Value(logo),
      color: color,
      password: password,
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
  }
  ConfiguracionEmpresaEntry toEntry() {
    return ConfiguracionEmpresaEntry(
      id: id,
      nombre: nombre,
      telefono: telefono,
      correo: correo,
      paginaWeb: paginaWeb,
      logo: logo,
      color: color,
      password: password,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  ConfiguracionEmpresaEntity toEntity(DireccionModel direccion) {
    return ConfiguracionEmpresaEntity.fromModel(this, direccion);
  }
}

extension ConfiguracionEmpresaEntryX on ConfiguracionEmpresaEntry {
  ConfiguracionEmpresaModel toModel() {
    return ConfiguracionEmpresaModel.fromEntry(this);
  }
}

extension ConfiguracionEmpresaEntityX on ConfiguracionEmpresaEntity {
  ConfiguracionEmpresaModel toModel() {
    return ConfiguracionEmpresaModel(
      id: id,
      nombre: nombre,
      telefono: telefono,
      correo: correo,
      paginaWeb: paginaWeb,
      logo: logo,
      color: color,
      password: password,
      fechaCreacion: fechaCreacion ?? DateTime.now(),
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }

  DireccionModel toModelDireccion() {
    return DireccionModel(
      id: direccion.id,
      empresaId: direccion.empresaId,
      calle: direccion.calle,
      numeroExterior: direccion.numeroExterior,
      numeroInterior: direccion.numeroInterior,
      colonia: direccion.colonia,
      codigoPostal: direccion.codigoPostal,
      ciudad: direccion.ciudad,
      estado: direccion.estado,
      fechaCreacion: direccion.fechaCreacion ?? DateTime.now(),
      fechaActualizacion: direccion.fechaActualizacion,
      fechaEliminacion: direccion.fechaEliminacion,
    );
  }
}

extension DireccionModelX on DireccionModel {
  DireccionCompanion toCompanion() {
    final now = DateTime.now();
    return DireccionCompanion.insert(
      empresaId: empresaId,
      calle: calle,
      numeroExterior: numeroExterior,
      numeroInterior: Value(numeroInterior),
      colonia: colonia,
      codigoPostal: codigoPostal,
      ciudad: ciudad,
      estado: estado,
      fechaCreacion: now,
      fechaActualizacion: Value(now),
    );
  }
  DireccionEntry toEntry() {
    return DireccionEntry(
      id: id,
      empresaId: empresaId,
      calle: calle,
      numeroExterior: numeroExterior,
      numeroInterior: numeroInterior,
      colonia: colonia,
      codigoPostal: codigoPostal,
      ciudad: ciudad,
      estado: estado,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      fechaEliminacion: fechaEliminacion,
    );
  }
}