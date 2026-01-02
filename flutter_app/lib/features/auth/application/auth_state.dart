class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? role; // admin/officer/member
  final String? errorMessage;

  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.role,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
        isLoading: false,
        isAuthenticated: false,
        role: null,
        errorMessage: null,
      );

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? role,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      errorMessage: errorMessage,
    );
  }
}
