import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(const FlutterSecureStorage());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  return AuthRepositoryMock(storage);
});

class AuthRepositoryMock implements AuthRepository {
  final SecureTokenStorage _storage;
  String? _roleCache;

  AuthRepositoryMock(this._storage);

  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    // 데모: 네트워크 지연 흉내
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // 보안: password를 어디에도 출력/로그하지 말 것
    if (email.trim().isEmpty || password.length < 4) {
      throw Exception('이메일/비밀번호를 확인해주세요.');
    }

    // 역할 예시: 이메일로 단순 분기(나중에 백엔드 claims로 교체)
    final role = email.contains('admin') ? 'admin' : 'member';
    _roleCache = role;

    final tokens = AuthTokens(
      accessToken: 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      role: role,
    );

    await _storage.save(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken);
    return tokens;
  }

  @override
  Future<void> logout() async {
    _roleCache = null;
    await _storage.clear();
  }

  @override
  Future<bool> hasValidSession() async {
    // 지금은 access token 존재 여부만 체크(추후 exp 검사 + refresh 검증)
    final access = await _storage.readAccessToken();
    return access != null && access.isNotEmpty;
  }

  @override
  Future<String?> currentRole() async => _roleCache;
}
