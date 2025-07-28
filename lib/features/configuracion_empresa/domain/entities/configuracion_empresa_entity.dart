import 'package:freezed_annotation/freezed_annotation.dart';

part 'configuracion_empresa_entity.freezed.dart';


@freezed
sealed class ConfiguracionEmpresaEntity with _$ConfiguracionEmpresaEntity {
  const factory ConfiguracionEmpresaEntity({
    required String id,
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
  }) = _ConfiguracionEmpresaEntity;
}

@freezed
sealed class DireccionEntity with _$DireccionEntity {
  const factory DireccionEntity({
    required String id,
    required String empresaId,
    required String calle,
    required String numeroExterior,
    String? numeroInterior,
    required String colonia,
    required String codigoPostal,
    required String ciudad,
    required String estado,
  }) = _DireccionEntity;
}
