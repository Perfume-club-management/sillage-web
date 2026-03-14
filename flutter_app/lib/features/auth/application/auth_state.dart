const _noChange = Object();

class AuthState {
  final bool isInitializing;
  final bool isLoading;
  final bool isAuthenticated;
  final String? role;
  final String? errorMessage;

  const AuthState({
    required this.isInitializing,
    required this.isLoading,
    required this.isAuthenticated,
    this.role,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
        isInitializing: true,
        isLoading: false,
        isAuthenticated: false,
        role: null,
        errorMessage: null,
      );

  AuthState copyWith({
    bool? isInitializing,
    bool? isLoading,
    bool? isAuthenticated,
    Object? role = _noChange,
    Object? errorMessage = _noChange,
  }) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: identical(role, _noChange) ? this.role : role as String?,
      errorMessage: identical(errorMessage, _noChange)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
