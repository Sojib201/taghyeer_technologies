import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String token;
  final String? refreshToken;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.token,
    this.refreshToken,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, username, email, token];
}
