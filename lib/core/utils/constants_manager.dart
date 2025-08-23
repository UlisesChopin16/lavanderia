import 'package:intl/intl.dart';

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
}
