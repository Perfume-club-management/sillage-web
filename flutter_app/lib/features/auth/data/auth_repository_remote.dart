import 'package:dio/dio.dart';

import '../../../core/storage/secure_token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';

class AuthRepositoryRemote implements AuthRepository {
  final Dio _dio;
  final SecureTokenStorage _storage;

  AuthRepositoryRemote(this._dio, this._storage);

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data ?? const <String, dynamic>{};
      final accessToken = data['access_token'] as String?;
      final refreshToken = data['refresh_token'] as String?;
      final role = data['role'] as String?;

      if (_isBlank(accessToken) || _isBlank(refreshToken) || _isBlank(role)) {
        throw Exception('Invalid auth response payload.');
      }

      final session = AuthSession(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        role: role!,
      );

      await _storage.save(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        role: session.role,
      );

      return session;
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map<String, dynamic>
          ? (data['message'] as String?) ?? 'Login failed.'
          : 'Login failed.';
      throw Exception(message);
    }
  }

  @override
  Future<void> logout() async {
    await _storage.clear();
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final accessToken = await _storage.readAccessToken();
    final refreshToken = await _storage.readRefreshToken();
    final role = await _storage.readRole();

    if (_isBlank(accessToken) || _isBlank(refreshToken) || _isBlank(role)) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken!,
      refreshToken: refreshToken!,
      role: role!,
    );
  }

  bool _isBlank(String? value) => value == null || value.isEmpty;
}
