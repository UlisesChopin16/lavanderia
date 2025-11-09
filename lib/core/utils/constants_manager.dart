import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/smtp_server.dart';

class ConstantsManager {
  static const double smallScreen = 600.0;
  static const double mediumScreen = 900.0;
  static const double largeScreen = 1200.0;

  static const String maskDate = 'dd/MMM/yyyy';
  static const String maskTime = 'HH:mm';
  static const String maskDateTime = 'dd/MMM/yyyy HH:mm';
  static const String emptyValue = 'N/A';

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return emptyValue;

    final format = DateFormat(maskDate, 'es_ES');
    return format.format(dateTime);
  }

  static String fullDateFormat(DateTime? dateTime) {
    if (dateTime == null) return emptyValue;

    final format = DateFormat(maskDateTime, 'es_ES');
    return format.format(dateTime);
  }

  static String get mailer => dotenv.get('MAIL_MAILER');
  static String get mailHost => dotenv.get('MAIL_HOST');
  static String get mailPort => dotenv.get('MAIL_PORT');
  static String get mailUsername => dotenv.get('MAIL_USERNAME');
  static String get mailPassword => dotenv.get('MAIL_PASSWORD');

  static final smtpServer = SmtpServer(
    mailHost,
    port: int.parse(mailPort),
    username: mailUsername,
    password: mailPassword,
    ssl: true,
    ignoreBadCertificate: false, // solo activar en pruebas
  );
}
