import 'package:go_router/go_router.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/configuracion_empresa_view.dart';
import 'package:lavanderia/features/home/presentation/views/home_view.dart';
import 'package:lavanderia/features/orden_servicio/presentation/views/orden_servicio_view.dart';

// final _shellNavigatorKey = GlobalKey<NavigatorState>();
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
class AppRoutes {
  static const String home = '/';
  static const String configuracionEmpresa = '/configuracionEmpresa/data';
  static const String ordenServicio = '/ordenServicio';
  static final routes = [
      // GoRoute(
      //   path: home,
      //   builder: (context, state) => const HomeView(),
      // ),
      ShellRoute(
        // navigatorKey: _shellNavigatorKey,
        // parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, child) => HomeView(
          child: child,
        ),
        routes: [
          GoRoute(
            // parentNavigatorKey: _shellNavigatorKey,
            name: 'configuracionEmpresa',
            path: configuracionEmpresa,
            builder: (context, state) => const ConfiguracionEmpresaView(),
          ),
          GoRoute(
            // parentNavigatorKey: _shellNavigatorKey,
            name: 'OrdenServicio',
            path: home,
            builder: (context, state) => const OrdenServicioView(),
          ),
        ],
      )
    ];

  // static final GoRouter router = GoRouter(
  //   initialLocation: home,
  //   debugLogDiagnostics: true,

  //   // navigatorKey: _rootNavigatorKey,
  //   routes: 
  // );
}
