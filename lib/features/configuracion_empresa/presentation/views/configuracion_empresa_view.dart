import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfiguracionEmpresaView extends ConsumerStatefulWidget {
  const ConfiguracionEmpresaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfiguracionEmpresaViewState();
}

class _ConfiguracionEmpresaViewState extends ConsumerState<ConfiguracionEmpresaView> {
  @override
  Widget build(BuildContext context) {
    final appBarThemeColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarThemeColor,
        title: const Text(
          'Configuración Empresa',
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth * 0.3;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Container(
                      color: Colors.red,
                      height: height,
                      width: width,
                    ),
                    Container(
                      color: Colors.blue,
                      height: height,
                      width: width,
                    ),
                    Container(
                      color: Colors.green,
                      height: height,
                      width: width,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
