import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<void> logout();
  Future<UserModel> verifyMagicLink(String token);
  Future<UserModel> getCurrentUser();
  Future<String> refreshToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Future<void> logout() async {
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('refresh_token');
  }

  @override
  Future<UserModel> verifyMagicLink(String token) async {
    final response = await dio.post(
      '/api/auth/magic-link/verify',
      data: {'token': token},
    );

    final dynamic data = response.data;
    String? accessToken;
    String? refreshToken;

    if (data is Map<String, dynamic>) {
      accessToken = data['access_token'];
      refreshToken = data['refresh_token'];
    } else if (data is String) {
      accessToken = data;
    }

    if (accessToken != null) {
      await sharedPreferences.setString('auth_token', accessToken);
    }
    if (refreshToken != null) {
      await sharedPreferences.setString('refresh_token', refreshToken);
    }

    return await getCurrentUser();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dio.get('/api/auth/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<String> refreshToken() async {
    final response = await dio.post('/api/auth/refresh');
    final dynamic data = response.data;

    String? accessToken;
    String? refreshToken;

    if (data is Map<String, dynamic>) {
      accessToken = data['access_token'];
      refreshToken = data['refresh_token'];
    } else if (data is String) {
      accessToken = data;
    }

    if (accessToken != null) {
      await sharedPreferences.setString('auth_token', accessToken);
    }
    if (refreshToken != null) {
      await sharedPreferences.setString('refresh_token', refreshToken);
    }

    return accessToken ?? '';
  }
}
