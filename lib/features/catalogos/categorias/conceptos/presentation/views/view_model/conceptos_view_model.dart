import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/entities/concepto_entity.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

part 'conceptos_view_model.freezed.dart';
part 'conceptos_view_model.g.dart';

@freezed
sealed class ConceptosModel with _$ConceptosModel {
  const factory ConceptosModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(CategoriaServicioEntity()) CategoriaServicioEntity categoria,
    @Default(FiltrosBase()) FiltrosBase filtros,
  }) = _ConceptosModel;
}

@riverpod
class ConceptosViewModel extends _$ConceptosViewModel {
  final _createCase = instance<CreateConceptoServicio>();
  final _desactivateCase = instance<DesactivateConcepto>();
  final _observeCase = instance<ObserveConceptos>();
  final _updateCase = instance<UpdateConcepto>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  ConceptosModel build() {
    return const ConceptosModel();
  }

  void init (CategoriaServicioEntity  categoria) => state = state.copyWith(categoria: categoria);

  void createConcepto(String nombre) {
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
        final entity = ConceptoEntity(
          nombre: nombre,
          estatus: EstatusType.activo,
          categoriaId: state.categoria.id,
        );
        await _createCase.call(entity);
      },
    );
  }

  void updateConcepto(ConceptoEntity entity) {
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

  void desactivateConcepto(ConceptoEntity entity) {
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

  Stream<List<ConceptoEntity>> observeConceptos(int idCategoria) {
    return _observeCase.call(
      idCategoria: idCategoria,
      filtros: state.filtros,
    );
  }
}
