import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/catalogos/presentation/types/catalogos_tabs_type.dart';
import 'package:lavanderia/features/catalogos/presentation/view_model/catalogos_view_model.dart';

class CatalogosView extends ConsumerStatefulWidget {
  const CatalogosView({super.key});

  @override
  ConsumerState<CatalogosView> createState() => _CatalogosViewState();
}

class _CatalogosViewState extends ConsumerState<CatalogosView> with TickerProviderStateMixin {
  late TabController tabController;
  final length = CatalogosTabsType.values.length;
  static const _values = CatalogosTabsType.values;
  // static const _precioTab = ConfigurationTabsType.precios;

  @override
  Widget build(BuildContext context) {
    final configuracionNotifier = ref.read(catalogosViewModelProvider.notifier);
    final currentTabIndex = ref.watch(
      catalogosViewModelProvider.select((value) => value.currentTabIndex),
    );
    tabController = TabController(
      length: length,
      initialIndex: currentTabIndex,
      vsync: this,
    );
    Printer.i('Current Tab Index: $currentTabIndex');
    return Scaffold(
      appBar: TabBar(
        controller: tabController,
        onTap: configuracionNotifier.setCurrentTabIndex,
        tabs: [
          // Tab(text: 'Conceptos'),
          // Tab(text: 'Tamaños'),
          // Tab(text: 'Categorías'),
          // Tab(text: 'Precios'),
          ..._values.map((tab) {
            final isSelected = tab.index == currentTabIndex;
            final icon = isSelected ? tab.icon : tab.unselectedIcon;
            return Tab(
              text: tab.title,
              icon: Icon(icon),
            );
          }),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [..._values.map((e) => e.view)],
      ),
    );
  }
}
