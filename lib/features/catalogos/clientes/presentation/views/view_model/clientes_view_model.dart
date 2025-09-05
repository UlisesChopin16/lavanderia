import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/error/validate_exception.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

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
  final _createCase = instance<CreateCliente>();
  final _observeCase = instance<ObserveClientes>();
  final _updateCase = instance<UpdateCliente>();
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

        await _createCase.call(cliente);
        
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

        await _updateCase.call(entity);
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
    return _observeCase.call(state.filtros);
  }
}
