import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/features/presentation/types/home_tabs_type.dart';
import 'package:lavanderia/features/presentation/views/home_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String configuracionEmpresa = '/configuracionEmpresa';
  static const String ordenServicio = '/ordenServicio';
  static const String catalogos = '/catalogos';
  static const String clientes = '/clientes';

  static GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: routes,
  );
  static List<GoRoute> get _tabRoutes => HomeTabsType.values
      .map(
        (tab) => GoRoute(
          name: tab.route.name,
          path: tab.route.path,
          builder: (context, state) => tab.route.view,
        ),
      )
      .toList();

  static final routes = [
    // ShellRoute(
    //   builder: (context, state, child) => HomeView(
    //     child: child,
    //   ),
    //   routes: [
    //     ..._tabRoutes,
    //   ],
    // )
    GoRoute(
      path: home,
      name: 'Home',
      builder: (context, state) => const HomeView(),
    ),
    ..._tabRoutes,
  ];
}

class DataRoute {
  final String path;
  final String name;
  final Widget view;

  const DataRoute({
    required this.path,
    required this.name,
    required this.view,
  });
}
