import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
sealed class HomeModel with _$HomeModel {
  const factory HomeModel({
    @Default(1) int currentIndex,
    @Default(ThemeMode.light) ThemeMode themeMode,
  }) = _HomeModel;
}


@riverpod
class HomeViewModel extends _$HomeViewModel {
  static const keyThemeMode = 'theme_mode';
  final _sharedPreferences = instance<SharedPreferences>();

  @override
  HomeModel build() {
    return const HomeModel();
  }

  void getThemeMode() async {
    final themeModeString = _sharedPreferences.getString(keyThemeMode);
    final themeMode = themeModeString == ThemeMode.dark.toString()
        ? ThemeMode.dark
        : ThemeMode.light;
    state = state.copyWith(themeMode: themeMode);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _sharedPreferences.setString(keyThemeMode, mode.toString());
  }
  
  void toggleThemeMode() async {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: newMode);
  }
}