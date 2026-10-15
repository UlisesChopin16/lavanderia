import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/theme/color_row_theme.dart';
import 'package:lavanderia/models/data/clientes/cliente_entity.dart';
import 'item_cliente.dart';

class SmallView extends ConsumerWidget {
  final List<ClienteEntity> rows;
  const SmallView({super.key, required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    return Column(
      children: [
        ...List.generate(rows.length, (index) {
          final row = rows[index];
          final color = colorRowTheme?.getColor(index + 1);

          return Card(
            color: color,
            child: ItemCliente(
              row: row,
            ),
          );
        }),
      ],
    );
  }
}
