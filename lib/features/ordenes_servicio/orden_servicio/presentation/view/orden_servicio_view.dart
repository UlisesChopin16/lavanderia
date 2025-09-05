import 'package:flutter/material.dart';
// import 'package:lavanderia/core/utils/constants_manager.dart';
// import 'package:lavanderia/features/ordenes_servicio/orden_servicio/domain/entities/items_servicio/item_con_precio_entity.dart';
// import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/dialogs/select_price_dialog.dart';
// import 'package:mailer/mailer.dart';

class OrdenServicioView extends StatefulWidget {
  const OrdenServicioView({super.key});

  @override
  State<OrdenServicioView> createState() => _OrdenServicioViewState();
}

class _OrdenServicioViewState extends State<OrdenServicioView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return SingleChildScrollView(
          child: Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Card(
                  child: SizedBox(
                    width: 500,
                    height: height,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Enviar correo de prueba'),
                        // ElevatedButton(
                        //   onPressed: sendMail,
                        //   child: const Text('Enviar correo'),
                        // ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: 500,
                    height: height,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Enviar correo de prueba'),
                        // ElevatedButton(
                        //   onPressed: sendMail,
                        //   child: const Text('Enviar correo'),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ElevatedButton(
  //           onPressed: () async {
  //             final result = await showDialog<List<ItemConPrecioEntity>>(
  //               context: context,
  //               barrierDismissible: false,
  //               builder: (context) {
  //                 return SelectPriceDialog(itemsSelected: itemsSelected);
  //               },
  //             );
  //             if (result != null) {
  //               setState(() {
  //                 itemsSelected = result;
  //               });
  //             }
  //           },
  //           child: const Text('Mostrar diálogo'),
  //         ),

  // void sendMail() async {
  //   final smtpServer = ConstantsManager.smtpServer;
  //   final mail = ConstantsManager.mailUsername;
  //   final message = Message()
  //     ..from = Address(mail, 'Mi App Flutter')
  //     ..recipients.add('uliseschopin@outlook.com')
  //     ..subject = 'Correo de prueba desde Flutter'
  //     ..text = 'Hola! Este es un correo enviado desde Flutter con SMTP.'
  //     // ..attachments.add(FileAttachment.);
  //     ..html = "<h1>Correo en HTML</h1><p>Enviado desde Flutter 🚀</p>";

  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Correo enviado: ${sendReport.toString()}');
  //   } on MailerException catch (e) {
  //     print('Error al enviar el correo: $e');
  //     for (var p in e.problems) {
  //       print('Problema: ${p.code}: ${p.msg}');
  //     }
  //   }
  // }
}
