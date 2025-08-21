import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';
import 'package:lavanderia/shared/widgets/card_padding.dart';

class SmallView extends ConsumerWidget {
  final List<SizesRopaEntity> rows;
  const SmallView({super.key, required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return Column(
      children: [
        ...List.generate(rows.length, (index) {
          final row = rows[index];
          final color = colorRowTheme?.getColor(index + 1);
          return CardPadding(
            color: color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(row.estatus.value),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(IconsManager.selectedSizesIcon),
                  ),
                  title: Text(row.nombre),
                  subtitle: Text('Fecha de creación: ${row.fechaCreacion.formatDate}'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
