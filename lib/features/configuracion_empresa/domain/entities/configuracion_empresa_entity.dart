import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/configuracion_empresa/data/models/configuracion_empresa_model.dart';

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

  factory ConfiguracionEmpresaEntity.fromModel(
          ConfiguracionEmpresaModel config, DireccionModel direccion) =>
      ConfiguracionEmpresaEntity(
        id: config.id,
        nombre: config.nombre,
        telefono: config.telefono,
        correo: config.correo,
        paginaWeb: config.paginaWeb,
        logo: config.logo ?? '',
        color: config.color,
        password: config.password,
        direccion: DireccionEntity.fromModel(direccion),
        fechaCreacion: config.fechaCreacion,
        fechaActualizacion: config.fechaActualizacion,
        fechaEliminacion: config.fechaEliminacion,
      );
  // bool get isValid {
  //   return nombre.trim().isNotEmpty &&
  //       telefono.trim().isNotEmpty &&
  //       password.trim().isNotEmpty &&
  //       logo.trim().isNotEmpty &&
  //       direccion.calle.trim().isNotEmpty &&
  //       direccion.numeroExterior.trim().isNotEmpty &&
  //       direccion.colonia.trim().isNotEmpty &&
  //       direccion.codigoPostal > 0 &&
  //       direccion.ciudad.trim().isNotEmpty &&
  //       direccion.estado.trim().isNotEmpty;
  // }
  Color get colorParsed {
    Printer.e('Color: $color');
    if (color == 0) {
      const blue = Colors.blue;
      final argb = blue.toARGB32();
      // Printer.e('Color Parsed: $argb');
      final colorParsed = Color(argb);
      return colorParsed;
    }
    final colorParsed = Color(color);
    // Printer.e('Color Parsed: $colorParsed');

    return colorParsed;
  }
}

@freezed
sealed class DireccionEntity with _$DireccionEntity {
  const DireccionEntity._();
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
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _DireccionEntity;

  factory DireccionEntity.fromModel(DireccionModel direccion) => DireccionEntity(
        id: direccion.id,
        empresaId: direccion.empresaId,
        calle: direccion.calle,
        numeroExterior: direccion.numeroExterior,
        numeroInterior: direccion.numeroInterior ?? '',
        colonia: direccion.colonia,
        codigoPostal: direccion.codigoPostal,
        ciudad: direccion.ciudad,
        estado: direccion.estado,
        fechaCreacion: direccion.fechaCreacion,
        fechaActualizacion: direccion.fechaActualizacion,
        fechaEliminacion: direccion.fechaEliminacion,
      );
}
