import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/files_system.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/repositories/configuracion_empresa_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configuracion_empresa_view_model.freezed.dart';
part 'configuracion_empresa_view_model.g.dart';

@freezed
sealed class ConfiguracionEModel with _$ConfiguracionEModel {
  const ConfiguracionEModel._();
  const factory ConfiguracionEModel({
    @Default(false) bool isLoading,
    @Default(false) bool visiblePassword,
    @Default(false) bool blockUI,
    @Default(true) bool isFirstTime,
    @Default('') String errorMessage,
    @Default(ConfiguracionEmpresaEntity()) ConfiguracionEmpresaEntity configuracionEmpresa,
  }) = _ConfiguracionEModel;

  DireccionEntity get direccion => configuracionEmpresa.direccion;
}

@riverpod
class ConfiguracionEmpresaViewModel extends _$ConfiguracionEmpresaViewModel {
  final _configuracionEmpresaRepo = instance<ConfiguracionEmpresaRepository>();

  @override
  ConfiguracionEModel build() {
    return const ConfiguracionEModel();
  }

  void initialize() => safeCall(
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
      final result = await _configuracionEmpresaRepo.getConfiguracionEmpresaById(1);
      // result == null ? state = state.copyWith(isFirstTime: true) : state = state.copyWith(isFirstTime: false, configuracionEmpresa: result);
      if (result == null) {
        state = state.copyWith(isFirstTime: true);
      } else {
        state = state.copyWith(
          isFirstTime: false,
          blockUI: true,
          configuracionEmpresa: result,
        );
      }
    },
  );

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
    final colorHex = color.toARGB32();
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
        final fileBytes = await file.xFile.readAsBytes();
        final path = await FilesSystem.writeFile(
          bytes: fileBytes,
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

  void setPassword(String password) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        password: password,
      ),
    );
  }

  void toggleVisiblePassword() {
    if (state.blockUI) return;
    state = state.copyWith(
      visiblePassword: !state.visiblePassword,
    );
  }

  void setDireccion(DireccionEntity direccion) {
    state = state.copyWith(
      configuracionEmpresa: state.configuracionEmpresa.copyWith(
        direccion: direccion,
      ),
    );
  }

  String validateAll() {
    final entity = state.configuracionEmpresa;
    if (entity.nombre.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (entity.telefono.trim().isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (entity.password.trim().isEmpty) {
      return 'La contraseña es obligatoria';
    }
    // if (entity.logo.trim().isEmpty) {
    //   return 'El logo es obligatorio';
    // }
    final direccion = entity.direccion;
    if (direccion.calle.trim().isEmpty) {
      return 'La calle es obligatoria';
    }
    if (direccion.numeroExterior.trim().isEmpty) {
      return 'El número exterior es obligatorio';
    }
    if (direccion.colonia.trim().isEmpty) {
      return 'La colonia es obligatoria';
    }
    if (direccion.codigoPostal <= 0) {
      return 'El código postal es obligatorio';
    }
    if (direccion.ciudad.trim().isEmpty) {
      return 'La ciudad es obligatoria';
    }
    if (direccion.estado.trim().isEmpty) {
      return 'El estado es obligatorio';
    }
    return '';
  }

  void saveConfiguracionEmpresa({
    VoidCallback? onSuccess,
  }) async => await safeCall(
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
      final isFirstTime = state.isFirstTime;
      final message = validateAll();
      if (message.isNotEmpty) {
        state = state.copyWith(errorMessage: message);
        return;
      }

      // Save the configuration
      if (isFirstTime) {
        // Call the save method for the first time
        await _configuracionEmpresaRepo.createConfiguracionEmpresa(state.configuracionEmpresa);
        state = state.copyWith(visiblePassword: false, isFirstTime: false);
      } else {
        // Call the edit method for subsequent saves
        await _configuracionEmpresaRepo.updateConfiguracionEmpresa(state.configuracionEmpresa);
      }

      onSuccess?.call();

      // final result = await _configuracionEmpresaRepo.saveConfiguracionEmpresa(state.configuracionEmpresa);
      // result.fold(
      //   (failure) => throw Exception(failure.message),
      //   (data) {
      //     state = state.copyWith(
      //       isFirstTime: false,
      //       configuracionEmpresa: data,
      //     );
      //   },
      // );
    },
  );

  void setBlockUI(bool blockUI) {
    state = state.copyWith(blockUI: blockUI, visiblePassword: !blockUI);
  }

  bool verifyPassword(String password) {
    state = state.copyWith(
      errorMessage: '',
    );
    final isValid = state.configuracionEmpresa.password == password;
    if (!isValid) {
      state = state.copyWith(errorMessage: 'Contraseña incorrecta');
      return false;
    }

    return true;
  }
}
