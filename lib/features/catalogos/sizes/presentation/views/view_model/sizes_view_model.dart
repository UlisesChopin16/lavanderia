import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

part 'sizes_view_model.freezed.dart';
part 'sizes_view_model.g.dart';

@freezed
sealed class SizesModel with _$SizesModel {
  const factory SizesModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(FiltrosBase()) FiltrosBase filtros,
  }) = _SizesModel;
}

@riverpod
class SizesViewModel extends _$SizesViewModel {
  final _createCase = instance<CreateSizeRopa>();
  final _desactivateCase = instance<DesactivateSizeRopa>();
  final _observeCase = instance<ObserveSizesRopa>();
  final _updateCase = instance<UpdateSizeRopa>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  SizesModel build() {
    return const SizesModel();
  }

  void createSize(String nombre) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state = state.copyWith(
        isLoading: false,
        successMessage: 'Tamaño de ropa creado con éxito',
      ),
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final entity = SizesRopaEntity(
          nombre: nombre,
          estatus: EstatusType.activo,
        );
        await _createCase.call(entity);
      },
    );
  }

  void updateSize(SizesRopaEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state =
          state.copyWith(isLoading: false, successMessage: 'Tamaño de ropa actualizado con éxito'),
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        await _updateCase.call(entity);
      },
    );
  }

  void desactivateSize(SizesRopaEntity entity) {
    safeCall(
      actionBefore: () async => state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      ),
      actionAfter: () async => state =
          state.copyWith(isLoading: false, successMessage: 'Tamaño de ropa desactivado con éxito'),
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

  Stream<List<SizesRopaEntity>> observeSizes() {
    return _observeCase.call(state.filtros);
  }
}
