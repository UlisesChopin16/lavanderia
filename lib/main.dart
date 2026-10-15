import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:lavanderia/ui/shared/widgets/date_range_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lavanderia/inject/injector.dart';
import 'package:lavanderia/services/printer.dart';
import 'package:lavanderia/ui/routes/app_routes.dart';
import 'package:lavanderia/theme/theme_app.dart';
import 'package:lavanderia/ui/views/configuracion_empresa/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/ui/views/home/view_model/home_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await SharedPreferencesModule.init();
  await initializeDateFormatting('es_ES');
  await dotenv.load(fileName: ".env");
  await windowManager.ensureInitialized();
  final isFirstInstance = await FlutterSingleInstance().isFirstInstance();
  if (isFirstInstance) {
    runApp(const ProviderScope(child: MyApp()));
  } else {
    Printer.i("App is already running");

    final err = await FlutterSingleInstance().focus();

    if (err != null) {
      Printer.e("Error focusing running instance: $err");
    }

    exit(0);
  }

  // runApp(const ProviderScope(child: MyApp()));
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
      final homeNotifier = ref.read(homeViewModelProvider.notifier);
      configuracionNotifier.initialize();
      homeNotifier.getThemeMode();
    });
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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      themeMode: themeMode,
      routerConfig: AppRoutes.router,

      // home: const HomeView(),
    );
  }
}

// class Main extends StatelessWidget {
//   const Main({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: DateRangePicker(),
//       ),
//     );
//   }
// }
