abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again later.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid credentials. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out. Please try again.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
