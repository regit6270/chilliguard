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
    output: ConsoleOutput(), // ✅ Ensures output to console
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    print('🐛 $message'); // ✅ Also print directly
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    print('ℹ️ $message'); // ✅ Also print directly
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    print('⚠️ $message'); // ✅ Also print directly
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    print('❌ $message'); // ✅ Also print directly
  }

  /// Log fatal error
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    print('💥 $message'); // ✅ Also print directly
  }

  /// Log API request
  static void apiRequest(String method, String endpoint,
      {Map<String, dynamic>? data}) {
    info('API Request: $method $endpoint', data);
    print('📡 API Request: $method $endpoint'); // ✅ Also print directly
  }

  /// Log API response
  static void apiResponse(String endpoint, int statusCode, {dynamic data}) {
    info('API Response: $endpoint - Status: $statusCode', data);
    print(
        '📡 API Response: $endpoint - Status: $statusCode'); // ✅ Also print directly
  }

  /// Log BLoC event
  static void blocEvent(String bloc, String event) {
    debug('BLoC Event: $bloc -> $event');
    print('📡 BLoC Event: $bloc -> $event'); // ✅ Also print directly
  }

  /// Log BLoC state change
  static void blocState(String bloc, String state) {
    debug('BLoC State: $bloc -> $state');
    print('📡 BLoC State: $bloc -> $state'); // ✅ Also print directly
  }

  /// Log navigation
  static void navigation(String from, String to) {
    info('Navigation: $from -> $to');
    print('📡 Navigation: $from -> $to'); // ✅ Also print directly
  }
}
