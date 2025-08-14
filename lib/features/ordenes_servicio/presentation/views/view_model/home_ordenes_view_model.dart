import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_ordenes_view_model.freezed.dart';
part 'home_ordenes_view_model.g.dart';

@freezed
sealed class HomeOrdenesModel with _$HomeOrdenesModel {
  const factory HomeOrdenesModel({
    @Default(0) int currentIndex,
    @Default(false) bool isLoading,
  }) = _HomeOrdenesModel;
}


@riverpod
class HomeOrdenesViewModel extends _$HomeOrdenesViewModel {

  @override
  HomeOrdenesModel build() {
    return const HomeOrdenesModel();
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}