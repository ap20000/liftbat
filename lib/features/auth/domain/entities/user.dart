import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String name;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String role;
  final String? avatarUrl;
  final bool isActive;
  final bool isEmailVerified;
  final bool isOnboarding;
  final String? redirectUrl;

  const User({
    required this.id,
    required this.email,
    this.username,
    required this.name,
    this.fullName,
    this.firstName,
    this.lastName,
    this.phone,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
    this.isEmailVerified = false,
    this.isOnboarding = false,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    name,
    fullName,
    firstName,
    lastName,
    phone,
    role,
    avatarUrl,
    isActive,
    isEmailVerified,
    isOnboarding,
    redirectUrl,
  ];
}
