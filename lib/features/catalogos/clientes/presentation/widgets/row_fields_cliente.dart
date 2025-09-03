import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';

import 'fields_cliente/fields_cliente.dart';

class RowFieldsCliente extends ConsumerWidget {
  final ClienteEntity cliente;
  final ValueChanged<ClienteEntity> onChangeCliente;

  const RowFieldsCliente({
    super.key,
    required this.cliente,
    required this.onChangeCliente,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              NombresCliente(
                nombres: cliente.nombres,
                onNombresChanged: (value) {
                  onChangeCliente(
                    cliente.copyWith(nombres: value),
                  );
                },
              ),
              ApellidosCliente(
                apellidos: cliente.apellidos,
                onApellidosChanged: (value) {
                  onChangeCliente(
                    cliente.copyWith(apellidos: value),
                  );
                },
              ),
            ],
          ),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
                TelefonoCliente(
                  telefono: cliente.telefono,
                  onTelefonoChanged: (value) {
                    onChangeCliente(
                      cliente.copyWith(telefono: value),
                    );
                  },
                ),
                CorreoCliente(
                  correo: cliente.correo,
                  onCorreoChanged: (value) {
                    onChangeCliente(
                      cliente.copyWith(correo: value),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
