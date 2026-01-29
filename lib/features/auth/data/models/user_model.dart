import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.username,
    required super.name,
    super.fullName,
    super.firstName,
    super.lastName,
    super.phone,
    required super.role,
    super.avatarUrl,
    super.isActive = true,
    super.isEmailVerified = false,
    super.isOnboarding = false,
    super.redirectUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      name:
          json['name'] ??
          json['full_name'] ??
          '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      fullName: json['full_name'],
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      phone: json['phone'],
      role: json['role'] ?? 'user',
      avatarUrl: json['avatarUrl'],
      isActive: json['is_active'] ?? true,
      isEmailVerified: json['is_email_verified'] ?? false,
      isOnboarding: json['isOnboarding'] ?? json['is_onboarding'] ?? false,
      redirectUrl: json['redirectUrl'] ?? json['redirect_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'full_name': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'avatarUrl': avatarUrl,
      'is_active': isActive,
      'is_email_verified': isEmailVerified,
      'isOnboarding': isOnboarding,
      'redirectUrl': redirectUrl,
    };
  }
}
