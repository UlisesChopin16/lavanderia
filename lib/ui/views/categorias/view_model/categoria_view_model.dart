import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/inject/injector.dart';
import 'package:lavanderia/extensions/safe_call_ext.dart';
import 'package:lavanderia/models/data/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/models/data/categorias/filtros_categoria.dart';
import 'package:lavanderia/repository/categorias/categoria_servicio_read_repository.dart';
import 'package:lavanderia/repository/categorias/categoria_servicio_write_repository.dart';
import 'package:lavanderia/repository/precios/precios_change_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


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
  final _readRepository = instance<CategoriaServicioReadRepository>();
  final _writeRepository = instance<CategoriaServicioWriteRepository>();
  final _preciosChangeRepository = instance<PreciosChangeRepository>();
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

        await _writeRepository.createCategoriaServicio(categoria);
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
            await _preciosChangeRepository.changeDiasPreciosByCategoria(categoria);
          }
        }

        await _writeRepository.updateCategoriaServicio(categoria);
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
        await _writeRepository.deleteCategoriaServicio(entity.copyWith(estatus: EstatusType.inactivo));
        await _preciosChangeRepository.deactivatePreciosByCategoria(entity.id);
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
        await _writeRepository.updateCategoriaServicio(newEntity);

        await _preciosChangeRepository.activatePreciosByCategoria(newEntity.id);
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
    return _readRepository.watchAllCategoriasServicios(state.filtros);
  }
}
