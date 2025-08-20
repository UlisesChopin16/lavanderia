import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/core/utils/safe_call_ext.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/size_ropa_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/usecases.dart';

part 'sizes_view_model.freezed.dart';
part 'sizes_view_model.g.dart';

@freezed
sealed class SizesModel with _$SizesModel {
  const factory SizesModel({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
  }) = _SizesModel;
}

@riverpod
class SizesViewModel extends _$SizesViewModel {
  final _createCase = instance<CreateSizeRopa>();
  // final _desactivateCase = instance<DesactivateSizeRopa>();
  final _observeCase = instance<ObserveSizesRopa>();
  // final _updateCase = instance<UpdateSizeRopa>();
  // final _obtainCase = instance<ObtainAllSizesRopa>();
  // 92590007

  @override
  SizesModel build() {
    return const SizesModel();
  }

  void createSize(String nombre) {
    safeCall(
      actionBefore: () async => state = state.copyWith(isLoading: true),
      actionAfter: () async => state = state.copyWith(isLoading: false),
      actionOnError: (error, message) async => state.copyWith(
        errorMessage: message,
        isLoading: false,
      ),
      action: () async {
        final entity = SizesRopaEntity(nombre: nombre);
        await _createCase.call(entity);
      },
    );
  }

  Stream<List<SizesRopaEntity>> observeSizes() {
    return _observeCase.call();
  }
}
