import 'package:logger/logger.dart';

class Printer {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Número de métodos que muestra en el stack trace
      errorMethodCount: 8, // Número de métodos cuando hay error
      lineLength: 200, // Largo de línea
      colors: true, // Colores en consola
      printEmojis: true, // Muestra emojis
      dateTimeFormat: DateTimeFormat.none, // Muestra hora
    ),
  );

  /// Log nivel debug
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log nivel info
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log nivel warning
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log nivel error
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log nivel verbose (detalles extensos)
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log nivel WTF (errores críticos)
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
