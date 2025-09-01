import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/error/validate_exception.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/usecases/obtain_all_categorias_servicios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/usecases/obtain_all_sizes_ropa.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

part 'precios_view_model.freezed.dart';
part 'precios_view_model.g.dart';

@freezed
sealed class PreciosModel with _$PreciosModel {
  const factory PreciosModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(null) CategoriaServicioEntity? categoria,
    @Default(null) SizesRopaEntity? sizeRopa,
    @Default([]) List<CategoriaServicioEntity> categorias,
    @Default([]) List<SizesRopaEntity> sizesRopa,
    @Default(FiltrosPrecios()) FiltrosPrecios filtros,
  }) = _PreciosModel;
}

@riverpod
class PreciosViewModel extends _$PreciosViewModel {
  final _createCase = instance<CreatePrecio>();
  final _desactivateCase = instance<DesactivatePrecio>();
  final _updateCase = instance<UpdatePrecio>();
  final _observeCase = instance<ObservePrecios>();
  final _observeBySizeCase = instance<ObservePreciosBySize>();
  final _observeByCategoriaCase = instance<ObservePreciosByCategoria>();
  final _verifyExistCase = instance<VerifyPrecioExist>();
  final _obtainCategoriasCase = instance<ObtainAllCategoriasServicios>();
  final _obtainSizesCase = instance<ObtainAllSizesRopa>();

  @override
  PreciosModel build() {
    return const PreciosModel();
  }

  void init(CategoriaServicioEntity? categoria, SizesRopaEntity? sizeRopa) {
    state = state.copyWith(
      categoria: categoria,
      sizeRopa: sizeRopa,
    );
  }

  Future<void> getCategorias() async {
    await safeCall(
      actionBefore: () async => state = state.copyWith(
        errorMessage: '',
        successMessage: '',
        isLoading: true,
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final categorias = await _obtainCategoriasCase.call();
        state = state.copyWith(categorias: categorias);
      },
    );
  }

  Future<void> getSizesRopa() async {
    await safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final sizesRopa = await _obtainSizesCase.call();
        state = state.copyWith(sizesRopa: sizesRopa);
      },
    );
  }

  void createPrecios({
    required List<PrecioConDetallesEntity> precios,
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
        successMessage: 'Conceptos creados con éxito',
      ),
      actionOnError: (error, message) async {
        state = state.copyWith(
          errorMessage: message,
          isLoading: false,
        );
      },
      action: () async {
        final nuevosPrecios = applyCategoriaOrSize(precios);
        validatePrecios(nuevosPrecios);

        for (final precio in nuevosPrecios) {
          await _verifyExistCase.call(precio);
        }

        final confirm = await onConfirm();

        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        for (final precio in nuevosPrecios) {
          await _createCase.call(precio);
        }

        onSuccess();
      },
    );
  }

  void updatePrecio({
    required PrecioConDetallesEntity entity,
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
        successMessage: 'Concepto actualizado con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final validate = entity.validate();
        if (validate.isNotEmpty) {
          throw ValidateException(message: 'Error en el Concepto:\n$validate');
        }

        final confirm = await onConfirm();
        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        await _updateCase.call(entity);
        onSuccess();
      },
    );
  }

  void desactivatePrecio(PrecioConDetallesEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Concepto desactivado con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _desactivateCase.call(entity.copyWith(estatus: EstatusType.inactivo));
      },
    );
  }

  void activatePrecio(PrecioConDetallesEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Concepto activado con éxito',
      ),
      actionOnError: (error, message) async => state = state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _updateCase.call(
          entity.copyWith(
            estatus: EstatusType.activo,
            fechaEliminacion: null,
          ),
        );
      },
    );
  }

  void validatePrecios(List<PrecioConDetallesEntity> precios) {
    final mapPrecios = <String, PrecioConDetallesEntity>{};
    for (int i = 0; i < precios.length; i++) {
      final precio = precios[i];
      final key = precio.key;
      final index = i + 1;
      final indexMessage = 'Error en el Concepto #$index:';
      final messageValidate = precio.validate();
      if (messageValidate.isNotEmpty) {
        throw ValidateException(message: '$indexMessage\n$messageValidate');
      }

      if (mapPrecios.containsKey(key)) {
        final message = '$indexMessage\n - ${precio.errorMessage}';
        throw ValidateException(message: message);
      }
      mapPrecios[key] = precio;
    }
  }

  void clearAll() {
    state = state.copyWith(
      filtros: const FiltrosPrecios(),
      categoria: null,
      sizeRopa: null,
      errorMessage: '',
      successMessage: '',
      isLoading: false,
    );
  }

  List<PrecioConDetallesEntity> applyCategoriaOrSize(List<PrecioConDetallesEntity> precios) {
    List<PrecioConDetallesEntity> nuevosPrecios = List.from(precios);
    final categoria = state.categoria;
    final size = state.sizeRopa;

    if (categoria != null) {
      nuevosPrecios = nuevosPrecios.map((p) => p.copyWith(categoria: categoria)).toList();
    }

    if (size != null) {
      nuevosPrecios = nuevosPrecios.map((p) => p.copyWith(size: size)).toList();
    }

    return nuevosPrecios;
  }

  void setNombre(String nombre) {
    state = state.copyWith(filtros: state.filtros.copyWith(nombre: nombre));
  }

  void setEstatus(EstatusType estatus) {
    state = state.copyWith(filtros: state.filtros.copyWith(estatus: estatus));
  }

  void clearFilters() {
    state = state.copyWith(filtros: const FiltrosPrecios());
  }

  void setSort(bool sort) {
    state = state.copyWith(filtros: state.filtros.copyWith(ascendente: sort));
  }

  void setOrden(ColumnPreciosName orden) {
    state = state.copyWith(filtros: state.filtros.copyWith(ordenamiento: orden));
  }

  void setOrdenAndSort(ColumnPreciosName orden, bool sort) {
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        ordenamiento: orden,
        ascendente: sort,
      ),
    );
  }

  Stream<List<PrecioConDetallesEntity>> observePrecios() {
    if (state.categoria != null) {
      return _observeByCategoriaCase.call(
        categoriaId: state.categoria!.id,
        filtros: state.filtros,
      );
    }

    if (state.sizeRopa != null) {
      return _observeBySizeCase.call(
        sizeId: state.sizeRopa!.id,
        filtros: state.filtros,
      );
    }

    return _observeCase.call(filtros: state.filtros);
  }
}
