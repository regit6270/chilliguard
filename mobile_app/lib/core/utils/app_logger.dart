import 'package:logger/logger.dart';

/// Centralized logging utility for the application
/// Provides structured logging with different levels
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      //printTime: true,
      dateTimeFormat: DateTimeFormat.onlyTime,
    ),
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log API request
  static void apiRequest(String method, String endpoint,
      {Map<String, dynamic>? data}) {
    info('API Request: $method $endpoint', data);
  }

  /// Log API response
  static void apiResponse(String endpoint, int statusCode, {dynamic data}) {
    info('API Response: $endpoint - Status: $statusCode', data);
  }

  /// Log BLoC event
  static void blocEvent(String bloc, String event) {
    debug('BLoC Event: $bloc -> $event');
  }

  /// Log BLoC state change
  static void blocState(String bloc, String state) {
    debug('BLoC State: $bloc -> $state');
  }

  /// Log navigation
  static void navigation(String from, String to) {
    info('Navigation: $from -> $to');
  }
}
