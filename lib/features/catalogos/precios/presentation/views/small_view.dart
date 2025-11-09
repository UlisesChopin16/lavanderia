import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

import '../widgets/actions_row.dart';

class SmallView extends ConsumerWidget {
  final List<PrecioConDetallesEntity> rows;
  const SmallView({super.key, required this.rows});

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
            child: Stack(
              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(IconsManager.clotheIcon),
                    ),
                    trailing: blockUI ? null : ActionsRow(precio: row, isSmall: true),
                    title: Text(
                      '${row.nombreConcepto} - ${row.size.description} - ${row.categoria.nombre}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio: \$${row.importe.toStringAsFixed(2)} por ${row.tipoUnidad.value}',
                        ),
                        Text('Fecha de creación: ${row.fechaCreacion.formatDate}'),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 25,
                  top: 8,
                  child: Text(row.estatus.value),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
