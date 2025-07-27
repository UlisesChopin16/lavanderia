import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/app_database.dart';

part 'configuracion_empresa_model.freezed.dart';
part 'configuracion_empresa_model.g.dart';

@freezed
sealed class ConfiguracionEmpresaModel with _$ConfiguracionEmpresaModel {
  const factory ConfiguracionEmpresaModel({
    required int id,
    required String nombre,
    required String direccion,
    required String telefono,
    required String correo,
    required String paginaWeb,
    String? logo,
    required String color,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ConfiguracionEmpresaModel;

  factory ConfiguracionEmpresaModel.fromEntry(
    ConfiguracionEmpresaEntry entry,
  ) => ConfiguracionEmpresaModel(
    id: entry.id,
    nombre: entry.nombre,
    direccion: entry.direccion,
    telefono: entry.telefono,
    correo: entry.correo,
    paginaWeb: entry.paginaWeb,
    logo: entry.logo,
    color: entry.color,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );

  factory ConfiguracionEmpresaModel.fromJson(Map<String, dynamic> json) =>
      _$ConfiguracionEmpresaModelFromJson(json);
}

@freezed
sealed class DireccionModel with _$DireccionModel {
  const factory DireccionModel({
    required int id,
    required int empresaId,
    required String calle,
    required String numeroExterior,
    String? numeroInterior,
    required String colonia,
    required String codigoPostal,
    required String ciudad,
    required String estado,
  }) = _DireccionModel;

  factory DireccionModel.fromEntry(DireccionEntry entry) => DireccionModel(
    id: entry.id,
    empresaId: entry.empresaId,
    calle: entry.calle,
    numeroExterior: entry.numeroExterior,
    numeroInterior: entry.numeroInterior,
    colonia: entry.colonia,
    codigoPostal: entry.codigoPostal,
    ciudad: entry.ciudad,
    estado: entry.estado,
  );

  factory DireccionModel.fromJson(Map<String, dynamic> json) =>
      _$DireccionModelFromJson(json);
}
