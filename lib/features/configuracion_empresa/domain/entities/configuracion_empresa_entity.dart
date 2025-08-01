import 'package:freezed_annotation/freezed_annotation.dart';

part 'configuracion_empresa_entity.freezed.dart';


@freezed
sealed class ConfiguracionEmpresaEntity with _$ConfiguracionEmpresaEntity {
  const factory ConfiguracionEmpresaEntity({
    @Default(-1) int id,
    @Default('') String nombre,
    @Default(DireccionEntity()) DireccionEntity direccion,
    @Default('') String telefono,
    @Default('') String correo,
    @Default('') String paginaWeb,
    @Default('') String logo,
    @Default('') String color,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ConfiguracionEmpresaEntity;
}

@freezed
sealed class DireccionEntity with _$DireccionEntity {
  const factory DireccionEntity({
    @Default(-1) int id,
    @Default(-1) int empresaId,
    @Default('') String calle,
    @Default('') String numeroExterior,
    @Default('') String numeroInterior,
    @Default('') String colonia,
    @Default(-1) int codigoPostal,
    @Default('') String ciudad,
    @Default('') String estado,
  }) = _DireccionEntity;
}
