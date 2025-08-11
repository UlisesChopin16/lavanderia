import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/extensions/theme_mode_ext.dart';
import 'package:lavanderia/features/presentation/types/home_tabs_type.dart';
import 'package:lavanderia/features/presentation/views/view_model/home_view_model.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  static const tabs = HomeTabsType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeViewModelProvider.notifier);
    final (index, themeMode) = ref.watch(
      homeViewModelProvider.select(
        (value) => (value.currentIndex, value.themeMode),
      ),
    );
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 80,
            child: NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (indexPage) {
                homeNotifier.setCurrentIndex(indexPage);
                // if (indexPage == index) return;
                // context.go(tabs[indexPage].route.path);
              },
              elevation: 5,
              labelType: NavigationRailLabelType.all,
              minWidth: 100,
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  homeNotifier.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
                thumbIcon: WidgetStatePropertyAll(
                  Icon(
                    themeMode.icon,
                  ),
                ),
              ),
              destinations: [
                for (var tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.unselectedIcon),
                    selectedIcon: Icon(tab.icon),
                    label: Text(tab.title, textAlign: TextAlign.center),
                  ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: tabs[index].route.view,
          )
        ],
      ),
    );
  }
}
