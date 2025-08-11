import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/configuracion_general/presentation/types/configuration_tabs_type.dart';
import 'package:lavanderia/features/configuracion_general/presentation/view_model/configuracion_general_view_model.dart';

class ConfiguracionGeneralView extends ConsumerStatefulWidget {
  const ConfiguracionGeneralView({super.key});

  @override
  ConsumerState<ConfiguracionGeneralView> createState() => _ConfiguracionGeneralViewState();
}

class _ConfiguracionGeneralViewState extends ConsumerState<ConfiguracionGeneralView>
    with TickerProviderStateMixin {
  late TabController tabController;
  final length = ConfigurationTabsType.values.length;
  static const _values = ConfigurationTabsType.values;
  // static const _precioTab = ConfigurationTabsType.precios;

  @override
  Widget build(BuildContext context) {
    final configuracionNotifier = ref.read(configuracionGeneralViewModelProvider.notifier);
    final currentTabIndex = ref.watch(
      configuracionGeneralViewModelProvider.select((value) => value.currentTabIndex),
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
