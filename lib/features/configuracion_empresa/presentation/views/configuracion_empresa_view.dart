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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Configuración de la empresa'),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
