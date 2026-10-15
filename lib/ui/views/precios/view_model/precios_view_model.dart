import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/inject/injector.dart';
import 'package:lavanderia/exceptions/validate_exception.dart';
import 'package:lavanderia/types/clothe_size_type.dart';
import 'package:lavanderia/services/printer.dart';
import 'package:lavanderia/extensions/safe_call_ext.dart';
import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/repository/categorias/categoria_servicio_read_repository.dart';
import 'package:lavanderia/models/data/precios/filtros_precios.dart';
import 'package:lavanderia/models/data/precios/precio_con_detalles_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lavanderia/repository/precios/precios_read_repository.dart';
import 'package:lavanderia/repository/precios/precios_write_repository.dart';

part 'precios_view_model.freezed.dart';
part 'precios_view_model.g.dart';

@freezed
sealed class PreciosModel with _$PreciosModel {
  const factory PreciosModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(null) CategoriaServicioEntity? categoria,
    @Default([]) List<CategoriaServicioEntity> categorias,
    @Default(FiltrosPrecios()) FiltrosPrecios filtros,
  }) = _PreciosModel;
}

@riverpod
class PreciosViewModel extends _$PreciosViewModel {
  final _readRepository = instance<PreciosReadRepository>();
  final _writeRepository = instance<PreciosWriteRepository>();
  final _categoriasReadRepository = instance<CategoriaServicioReadRepository>();

  @override
  PreciosModel build() {
    return const PreciosModel();
  }

  void init(CategoriaServicioEntity? categoria) {
    state = state.copyWith(
      categoria: categoria,
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
        final categorias = await _categoriasReadRepository.getAllCategoriasServicios();
        state = state.copyWith(categorias: categorias);
      },
    );
  }

  void createPrecio({
    required PrecioConDetallesEntity precio,
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
        final nuevoPrecio = applyCategoriaOrSize(precio);

        await _writeRepository.rowExists(nuevoPrecio);

        final confirm = await onConfirm();

        if (confirm != true) {
          state = state.copyWith(isLoading: false);
          return;
        }

        await _writeRepository.insertPrecio(precio: nuevoPrecio);
        onSuccess();
        state = state.copyWith(
          successMessage: 'Concepto creado con éxito',
        );
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

        await _writeRepository.updatePrecio(precio: entity);
        onSuccess();
          state = state.copyWith(
            successMessage: 'Concepto actualizado con éxito',
          );
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
        await _writeRepository.deletePrecio(precio: entity.copyWith(estatus: EstatusType.inactivo));
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
        await _writeRepository.updatePrecio(
          precio: entity.copyWith(
            estatus: EstatusType.activo,
            fechaEliminacion: null,
          ),
        );
      },
    );
  }

  void clearAll() {
    state = state.copyWith(
      filtros: const FiltrosPrecios(),
      categoria: null,
      errorMessage: '',
      successMessage: '',
      isLoading: false,
    );
  }

  PrecioConDetallesEntity applyCategoriaOrSize(PrecioConDetallesEntity precio) {
    PrecioConDetallesEntity precioModificado = precio;

    final categoria = state.categoria;

    if (categoria != null) {
      precioModificado = precio.copyWith(categoria: categoria);
    }

    final validate = precioModificado.validate();

    if (validate.isNotEmpty) {
      throw ValidateException(message: 'Error en el Concepto:\n$validate');
    }

    return precioModificado;
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

  void setCategoria(CategoriaServicioEntity categoria) {
    state = state.copyWith(filtros: state.filtros.copyWith(categoria: categoria));
  }

  void setSizeRopa(ClotheSizeType? clotheSize) {
    state = state.copyWith(filtros: state.filtros.copyWith(clotheSize: clotheSize));
  }

  void setOrdenAndSort(ColumnPreciosName orden, bool sort) {
    Printer.i("filtros antes: ${state.filtros}");
    state = state.copyWith(
      filtros: state.filtros.copyWith(
        ordenamiento: orden,
        ascendente: sort,
      ),
    );
    Printer.i("filtros despues: ${state.filtros}");
  }

  Stream<List<PrecioConDetallesEntity>> observePrecios() {
    if (state.categoria != null) {
      return _readRepository.watchAllByCategoria(
        categoriaId: state.categoria!.id,
        filtros: state.filtros,
      );
    }

    return _readRepository.watchAll(filtros: state.filtros);
  }
}
