import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/app/theme/theme_app.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/configuracion_empresa_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const theme = ThemeApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.toThemeData(isDark: false),
      darkTheme: theme.toThemeData(isDark: true),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: const ConfiguracionEmpresaView(),
    );
  }
}
