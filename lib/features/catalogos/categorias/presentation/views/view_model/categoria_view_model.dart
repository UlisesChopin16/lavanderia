import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/filtros/filtros_categoria.dart';
import 'package:lavanderia/features/catalogos/precios/domain/usecases/change_precios_status_by_categoria.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

part 'categoria_view_model.freezed.dart';
part 'categoria_view_model.g.dart';

@freezed
sealed class CategoriaModel with _$CategoriaModel {
  const factory CategoriaModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(FiltrosCategoria()) FiltrosCategoria filtros,
  }) = _CategoriaModel;
}

@riverpod
class CategoriaViewModel extends _$CategoriaViewModel {
  final _createCase = instance<CreateCategoriaServicio>();
  final _desactivateCase = instance<DesactivateCategoriaServicio>();
  final _observeCase = instance<ObserveCategoriasServicios>();
  final _updateCase = instance<UpdateCategoriaServicio>();
  final _changeEstatusPrecio = instance<ChangePreciosStatusByCategoria>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  CategoriaModel build() {
    return const CategoriaModel();
  }

  void createCategoria({
    required CategoriaServicioEntity categoria,
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
        categoria.validate();

        final confirm = await onConfirm();
        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        await _createCase.call(categoria);
        onSuccess();
        state = state.copyWith(
          successMessage: 'Categoría creada con éxito',
        );
      },
    );
  }

  void updateCategoria({
    required CategoriaServicioEntity categoriaBefore,
    required CategoriaServicioEntity categoria,
    required VoidCallback onSuccess,
    required Future<bool?> Function() onConfirm,
    required Future<bool?> Function() onConfirmUpdatePrecios,
  }) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Categoría actualizada con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        categoria.validate();

        final confirm = await onConfirm();
        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        if (categoriaBefore.diasEntrega != categoria.diasEntrega) {
          final confirmUpdatePrecios = await onConfirmUpdatePrecios();
          if (confirmUpdatePrecios == true) {
            await _changeEstatusPrecio.changeDiasPrecios(categoria);
          }
        }

        await _updateCase.call(categoria);
        onSuccess();
        state = state.copyWith(
          successMessage: 'Categoría actualizada con éxito',
        );
      },
    );
  }

  void deactivateCategoria(CategoriaServicioEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Categoría desactivada con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _desactivateCase.call(entity.copyWith(estatus: EstatusType.inactivo));
        await _changeEstatusPrecio.deactivatePrecios(entity.id);
      },
    );
  }

  void activateCategoria(CategoriaServicioEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Tamaño de ropa activado con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final newEntity = entity.copyWith(
          estatus: EstatusType.activo,
          fechaEliminacion: null,
        );
        await _updateCase.call(newEntity);

        await _changeEstatusPrecio.activatePrecios(newEntity.id);
      },
    );
  }

  void setNombre(String nombre) {
    state = state.copyWith(filtros: state.filtros.copyWith(nombre: nombre));
  }

  void setEstatus(EstatusType estatus) {
    state = state.copyWith(filtros: state.filtros.copyWith(estatus: estatus));
  }

  void clearFilters() {
    state = state.copyWith(filtros: const FiltrosCategoria());
  }

  void setSort(bool sort) {
    state = state.copyWith(filtros: state.filtros.copyWith(ascendente: sort));
  }

  void setOrden(ColumnsCategoriaType orden) {
    state = state.copyWith(filtros: state.filtros.copyWith(ordenamiento: orden));
  }

  void setOrdenAndSort(ColumnsCategoriaType orden, bool sort) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        ordenamiento: orden,
        ascendente: sort,
      ),
    );
  }

  Stream<List<CategoriaServicioEntity>> observeCategorias() {
    return _observeCase.call(state.filtros);
  }
}
