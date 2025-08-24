import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categorias/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
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
    @Default(FiltrosBase()) FiltrosBase filtros,
  }) = _CategoriaModel;
}

@riverpod
class CategoriaViewModel extends _$CategoriaViewModel {
  final _createCase = instance<CreateCategoriaServicio>();
  final _desactivateCase = instance<DesactivateCategoriaServicio>();
  final _observeCase = instance<ObserveCategoriasServicios>();
  final _updateCase = instance<UpdateCategoriaServicio>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  CategoriaModel build() {
    return const CategoriaModel();
  }

  void createCategoria(String nombre) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Categoría creada con éxito',
      ),
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final entity = CategoriaServicioEntity(
          nombre: nombre,
          estatus: EstatusType.activo,
        );
        await _createCase.call(entity);
      },
    );
  }

  void updateCategoria(CategoriaServicioEntity entity) {
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
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _updateCase.call(entity);
      },
    );
  }

  void desactivateCategoria(CategoriaServicioEntity entity) {
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
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _desactivateCase.call(entity.copyWith(estatus: EstatusType.inactivo));
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
    state = state.copyWith(filtros: const FiltrosBase());
  }

  void setSort(bool sort) {
    state = state.copyWith(filtros: state.filtros.copyWith(ascendente: sort));
  }

  void setOrden(ColumnNamesType orden) {
    state = state.copyWith(filtros: state.filtros.copyWith(ordenamiento: orden));
  }

  void setOrdenAndSort(ColumnNamesType orden, bool sort) {
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
