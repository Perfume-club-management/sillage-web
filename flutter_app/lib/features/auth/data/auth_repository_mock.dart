import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/storage/secure_token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(const FlutterSecureStorage());
});

class AuthRepositoryMock implements AuthRepository {
  final SecureTokenStorage _storage;

  AuthRepositoryMock(this._storage);

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.length < 4) {
      throw Exception('Please check your email and password.');
    }

    final role = email.contains('admin') ? 'admin' : 'member';
    final session = AuthSession(
      accessToken: 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      role: role,
    );

    await _storage.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      role: session.role,
    );

    return session;
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
