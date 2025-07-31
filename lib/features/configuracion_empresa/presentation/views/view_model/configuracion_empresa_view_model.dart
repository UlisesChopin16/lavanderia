import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configuracion_empresa_view_model.freezed.dart';
part 'configuracion_empresa_view_model.g.dart';

@freezed
sealed class ConfiguracionEModel with _$ConfiguracionEModel {
  const factory ConfiguracionEModel({
    @Default(false) bool isLoading,
    @Default(ConfiguracionEmpresaEntity()) ConfiguracionEmpresaEntity configuracionEmpresa,
  }) = _ConfiguracionEModel;
}

@riverpod
class ConfiguracionEmpresaViewModel extends _$ConfiguracionEmpresaViewModel {
  @override
  ConfiguracionEModel build() {
    return const ConfiguracionEModel();
  }

  void setNombre(String nombre) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        nombre: nombre,
      ),
    );
  }

  void setTelefono(String telefono) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        telefono: telefono,
      ),
    );
  }

  void setCorreo(String correo) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        correo: correo,
      ),
    );
  }

  void setPaginaWeb(String paginaWeb) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        paginaWeb: paginaWeb,
      ),
    );
  }

  void setColor(Color color) {
    final colorHex = '#${color.toARGB32()}';
    // final color = Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        color: colorHex,
      ),
    );
  }

  // void setLogo () {

  // }

}
