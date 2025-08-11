import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configuracion_general_view_model.freezed.dart';
part 'configuracion_general_view_model.g.dart';

@freezed
sealed class ConfiguracionGeneralModel with _$ConfiguracionGeneralModel {
  const factory ConfiguracionGeneralModel({
    @Default(false) bool isLoading,
    @Default(0) int currentTabIndex,
    @Default('') String message,
  }) = _ConfiguracionGeneralModel;
}

@riverpod
class ConfiguracionGeneralViewModel extends _$ConfiguracionGeneralViewModel {
  @override
  ConfiguracionGeneralModel build() {
    return const ConfiguracionGeneralModel();
  }

  void setCurrentTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
