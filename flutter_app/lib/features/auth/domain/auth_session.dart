class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String role;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });
}
