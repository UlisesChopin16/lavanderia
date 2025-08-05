import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
sealed class HomeModel with _$HomeModel {
  const factory HomeModel({
    @Default(0) int currentIndex,
    @Default(ThemeMode.light) ThemeMode themeMode,
  }) = _HomeModel;
}


@riverpod
class HomeViewModel extends _$HomeViewModel {

  @override
  HomeModel build() {
    return const HomeModel();
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }
  
  void toggleThemeMode() {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: newMode);
  }
}