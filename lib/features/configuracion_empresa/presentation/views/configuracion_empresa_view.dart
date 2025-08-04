import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/pick_file_container.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConfiguracionEmpresaView extends ConsumerStatefulWidget {
  const ConfiguracionEmpresaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfiguracionEmpresaViewState();
}

class _ConfiguracionEmpresaViewState extends ConsumerState<ConfiguracionEmpresaView> {
  final phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final appBarThemeColor = Theme.of(context).colorScheme.primary;
    final (isLoading, direccion, configuracionEmpresa) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (value.isLoading, value.direccion, value.configuracionEmpresa),
      ),
    );
    final widthScreen = MediaQuery.of(context).size.width;
    // final isBigScreen = widthScreen >= ConstantsManager.largeScreen;
    final width = getWidthContainer(widthScreen);
    const height = 500.0;
    final maxWidth = width * 2 + 40;
    // final widthContainer = widthScreen < 1300 ? maxWidth : width;
    // Printer.i('is same: ${widthScreen == maxWidth}');
    // Printer.i('width: $widthScreen, maxWidth: $maxWidth');
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: appBarThemeColor,
            title: const Text(
              'Configuración Empresa',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    PickFileContainer(
                      height: height,
                      width: width,
                    ),
                    SizedBox(
                      // color: Colors.blue,
                      width: maxWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            TextFormField(
                              initialValue: configuracionEmpresa.nombre,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(maxWidth: width),
                                labelText: 'Nombre de la Empresa',
                                hintText: 'Ingrese el nombre de la empresa',
                              ),
                              onChanged: configuracionNotifier.setNombre,
                            ),
                            TextFormField(
                              initialValue: configuracionEmpresa.telefono,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                                phoneMask,
                              ],
                              decoration: InputDecoration(
                                constraints: BoxConstraints(maxWidth: width),
                                labelText: 'Teléfono',
                                hintText: 'Ingrese el teléfono de la empresa',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: configuracionEmpresa.correo,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(maxWidth: width),
                                labelText: 'Correo Electrónico',
                                hintText: 'Ingrese el correo electrónico de la empresa',
                              ),
                            ),
                            TextFormField(
                              initialValue: configuracionEmpresa.paginaWeb,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(maxWidth: width),
                                labelText: 'Página Web',
                                hintText: 'Ingrese la página web de la empresa',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   color: Colors.green,
                    //   height: height,
                    //   width: width,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Aquí debe de ir la logica del block progress
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  double getWidthContainer(double widthScreen) {
    final isMedium =
        widthScreen > ConstantsManager.smallScreen && widthScreen < ConstantsManager.largeScreen;
    final isBigScreen = widthScreen >= ConstantsManager.largeScreen;

    if (isBigScreen) {
      return widthScreen * 0.3;
    }
    if (isMedium) {
      return widthScreen * 0.4;
    }
    return widthScreen;
  }
}
