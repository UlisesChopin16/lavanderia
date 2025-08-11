import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/app/inject/injector.dart';
import 'package:lavanderia/app/routes/app_routes.dart';
import 'package:lavanderia/app/theme/theme_app.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/presentation/views/view_model/home_view_model.dart';

void main() {
  configureDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     const theme = ThemeApp();
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: theme.toThemeData(isDark: false),
//       darkTheme: theme.toThemeData(isDark: true),
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.dark,
//       home: const ConfiguracionEmpresaView(),
//     );
//   }
// }

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => value.configuracionEmpresa.colorParsed,
      ),
    );
    final themeMode = ref.watch(
      homeViewModelProvider.select(
        (value) => value.themeMode,
      ),
    );
    // final mode = ref
    final theme = ThemeApp(primaryColor: color);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: theme.toThemeData(isDark: false),
      darkTheme: theme.toThemeData(isDark: true),
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      routerConfig: GoRouter(
        initialLocation: AppRoutes.home,
        debugLogDiagnostics: true,
        routes: AppRoutes.routes,
        // refreshListenable:
        //   ref.watch(homeViewModelProvider),
      ),

      // home: const HomeView(),
    );
  }
}
