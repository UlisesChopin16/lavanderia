import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/utils/files_system.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configuracion_empresa_view_model.freezed.dart';
part 'configuracion_empresa_view_model.g.dart';

@freezed
sealed class ConfiguracionEModel with _$ConfiguracionEModel {
  const factory ConfiguracionEModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
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

  void setLogo() async => await safeCall(
        actionBefore: () async => state = state.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        actionAfter: () async => state = state.copyWith(
          isLoading: false,
          errorMessage: '',
        ),
        actionOnError: (error, message) async => state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
        action: () async {
          // Obtain only images files for the logo
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['jpg', 'jpeg', 'png'],
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            final fileBytes = file.bytes;
            final path = await FilesSystem.writeFile(
              bytes: fileBytes!,
              extension: file.extension!,
              pathBefore: state.configuracionEmpresa.logo,
            );

            state = state.copyWith(
              configuracionEmpresa: state.configuracionEmpresa.copyWith(
                logo: path,
              ),
            );
          }
        },
      );
}
