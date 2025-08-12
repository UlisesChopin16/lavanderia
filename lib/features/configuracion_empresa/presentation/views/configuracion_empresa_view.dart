import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/datos_direccion_wrap.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/datos_empresa_column.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/pick_file_container.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/radio_colors.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/widgets/save_edit_component.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';
import 'package:lavanderia/shared/widgets/title_container.dart';

class ConfiguracionEmpresaView extends ConsumerStatefulWidget {
  const ConfiguracionEmpresaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfiguracionEmpresaViewState();
}

class _ConfiguracionEmpresaViewState extends ConsumerState<ConfiguracionEmpresaView> {

  @override
  Widget build(BuildContext context) {
    addListener();
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final (isLoading, direccion, visiblePassword) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (
          value.isLoading,
          value.direccion,
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
                        const IntrinsicHeight(
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: [
                              Column(
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
                              DatosEmpresaColumn(
                                widthField: widthField,
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
                        const DatosDireccionWrap(
                          widthField: widthField,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: const SaveEditComponent(),
        ),
        // Aquí debe de ir la logica del block progress
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  void addListener() {
    ref.listen(
      configuracionEmpresaViewModelProvider.select((value) => value.errorMessage),
      (_, next) {
        if (next.isNotEmpty) context.showErrorDialog(next);
      },
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
