import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/printer.dart';

part 'configuracion_empresa_entity.freezed.dart';

@freezed
sealed class ConfiguracionEmpresaEntity with _$ConfiguracionEmpresaEntity {
  const ConfiguracionEmpresaEntity._();
  const factory ConfiguracionEmpresaEntity({
    @Default(-1) int id,
    @Default(0) int color,
    @Default('') String password,
    @Default('') String nombre,
    @Default('') String telefono,
    @Default('') String correo,
    @Default('') String paginaWeb,
    @Default('') String logo,
    @Default(DireccionEntity()) DireccionEntity direccion,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ConfiguracionEmpresaEntity;

  Color get colorParsed {
    if (color == 0) {
      const blue = Colors.blue;
      final argb = blue.toARGB32();
      final colorParsed = Color(argb);
      return colorParsed;
    }
    final colorParsed = Color(color);
    Printer.e('Color Parsed: $colorParsed');

    return colorParsed;
  }
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
