class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message) : super(code: 'network_error');
}

class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class ValidationException extends AppException {
  ValidationException(super.message) : super(code: 'validation_error');
}

class ServerException extends AppException {
  ServerException(super.message) : super(code: 'server_error');
}