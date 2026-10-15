import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/inject/injector.dart';
import 'package:lavanderia/exceptions/validate_exception.dart';
import 'package:lavanderia/extensions/safe_call_ext.dart';
import 'package:lavanderia/models/data/clientes/cliente_entity.dart';
import 'package:lavanderia/models/data/clientes/filtros_clientes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lavanderia/repository/clientes/clientes_read_repository.dart';
import 'package:lavanderia/repository/clientes/clientes_write_repository.dart';

part 'clientes_view_model.freezed.dart';
part 'clientes_view_model.g.dart';

@freezed
sealed class ClientesModel with _$ClientesModel {
  const factory ClientesModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(FiltrosClientes()) FiltrosClientes filtros,
  }) = _ClientesModel;
}

@riverpod
class ClientesViewModel extends _$ClientesViewModel {
  final _readRepository = instance<ClientesReadRepository>();
  final _writeRepository = instance<ClientesWriteRepository>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  ClientesModel build() {
    return const ClientesModel();
  }

  void createCliente({
    required ClienteEntity cliente,
    required VoidCallback onSuccess,
    required Future<bool?> Function() onConfirm,
  }) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        
      ),
      actionOnError: (error, message) async {
        state = state.copyWith(
          errorMessage: message,
          isLoading: false,
        );
      },
      action: () async {
        final valid = cliente.validate();
        if (valid.isNotEmpty) {
          throw ValidateException(message: 'Error con el Cliente:\n$valid');
        }

        final confirm = await onConfirm();

        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        await _writeRepository.createCliente(cliente);
        
        onSuccess();
        state = state.copyWith(
          successMessage: 'Cliente registrado con éxito',
        );
      },
    );
  }

  void updateCliente({
    required ClienteEntity entity,
    required VoidCallback onSuccess,
    required Future<bool?> Function() onConfirm,
  }) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final validate = entity.validate();
        if (validate.isNotEmpty) {
          throw ValidateException(message: 'Error con el Cliente:\n$validate');
        }

        final confirm = await onConfirm();
        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        await _writeRepository.updateCliente(entity);
        onSuccess();
        state = state.copyWith(
          successMessage: 'Cliente actualizado con éxito',
        );
      },
    );
  }

  void setNombre(String nombre) {
    state = state.copyWith(filtros: state.filtros.copyWith(nombre: nombre));
  }

  void clearFilters() {
    state = state.copyWith(filtros: const FiltrosClientes());
  }

  void setSort(bool sort) {
    state = state.copyWith(filtros: state.filtros.copyWith(ascendente: sort));
  }

  void setOrden(ColumnClientesName orden) {
    state = state.copyWith(filtros: state.filtros.copyWith(ordenamiento: orden));
  }

  void setOrdenAndSort(ColumnClientesName orden, bool sort) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        ordenamiento: orden,
        ascendente: sort,
      ),
    );
  }

  Stream<List<ClienteEntity>> observeClientes() {
    return _readRepository.watchAllClientes(state.filtros);
  }
}
