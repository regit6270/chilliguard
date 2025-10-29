class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class ModelException implements Exception {
  final String message;
  ModelException(this.message);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}
