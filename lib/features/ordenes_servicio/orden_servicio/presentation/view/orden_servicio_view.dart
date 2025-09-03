import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:mailer/mailer.dart';

class OrdenServicioView extends StatefulWidget {
  const OrdenServicioView({super.key});

  @override
  State<OrdenServicioView> createState() => _OrdenServicioViewState();
}

class _OrdenServicioViewState extends State<OrdenServicioView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: sendMail,
        child: const Text('Enviar correo'),
      ),
    );
  }

  void sendMail() async {
    final smtpServer = ConstantsManager.smtpServer;
    final mail = ConstantsManager.mailUsername;
    final message = Message()
      ..from = Address(mail, 'Mi App Flutter')
      ..recipients.add('uliseschopin@outlook.com')
      ..subject = 'Correo de prueba desde Flutter'
      ..text = 'Hola! Este es un correo enviado desde Flutter con SMTP.'
      // ..attachments.add(FileAttachment.);
      ..html = "<h1>Correo en HTML</h1><p>Enviado desde Flutter 🚀</p>";
    
    try {
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Error al enviar el correo: $e');
      for (var p in e.problems) {
        print('Problema: ${p.code}: ${p.msg}');
      }
    }
  }
}
