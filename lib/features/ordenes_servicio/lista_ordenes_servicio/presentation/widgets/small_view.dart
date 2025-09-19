import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

import 'actions_row.dart';

class SmallView extends ConsumerWidget {
  const SmallView({super.key, required this.rows});

  final List<OrdenConDetallesEntity> rows;

  static const double sizeIcon = 16.0;
  static const double textSize = 12.0;
  static const crossAxis = CrossAxisAlignment.center;
  static const minSize = MainAxisSize.min;
  static const mainAlignment = MainAxisAlignment.start;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    return Column(
      children: [
        ...List.generate(rows.length, (index) {
          final row = rows[index];
          final color = colorRowTheme?.getColor(index + 1);

          return Card(
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [Text(row.title), Text(row.creacion)],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(IconsManager.selectedOrdenServicioIcon),
                    ),
                    trailing: blockUI ? null : ActionsRow(ordenServicio: row, isSmall: true),
                    title: Text(row.cliente.fullName),
                    subtitle: Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.start,
                      children: [
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              crossAxisAlignment: crossAxis,
                              mainAxisSize: minSize,
                              children: [
                                const Icon(IconsManager.selectedPreciosIcon, size: sizeIcon),
                                Flexible(
                                  child: Text(
                                    'Total: ${row.total.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: textSize),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              crossAxisAlignment: crossAxis,
                              mainAxisSize: minSize,
                              children: [
                                const Icon(IconsManager.selectedPreciosIcon, size: sizeIcon),
                                Flexible(
                                  child: Text(
                                    'Restante: ${row.restante.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: textSize),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              crossAxisAlignment: crossAxis,
                              mainAxisSize: minSize,
                              children: [
                                const Icon(IconsManager.calendar, size: sizeIcon),
                                Flexible(
                                  child: Text(
                                    'Cierre: ${row.fechaCierre.formatDate}',
                                    style: const TextStyle(fontSize: textSize),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              crossAxisAlignment: crossAxis,
                              mainAxisSize: minSize,
                              children: [
                                const Icon(Icons.info_outline, size: sizeIcon),
                                Flexible(
                                  child: Text(
                                    'Estatus: ${row.estatus.value}',
                                    style: const TextStyle(fontSize: textSize),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
