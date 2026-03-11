abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection. Please check your network.'])
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error. Please try again later.'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Invalid credentials. Please try again.'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred.']) : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timed out. Please try again.'])
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unexpected error occurred.']) : super(message);
}
