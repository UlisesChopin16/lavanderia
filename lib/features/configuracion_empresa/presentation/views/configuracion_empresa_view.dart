import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/pick_file_container.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/radio_colors.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';
import 'package:lavanderia/shared/widgets/title_container.dart';
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
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final (isLoading, direccion, configuracionEmpresa, visiblePassword) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (
          value.isLoading,
          value.direccion,
          value.configuracionEmpresa,
          value.visiblePassword,
        ),
      ),
    );

    const width = 300.0;
    const height = 300.0;
    const maxWidth = width * 3;
    const widthField = 400.0;

    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: maxWidth,
                    ),
                    child: Column(
                      spacing: 15,
                      children: [
                        const TitleContainer(
                          title: 'Configuración de la Empresa',
                          icon: IconsManager.selectedEmpresaIcon,
                        ),
                        IntrinsicHeight(
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: [
                              const Column(
                                children: [
                                  PickFileContainer(
                                    height: height,
                                    width: widthField,
                                  ),
                                  RadioColors(
                                    width: widthField,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 15,
                                children: [
                                  TextFormField(
                                    initialValue: configuracionEmpresa.nombre,
                                    decoration: const InputDecoration(
                                      constraints: BoxConstraints(maxWidth: widthField),
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
                                    decoration: const InputDecoration(
                                      constraints: BoxConstraints(maxWidth: widthField),
                                      labelText: 'Teléfono',
                                      hintText: 'Ingrese el teléfono de la empresa',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    initialValue: configuracionEmpresa.correo,
                                    decoration: const InputDecoration(
                                      constraints: BoxConstraints(maxWidth: widthField),
                                      labelText: 'Correo Electrónico',
                                      hintText: 'Ingrese el correo electrónico de la empresa',
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: configuracionEmpresa.paginaWeb,
                                    decoration: const InputDecoration(
                                      constraints: BoxConstraints(maxWidth: widthField),
                                      labelText: 'Página Web',
                                      hintText: 'Ingrese la página web de la empresa',
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: configuracionEmpresa.password,
                                    obscureText: !visiblePassword,
                                    onChanged: configuracionNotifier.setPassword,
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxWidth: widthField),
                                      labelText: 'Contraseña',
                                      hintText: 'Ingrese la contraseña de la empresa',
                                      suffixIcon: IconButton(
                                        isSelected: visiblePassword,
                                        icon: Icon(
                                          visiblePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: configuracionNotifier.toggleVisiblePassword,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            const Expanded(child: Divider()),
                            Text(
                              'Dirección de la Empresa',
                              style: titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            TextFormField(
                              initialValue: direccion.calle,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Nombre de la Calle',
                                hintText: 'Ingrese el nombre de la calle',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.numeroExterior,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Número',
                                hintText: 'Ingrese el número de la calle',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.numeroInterior,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Número Interior',
                                hintText: 'Ingrese el número interior de la calle (opcional)',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.colonia,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Colonia',
                                hintText: 'Ingrese la colonia de la calle (opcional)',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.ciudad,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Ciudad',
                                hintText: 'Ingrese la ciudad de la calle (opcional)',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.estado,
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Estado',
                                hintText: 'Ingrese el estado de la calle (opcional)',
                              ),
                            ),
                            TextFormField(
                              initialValue: direccion.codigoPostal.toString(),
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(maxWidth: widthField),
                                labelText: 'Código Postal',
                                hintText: 'Ingrese el código postal de la calle (opcional)',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
