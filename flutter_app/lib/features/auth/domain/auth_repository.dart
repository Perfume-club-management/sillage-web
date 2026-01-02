import 'auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({required String email, required String password});
  Future<void> logout();
  Future<bool> hasValidSession();
  Future<String?> currentRole();
}
