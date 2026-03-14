import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository_provider.dart';
import '../domain/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo)..bootstrap();
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _streamController = StreamController<void>.broadcast();

  Stream<void> get refreshStream => _streamController.stream;

  AuthController(this._repo) : super(AuthState.initial());

  Future<void> bootstrap() async {
    try {
      final session = await _repo.restoreSession();
      state = state.copyWith(
        isInitializing: false,
        isAuthenticated: session != null,
        role: session?.role,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        isAuthenticated: false,
        role: null,
        errorMessage: e.toString(),
      );
    } finally {
      _streamController.add(null);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _streamController.add(null);

    try {
      final session = await _repo.login(email: email, password: password);
      state = state.copyWith(
        isInitializing: false,
        isLoading: false,
        isAuthenticated: true,
        role: session.role,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        isLoading: false,
        isAuthenticated: false,
        role: null,
        errorMessage: e.toString(),
      );
    }

    _streamController.add(null);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState.initial().copyWith(isInitializing: false);
    _streamController.add(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
