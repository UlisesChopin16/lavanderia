import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/views/view_model/clientes_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/view/view_model/orden_servicio_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/widgets/search_cliente.dart';
import 'package:lavanderia/shared/widgets/block_progress.dart';
// import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
// import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/select_price_dialog.dart';
import 'package:mailer/mailer.dart';

import '../widgets/button_add_conceptos.dart';
import '../widgets/items_list_selected.dart';
import '../widgets/select_metodo_pago.dart';

class OrdenServicioView extends ConsumerStatefulWidget {
  const OrdenServicioView({super.key});

  @override
  ConsumerState<OrdenServicioView> createState() => _OrdenServicioViewState();
}

class _OrdenServicioViewState extends ConsumerState<OrdenServicioView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
      ordenNotifier.getClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    final (total, restante, isLoading) = ref.watch(
      ordenServicioViewProvider.select(
        (state) => (state.total, state.restante, state.isLoading),
      ),
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight - 20;
              return SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CardConceptosInfo(
                        height: height,
                      ),
                      CardClientInfo(
                        height: height,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (isLoading) const BlockProgress(),
      ],
    );
  }

  void _addErrorListener() {
    ref.listen(clientesViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  Future<void> sendMail(ClienteEntity cliente) async {
    final smtpServer = ConstantsManager.smtpServer;
    final mail = ConstantsManager.mailUsername;
    final message = Message()
      ..from = Address(mail, 'Lavanderia BlueClean')
      ..recipients.add(cliente.correo)
      ..subject = 'Orden de servicio'
      // ..text = 'Hola ${cliente.firstName}! Este es un correo enviado desde Flutter con SMTP.'
      // ..attachments.add(FileAttachment.);
      ..html =
          "<h1>Hola ${cliente.firstName}!</h1><p>Esta es tu orden de servicio. Gracias por confiar en nosotros.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ${sendReport.toString()}');
      if (!mounted) return;
      context.showSuccessDialog('Correo enviado a ${cliente.correo}');
    } on MailerException catch (e) {
      print('Error al enviar el correo: $e');
      if (!mounted) return;
      context.showErrorDialog('No se pudo enviar el correo. Intenta de nuevo.');
      for (var p in e.problems) {
        print('Problema: ${p.code}: ${p.msg}');
      }
    }
  }
}

class CardConceptosInfo extends ConsumerWidget {
  const CardConceptosInfo({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SizedBox(
        width: 500,
        height: height,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Enviar correo de prueba'),
              // ElevatedButton(
              //   onPressed: sendMail,
              //   child: const Text('Enviar correo'),
              // ),
              Expanded(child: ItemsListSelected()),
              Divider(),
              ButtonAddConceptos(),
            ],
          ),
        ),
      ),
    );
  }
}

class CardClientInfo extends ConsumerWidget {
  const CardClientInfo({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
    final (total, restante, metodoPago) = ref.watch(
      ordenServicioViewProvider.select(
        (state) => (state.total, state.restante, state.orden.metodoPago),
      ),
    );
    return Card(
      child: SizedBox(
        width: 500,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SearchCliente(),
              const Divider(),
              const Gap(5),
              // const Spacer(),
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: SelectMetodoPago(
                        metodoPago: metodoPago,
                        onChange: (value) {
                          ordenNotifier.setMetodoPago(value);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          // FilteringTextInputFormatter.deny(RegExp(r'^[^\d.]+$')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Adelanto',
                          prefixIcon: const Icon(Icons.attach_money),
                          constraints: const BoxConstraints(maxWidth: 150),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          ordenNotifier.setAdelanto(value);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Restante: \$${restante.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(5),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Notas de la orden de servicio',
                  prefixIcon: Icon(Icons.note_alt_rounded),
                ),
                onChanged: ordenNotifier.setDescripcion,
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () async {
                    ordenNotifier.createOrden();
                    // final hasCliente = ref.read(ordenServicioViewProvider).orden.hasCliente;
                    // if (!hasCliente) {
                    //   context.showErrorDialog(
                    //     'Selecciona un cliente para crear la orden de servicio.',
                    //   );
                    //   return;
                    // }
                    // ordenNotifier.setIsLoading(true);
                    // ENVIAR CORREO
                    // await sendMail(cliente);
                    // ordenNotifier.setIsLoading(false);
                    // Aquí iría la lógica para crear la orden de servicio
                    // context.showSuccessSnackBar('Orden de servicio creada para ${cliente.fullName}.');
                    // sendMail(cliente);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save),
                        Flexible(child: Text('Crear orden')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
