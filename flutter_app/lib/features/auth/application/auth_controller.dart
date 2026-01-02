import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository_mock.dart';
import '../domain/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo)..bootstrap();
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _streamController = StreamController<void>.broadcast();
  Stream<void> get stream => _streamController.stream;

  AuthController(this._repo) : super(AuthState.initial());

  Future<void> bootstrap() async {
    final ok = await _repo.hasValidSession();
    if (ok) {
      final role = await _repo.currentRole();
      state = state.copyWith(isAuthenticated: true, role: role, errorMessage: null);
    }
    _streamController.add(null);
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _streamController.add(null);

    try {
      final tokens = await _repo.login(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        role: tokens.role,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isAuthenticated: false, errorMessage: e.toString());
    }

    _streamController.add(null);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState.initial();
    _streamController.add(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
