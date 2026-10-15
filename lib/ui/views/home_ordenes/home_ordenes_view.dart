import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/types/orden_tab_type.dart';
import 'package:lavanderia/ui/views/home_ordenes/view_model/home_ordenes_view_model.dart';

class HomeOrdenesView extends ConsumerStatefulWidget {
  const HomeOrdenesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeOrdenesViewState();
}

class _HomeOrdenesViewState extends ConsumerState<HomeOrdenesView>
    with TickerProviderStateMixin {
  // final controller = TabController(length: length, vsync: vsync)
  late TabController tabController;
  final length = OrdenTabType.values.length;
  static const _values = OrdenTabType.values;

  @override
  Widget build(BuildContext context) {
    final ordenesNotifier = ref.read(homeOrdenesViewModelProvider.notifier);
    final currentTabIndex = ref.watch(
      homeOrdenesViewModelProvider.select((value) => value.currentIndex),
    );
    tabController = TabController(
      length: length,
      initialIndex: currentTabIndex,
      vsync: this,
    );
    return Scaffold(
      appBar: TabBar(
        controller: tabController,
        onTap: ordenesNotifier.setCurrentIndex,
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
