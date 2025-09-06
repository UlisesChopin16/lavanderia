import 'package:flutter/material.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';

import 'actions_row.dart';

class ItemCliente extends StatelessWidget {
  final ClienteEntity row;
  final bool showActions;
  final Widget? action;
  const ItemCliente({
    super.key,
    required this.row,
    this.showActions = true,
    this.action,
  });

  Widget? get actions {
    if (!showActions) return null;
    if (action != null) return action;
    return ActionsRow(cliente: row, isSmall: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            trailing: actions,
            title: Text(row.fullName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.phone, size: 16),
                    Flexible(
                      child: Text(
                        row.telefono,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.email, size: 16),
                    Flexible(child: Text(row.correo)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 25,
          top: 8,
          child: Text(row.fechaCreacion.formatDate),
        ),
      ],
    );
  }
}
