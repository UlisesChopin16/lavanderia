import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/theme_mode_ext.dart';
import 'package:lavanderia/features/presentation/views/view_model/home_view_model.dart';

class SwitchThemeMode extends ConsumerWidget {
  const SwitchThemeMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(homeViewModelProvider.select((value) => value.themeMode));
    final homeNotifier = ref.read(homeViewModelProvider.notifier);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return Switch(
      value: themeMode != ThemeMode.dark,
      onChanged: (value) {
        homeNotifier.setThemeMode(
          value ? ThemeMode.light : ThemeMode.dark,
        );
      },
      thumbIcon: WidgetStatePropertyAll(
        Icon(
          themeMode.icon,
          color: isDark ? onPrimaryColor : null,
        ),
      ),
      inactiveThumbColor: primaryColor,
    );
  }
}
