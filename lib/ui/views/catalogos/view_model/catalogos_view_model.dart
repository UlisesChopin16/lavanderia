import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalogos_view_model.freezed.dart';
part 'catalogos_view_model.g.dart';

@freezed
sealed class CatalogosModel with _$CatalogosModel {
  const factory CatalogosModel({
    @Default(false) bool isLoading,
    @Default(0) int currentTabIndex,
    @Default('') String message,
  }) = _CatalogosModel;
}

@riverpod
class CatalogosViewModel extends _$CatalogosViewModel {

  @override
  CatalogosModel build() {
    return const CatalogosModel();
  }

  void setCurrentTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
